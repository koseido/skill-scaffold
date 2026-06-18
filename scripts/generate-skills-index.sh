#!/usr/bin/env bash
set -euo pipefail

# generate-skills-index.sh
#
# Generate a SKILLS_INDEX.md file from a Skill directory.
#
# Usage:
#   ./scripts/generate-skills-index.sh
#   ./scripts/generate-skills-index.sh .claude/skills
#   ./scripts/generate-skills-index.sh .claude/skills .claude/SKILLS_INDEX.md
#   SKILL_SCOPE=global ./scripts/generate-skills-index.sh ~/.claude/skills

ROOT="${1:-.claude/skills}"
INDEX_PATH="${2:-}"
SCOPE_OVERRIDE="${SKILL_SCOPE:-auto}"

if [[ ! -d "$ROOT" ]]; then
  echo "Error: Skills directory not found: $ROOT" >&2
  exit 1
fi

if [[ -z "$INDEX_PATH" ]]; then
  INDEX_PATH="$(dirname "$ROOT")/SKILLS_INDEX.md"
fi

infer_scope() {
  local root="$1"
  local normalized="${root//\\//}"

  if [[ "$SCOPE_OVERRIDE" != "auto" ]]; then
    echo "$SCOPE_OVERRIDE"
    return
  fi

  if [[ "$normalized" == *"/skills-lab"* ]]; then
    echo "lab"
  elif [[ "$normalized" == *"/skills-disabled"* ]]; then
    echo "disabled"
  elif [[ "$normalized" == *"/skills-archive"* ]]; then
    echo "archive"
  elif [[ "$normalized" == "$HOME/.claude/skills"* ]]; then
    echo "global"
  else
    echo "project"
  fi
}

scope_to_status() {
  case "$1" in
    global|project) echo "active" ;;
    lab) echo "experimental" ;;
    disabled) echo "disabled" ;;
    archive) echo "archived" ;;
    *) echo "active" ;;
  esac
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

infer_risk() {
  local skill_name="$1"
  if [[ "$skill_name" =~ ^(code|db|ops)- ]]; then
    echo "high"
  elif [[ "$skill_name" =~ ^learn- ]]; then
    echo "low"
  else
    echo "medium"
  fi
}

shorten_purpose() {
  local description="$1"
  local purpose="${description%% Use when*}"
  purpose="${purpose%% Do not use*}"
  purpose="${purpose%% Keywords:*}"
  purpose="$(echo "$purpose" | sed 's/[[:space:]]*$//')"
  if [[ -z "$purpose" ]]; then
    purpose="$description"
  fi
  echo "$purpose"
}

scope="$(infer_scope "$ROOT")"
status="$(scope_to_status "$scope")"

mkdir -p "$(dirname "$INDEX_PATH")"

{
  echo "| Skill | Domain | Scope | Status | Risk | Auto trigger | Purpose |"
  echo "|---|---|---|---|---|---|---|"

  for skill_dir in "$ROOT"/*; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    skill_md="$skill_dir/SKILL.md"
    [[ -f "$skill_md" ]] || continue

    fm_name="$(extract_frontmatter_value "$skill_md" "name")"
    if [[ -n "$fm_name" ]]; then
      skill_name="$fm_name"
    fi

    domain="${skill_name%%-*}"
    risk="$(infer_risk "$skill_name")"
    auto_trigger="Yes"
    if frontmatter_has_true "$skill_md" "disable-model-invocation"; then
      auto_trigger="No"
    fi

    description="$(extract_frontmatter_value "$skill_md" "description")"
    purpose="$(shorten_purpose "$description")"
    purpose="${purpose//|//}"

    echo "| $skill_name | $domain | $scope | $status | $risk | $auto_trigger | $purpose |"
  done
} > "$INDEX_PATH"

echo "Generated SKILLS_INDEX.md successfully."
echo "Root: $ROOT"
echo "Index: $INDEX_PATH"
