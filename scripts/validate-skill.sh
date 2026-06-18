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
#   ./scripts/validate-skill.sh .claude/skills .claude/SKILLS_INDEX.md
#
# Checks:
#   - Skill directory name uses lowercase kebab-case
#   - SKILL.md exists
#   - Frontmatter includes name and description
#   - Description is specific enough
#   - Required sections exist
#   - High-risk domains code/db/ops disable automatic invocation
#   - Scripts do not contain risky commands
#   - SKILLS_INDEX.md structure and rows match Skill metadata
#
# Exit code:
#   0 = no blocking errors
#   1 = blocking validation errors found

ROOT="${1:-.claude/skills}"
INDEX_PATH="${2:-}"

if [[ ! -d "$ROOT" ]]; then
  echo "Error: Skills directory not found: $ROOT" >&2
  exit 1
fi

ERRORS=0
WARNINGS=0
SUMMARY_FILE="$(mktemp)"
trap 'rm -f "$SUMMARY_FILE"' EXIT

print_header() {
  echo ""
  echo "== $1 =="
}

add_error() {
  echo "  [ERROR] $1"
  ERRORS=$((ERRORS + 1))
}

add_warning() {
  echo "  [WARN]  $1"
  WARNINGS=$((WARNINGS + 1))
}

add_ok() {
  echo "  [OK]    $1"
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

detect_index_path() {
  if [[ -n "$INDEX_PATH" ]]; then
    echo "$INDEX_PATH"
  elif [[ -f "$(dirname "$ROOT")/SKILLS_INDEX.md" ]]; then
    echo "$(dirname "$ROOT")/SKILLS_INDEX.md"
  fi
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

  local domain auto_trigger
  domain="${skill_name%%-*}"
  auto_trigger="Yes"
  if frontmatter_has_true "$skill_md" "disable-model-invocation"; then
    auto_trigger="No"
  fi
  echo "$skill_name|$domain|$auto_trigger" >> "$SUMMARY_FILE"
}

validate_index() {
  local index_path
  index_path="$(detect_index_path)"

  if [[ -z "$index_path" ]]; then
    add_warning "SKILLS_INDEX.md not found next to the Skills directory. Recommended for active Skill collections."
    return
  fi

  print_header "SKILLS_INDEX.md"
  add_ok "Index path: $index_path"

  if ! grep -Eq '^\|\s*Skill\s*\|\s*Domain\s*\|\s*Scope\s*\|\s*Status\s*\|\s*Risk\s*\|\s*Auto trigger\s*\|\s*Purpose\s*\|$' "$index_path"; then
    add_error "Index header does not match the required format."
  else
    add_ok "Index header matches the required format"
  fi

  if ! grep -Eq '^\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|[^|]+\|$' "$index_path"; then
    add_warning "Index contains no Skill rows."
    return
  fi

  while IFS='|' read -r skill_name domain auto_trigger; do
    [[ -n "$skill_name" ]] || continue

    local row row_count row_domain row_auto
    row="$(grep -E "^\|[[:space:]]*$skill_name[[:space:]]*\|" "$index_path" || true)"
    if [[ -z "$row" ]]; then
      add_warning "Missing index row for Skill: $skill_name"
      continue
    fi

    row_count="$(grep -Ec "^\|[[:space:]]*$skill_name[[:space:]]*\|" "$index_path" || true)"
    if [[ "$row_count" -gt 1 ]]; then
      add_warning "Duplicate index rows found for Skill: $skill_name"
    fi

    row_domain="$(echo "$row" | awk -F'|' 'NR==1 { gsub(/^[ \t]+|[ \t]+$/, "", $3); print $3 }')"
    row_auto="$(echo "$row" | awk -F'|' 'NR==1 { gsub(/^[ \t]+|[ \t]+$/, "", $7); print $7 }')"

    if [[ "$row_domain" != "$domain" ]]; then
      add_warning "Index domain mismatch for $skill_name: $row_domain != $domain"
    fi

    if [[ "$row_auto" != "$auto_trigger" ]]; then
      add_warning "Index auto trigger mismatch for $skill_name: $row_auto != $auto_trigger"
    fi
  done < "$SUMMARY_FILE"
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

validate_index

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
