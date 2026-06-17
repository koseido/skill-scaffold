#!/usr/bin/env bash
set -euo pipefail

# install-skill.sh
#
# Install an AI Skill directory into a global or project Skill location.
#
# Default behavior:
#   - Install skills/skill-scaffold into ~/.claude/skills/
#
# Usage:
#   ./scripts/install-skill.sh
#   ./scripts/install-skill.sh --scope global
#   ./scripts/install-skill.sh --scope project --target /path/to/project
#   ./scripts/install-skill.sh --skill skill-scaffold --scope global
#   ./scripts/install-skill.sh --source skills/skill-scaffold --scope project --target .
#
# Design goals:
#   - Safe by default
#   - File-copy only
#   - No network access
#   - No destructive delete
#   - No dependency beyond POSIX shell utilities

SCOPE="global"
SKILL_NAME="skill-scaffold"
SOURCE_DIR=""
TARGET=""
FORCE="false"

print_usage() {
  cat <<'EOF'
Usage:
  install-skill.sh [options]

Options:
  --scope global|project     Install scope. Default: global
  --skill <name>             Skill name under skills/. Default: skill-scaffold
  --source <path>            Explicit source Skill directory
  --target <path>            Target project directory for project scope, or target skills directory for global scope
  --force                    Overwrite existing target Skill directory after backup
  -h, --help                 Show this help

Examples:
  ./scripts/install-skill.sh
  ./scripts/install-skill.sh --scope global
  ./scripts/install-skill.sh --scope project --target .
  ./scripts/install-skill.sh --skill skill-scaffold --scope global
  ./scripts/install-skill.sh --source skills/skill-scaffold --scope project --target /path/to/project
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)
      SCOPE="${2:-}"
      shift 2
      ;;
    --skill)
      SKILL_NAME="${2:-}"
      shift 2
      ;;
    --source)
      SOURCE_DIR="${2:-}"
      shift 2
      ;;
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --force)
      FORCE="true"
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Error: Unknown option: $1" >&2
      print_usage
      exit 1
      ;;
  esac
done

if [[ "$SCOPE" != "global" && "$SCOPE" != "project" ]]; then
  echo "Error: --scope must be global or project" >&2
  exit 1
fi

if [[ -z "$SKILL_NAME" ]]; then
  echo "Error: --skill cannot be empty" >&2
  exit 1
fi

if [[ ! "$SKILL_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Error: Invalid skill name: $SKILL_NAME" >&2
  echo "Use lowercase kebab-case, for example: skill-scaffold or code-safe-feature" >&2
  exit 1
fi

# Resolve repository root from script location.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -z "$SOURCE_DIR" ]]; then
  SOURCE_DIR="$REPO_ROOT/skills/$SKILL_NAME"
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: Source Skill directory not found: $SOURCE_DIR" >&2
  exit 1
fi

if [[ ! -f "$SOURCE_DIR/SKILL.md" ]]; then
  echo "Error: Source Skill is missing SKILL.md: $SOURCE_DIR/SKILL.md" >&2
  exit 1
fi

if [[ "$SCOPE" == "global" ]]; then
  if [[ -z "$TARGET" ]]; then
    TARGET="$HOME/.claude/skills"
  fi
  TARGET_SKILLS_DIR="$TARGET"
else
  if [[ -z "$TARGET" ]]; then
    TARGET="."
  fi
  TARGET_SKILLS_DIR="$TARGET/.claude/skills"
fi

TARGET_SKILL_DIR="$TARGET_SKILLS_DIR/$SKILL_NAME"

mkdir -p "$TARGET_SKILLS_DIR"

if [[ -e "$TARGET_SKILL_DIR" ]]; then
  if [[ "$FORCE" != "true" ]]; then
    echo "Error: Target Skill already exists: $TARGET_SKILL_DIR" >&2
    echo "Use --force to back it up and overwrite." >&2
    exit 1
  fi

  BACKUP_DIR="${TARGET_SKILL_DIR}.backup.$(date +%Y%m%d%H%M%S)"
  echo "Existing Skill found. Creating backup:"
  echo "  $BACKUP_DIR"
  mv "$TARGET_SKILL_DIR" "$BACKUP_DIR"
fi

cp -R "$SOURCE_DIR" "$TARGET_SKILL_DIR"

echo "Installed Skill successfully."
echo ""
echo "Skill:"
echo "  $SKILL_NAME"
echo ""
echo "Source:"
echo "  $SOURCE_DIR"
echo ""
echo "Target:"
echo "  $TARGET_SKILL_DIR"
echo ""
echo "Usage:"
echo "  /$SKILL_NAME"
echo ""
echo "Next steps:"
echo "  1. Review $TARGET_SKILL_DIR/SKILL.md"
echo "  2. Validate with: ./scripts/validate-skill.sh $TARGET_SKILLS_DIR"
echo "  3. Restart your AI tool if the Skill does not appear"
