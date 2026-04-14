#!/bin/bash

# Daily Log Coach Skill Installation Script
# Usage: ./install.sh [target] [scope]
# Example: ./install.sh claude local (Defaults: claude local)

# Set variables
TARGET=${1:-claude}  # Default to claude
SCOPE=${2:-local}    # Default to local workspace
SKILL_NAME="daily-log-coach"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skill/$TARGET"

# Determine target base directory by model
if [ "$TARGET" == "gemini" ]; then
    TARGET_BASE=".gemini"
elif [ "$TARGET" == "claude" ]; then
    TARGET_BASE=".claude"
elif [ "$TARGET" == "codex" ]; then
    TARGET_BASE=".codex"
else
    echo "❌ Error: Unsupported target environment '$TARGET'"
    echo "Usage: ./install.sh [gemini|claude|codex] [local|user] (default target: claude, default scope: local)"
    exit 1
fi

if [ "$SCOPE" == "local" ]; then
    WORKSPACE_ROOT="${LOCAL_AGENT_WORKSPACE:-$PWD}"
    DEST_DIR="$WORKSPACE_ROOT/$TARGET_BASE/skills/$SKILL_NAME"
elif [ "$SCOPE" == "user" ]; then
    DEST_DIR="$HOME/$TARGET_BASE/skills/$SKILL_NAME"
else
    echo "❌ Error: Unsupported scope '$SCOPE'"
    echo "Usage: ./install.sh [gemini|claude|codex] [local|user] (default target: claude, default scope: local)"
    exit 1
fi

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Error: Source directory $SOURCE_DIR not found"
    echo "Please make sure model-specific skill files exist (skill/gemini or skill/claude or skill/codex)."
    exit 1
fi

echo "🚀 Preparing to install Daily Log Coach Skill to $TARGET environment..."
echo "🧭 Install scope: $SCOPE"
echo "📂 Target path: $DEST_DIR"
echo "📦 Source path: $SOURCE_DIR"

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
    elif [ "$TARGET" == "claude" ]; then
        echo "👉 /clear (or restart Claude Code)"
    else
        echo "👉 restart Codex session to reload skills"
    fi
    echo "--------------------------------------------------------"
else
    echo "❌ Installation failed. Please check permissions or directory status."
    exit 1
fi
