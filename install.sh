#!/bin/bash

# Auto-Journal Skill Installation Script
# Usage: ./install.sh [target]
# Example: ./install.sh gemini (Defaults to gemini)

# Set variables
TARGET=${1:-gemini}  # Default to gemini
SKILL_NAME="daily-log-coach"
SOURCE_DIR="./skill"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Error: Source directory $SOURCE_DIR not found"
    exit 1
fi

# Determine target installation path (User Scope)
if [ "$TARGET" == "gemini" ]; then
    DEST_DIR="$HOME/.gemini/skills/$SKILL_NAME"
elif [ "$TARGET" == "claude" ]; then
    DEST_DIR="$HOME/.claude/skills/$SKILL_NAME"
else
    echo "❌ Error: Unsupported target environment '$TARGET'"
    echo "Usage: ./install.sh [gemini|claude]"
    exit 1
fi

echo "🚀 Preparing to install Auto-Journal Skill to $TARGET environment..."
echo "📂 Target path: $DEST_DIR"

# Create target directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Sync files (including overwrite updates and deleting old files)
# Use rsync to ensure complete synchronization and exclude unnecessary hidden files
if command -v rsync >/dev/null 2>&1; then
    rsync -av --delete --exclude='.*' "$SOURCE_DIR/" "$DEST_DIR/"
else
    echo "⚠️ rsync not found, using cp for copying (old files may not be automatically deleted)"
    cp -r "$SOURCE_DIR/"* "$DEST_DIR/"
fi

# Check installation result
if [ $? -eq 0 ]; then
    echo "✅ Installation successful!"
    echo "--------------------------------------------------------"
    echo "Please execute the reload command in your $TARGET terminal to enable the Skill:"
    if [ "$TARGET" == "gemini" ]; then
        echo "👉 /skills reload"
    else
        echo "👉 /clear (or restart Claude Code)"
    fi
    echo "--------------------------------------------------------"
else
    echo "❌ Installation failed. Please check permissions or directory status."
    exit 1
fi
