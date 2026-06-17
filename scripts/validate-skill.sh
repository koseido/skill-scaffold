#!/usr/bin/env bash
set -euo pipefail

# validate-skill.sh
#
# Validate local AI Skill directories.
#
# Usage:
#   ./scripts/validate-skill.sh
#   ./scripts/validate-skill.sh .claude/skills
#   ./scripts/validate-skill.sh ~/.claude/skills
#   ./scripts/validate-skill.sh skills
#
# Checks:
#   - Skill directory name uses lowercase kebab-case
#   - SKILL.md exists
#   - Frontmatter includes name and description
#   - Description is specific enough
#   - Required sections exist
#   - High-risk domains code/db/ops disable automatic invocation
#   - Scripts do not contain risky commands
#
# Exit code:
#   0 = no blocking errors
#   1 = blocking validation errors found

ROOT="${1:-.claude/skills}"

if [[ ! -d "$ROOT" ]]; then
  echo "Error: Skills directory not found: $ROOT" >&2
  exit 1
fi

ERRORS=0
WARNINGS=0

print_header() {
  echo ""
  echo "== $1 =="
}

add_error() {
  echo "  ❌ $1"
  ERRORS=$((ERRORS + 1))
}

add_warning() {
  echo "  ⚠️  $1"
  WARNINGS=$((WARNINGS + 1))
}

add_ok() {
  echo "  ✅ $1"
}

has_required_section() {
  local file="$1"
  local section="$2"
  grep -Eq "^##[[:space:]]+$section[[:space:]]*$" "$file"
}

extract_frontmatter_value() {
  local file="$1"
  local key="$2"
  awk -v key="$key" '
    BEGIN { in_fm=0 }
    NR == 1 && $0 == "---" { in_fm=1; next }
    in_fm && $0 == "---" { exit }
    in_fm && $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "", $0)
      print $0
      exit
    }
  ' "$file"
}

frontmatter_has_key() {
  local file="$1"
  local key="$2"
  awk -v key="$key" '
    BEGIN { in_fm=0; found=0 }
    NR == 1 && $0 == "---" { in_fm=1; next }
    in_fm && $0 == "---" { exit }
    in_fm && $0 ~ "^" key ":" { found=1; exit }
    END { exit found ? 0 : 1 }
  ' "$file"
}

frontmatter_has_true() {
  local file="$1"
  local key="$2"
  awk -v key="$key" '
    BEGIN { in_fm=0; found=0 }
    NR == 1 && $0 == "---" { in_fm=1; next }
    in_fm && $0 == "---" { exit }
    in_fm && $0 ~ "^" key ":[[:space:]]*true[[:space:]]*$" { found=1; exit }
    END { exit found ? 0 : 1 }
  ' "$file"
}

description_looks_vague() {
  local desc="$1"
  local length="${#desc}"

  if [[ "$length" -lt 80 ]]; then
    return 0
  fi

  if [[ "$desc" =~ ^[Hh]elps[[:space:]] ]]; then
    return 0
  fi

  if [[ ! "$desc" =~ [Uu]se[[:space:]]when && ! "$desc" =~ [Ww]hen[[:space:]] ]]; then
    return 0
  fi

  if [[ ! "$desc" =~ [Dd]o[[:space:]]not[[:space:]]use && ! "$desc" =~ [Nn]ot[[:space:]]for ]]; then
    return 0
  fi

  return 1
}

is_high_risk_skill() {
  local skill_name="$1"

  if [[ "$skill_name" =~ ^code- || "$skill_name" =~ ^db- || "$skill_name" =~ ^ops- ]]; then
    return 0
  fi

  return 1
}

check_risky_scripts() {
  local skill_dir="$1"

  if [[ ! -d "$skill_dir/scripts" ]]; then
    return 0
  fi

  local risky_pattern='rm -rf|curl[[:space:]]|wget[[:space:]]|ssh[[:space:]]|scp[[:space:]]|git push|git reset --hard|sudo[[:space:]]|chmod[[:space:]]+777|\.env|~/.ssh|id_rsa|id_ed25519'

  local matches
  matches="$(grep -RInE "$risky_pattern" "$skill_dir/scripts" 2>/dev/null || true)"

  if [[ -n "$matches" ]]; then
    add_warning "Risky commands or sensitive patterns found under scripts/:"
    echo "$matches" | sed 's/^/     /'
  else
    add_ok "No risky script commands detected"
  fi
}

validate_one_skill() {
  local skill_dir="$1"
  local skill_name
  skill_name="$(basename "$skill_dir")"
  local skill_md="$skill_dir/SKILL.md"

  print_header "$skill_name"

  if [[ ! "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    add_error "Invalid directory name. Use lowercase kebab-case."
  else
    add_ok "Directory name uses lowercase kebab-case"
  fi

  if [[ ! -f "$skill_md" ]]; then
    add_error "Missing SKILL.md"
    return
  else
    add_ok "SKILL.md exists"
  fi

  if [[ "$(head -n 1 "$skill_md")" != "---" ]]; then
    add_error "SKILL.md must start with YAML frontmatter"
  else
    add_ok "Frontmatter detected"
  fi

  if frontmatter_has_key "$skill_md" "name"; then
    local fm_name
    fm_name="$(extract_frontmatter_value "$skill_md" "name")"
    add_ok "Frontmatter includes name: $fm_name"

    if [[ "$fm_name" != "$skill_name" ]]; then
      add_warning "Frontmatter name does not match directory name: $fm_name != $skill_name"
    fi
  else
    add_error "Frontmatter missing name"
  fi

  if frontmatter_has_key "$skill_md" "description"; then
    local desc
    desc="$(extract_frontmatter_value "$skill_md" "description")"
    add_ok "Frontmatter includes description"

    if description_looks_vague "$desc"; then
      add_warning "Description may be too vague. Use: what it does + when to use + when not to use + keywords."
    else
      add_ok "Description looks specific"
    fi
  else
    add_error "Frontmatter missing description"
  fi

  local required_sections=(
    "Purpose"
    "Best for"
    "Not for"
    "Required inputs"
    "Workflow"
    "Output format"
    "Safety rules"
  )

  for section in "${required_sections[@]}"; do
    if has_required_section "$skill_md" "$section"; then
      add_ok "Section exists: $section"
    else
      add_warning "Missing recommended section: $section"
    fi
  done

  if is_high_risk_skill "$skill_name"; then
    if frontmatter_has_true "$skill_md" "disable-model-invocation"; then
      add_ok "High-risk Skill disables automatic invocation"
    else
      add_warning "High-risk Skill should usually include: disable-model-invocation: true"
    fi
  fi

  if [[ -d "$skill_dir/scripts" ]]; then
    add_warning "scripts/ exists. Ensure scripts are necessary and safe."
    check_risky_scripts "$skill_dir"
  else
    add_ok "No scripts/ directory"
  fi

  if [[ -d "$skill_dir/references" ]]; then
    add_ok "references/ exists"
  else
    add_warning "references/ missing. Recommended for non-trivial Skills."
  fi

  if [[ -d "$skill_dir/templates" ]]; then
    add_ok "templates/ exists"
  else
    add_warning "templates/ missing. Recommended for reusable output formats."
  fi

  if [[ -d "$skill_dir/examples" ]]; then
    add_ok "examples/ exists"
  else
    add_warning "examples/ missing. Recommended for trigger examples."
  fi
}

print_header "Validating Skills"
echo "Root: $ROOT"

FOUND=0

for skill_dir in "$ROOT"/*; do
  [[ -d "$skill_dir" ]] || continue
  FOUND=$((FOUND + 1))
  validate_one_skill "$skill_dir"
done

if [[ "$FOUND" -eq 0 ]]; then
  echo "No Skill directories found under: $ROOT"
  exit 0
fi

print_header "Summary"
echo "Skills checked: $FOUND"
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

if [[ "$ERRORS" -gt 0 ]]; then
  echo ""
  echo "Validation failed with blocking errors."
  exit 1
fi

echo ""
echo "Validation completed."
exit 0
