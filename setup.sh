#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SOURCE="$REPO_DIR/skills"
SKILLS_TARGET="$HOME/.claude/skills"

echo "Setting up claude-skills..."

# Ensure ~/.claude exists
mkdir -p "$HOME/.claude"

# Handle existing skills directory
if [ -L "$SKILLS_TARGET" ]; then
  echo "  ~/.claude/skills symlink already exists — skipping."
elif [ -d "$SKILLS_TARGET" ]; then
  echo "  ~/.claude/skills exists as a real directory. Backing up to ~/.claude/skills.bak ..."
  mv "$SKILLS_TARGET" "$HOME/.claude/skills.bak"
  ln -s "$SKILLS_SOURCE" "$SKILLS_TARGET"
  echo "  Symlinked ~/.claude/skills → $SKILLS_SOURCE"
else
  ln -s "$SKILLS_SOURCE" "$SKILLS_TARGET"
  echo "  Symlinked ~/.claude/skills → $SKILLS_SOURCE"
fi

echo "Done. All skills in $SKILLS_SOURCE are now live in Claude Code."
