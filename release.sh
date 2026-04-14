#!/bin/bash

# Daily Log Coach Skill Release Script
# 用法: ./release.sh [gemini|claude|codex]（預設 target: claude）
# 此腳本會依據 skill/<model>/SKILL.md metadata.version 屬性封裝發佈檔（統一輸出 zip）

TARGET=${1:-claude}
SKILL_NAME="daily-log-coach"
SOURCE_DIR="./skill/$TARGET"

if [ "$TARGET" != "gemini" ] && [ "$TARGET" != "claude" ] && [ "$TARGET" != "codex" ]; then
    echo "❌ 錯誤：不支援的 target '$TARGET'"
    echo "用法：./release.sh [gemini|claude|codex]（預設 target: claude）"
    exit 1
fi

# 檢查來源目錄是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ 錯誤：找不到來源目錄 $SOURCE_DIR"
    echo "請確認對應模型資料夾存在（skill/gemini 或 skill/claude 或 skill/codex）"
    exit 1
fi

echo "🚀 準備封裝 $SKILL_NAME ($TARGET)..."

# 從 SKILL.md 提取版本號 (metadata.version)
VERSION=$(grep "version:" "$SOURCE_DIR/SKILL.md" | head -n 1 | awk '{print $2}' | tr -d '\r')
if [ -z "$VERSION" ]; then
    VERSION="unknown"
fi
VERSION=${VERSION#v}

VERSIONED_OUTPUT="./${SKILL_NAME}-${TARGET}-v${VERSION}.zip"
echo "📦 ${TARGET} 版本使用 zip 封裝：$VERSIONED_OUTPUT"
(
    cd "$SOURCE_DIR" || exit 1
    zip -r "../../$(basename "$VERSIONED_OUTPUT")" ./* > /dev/null
)
echo "✅ 成功建立：$VERSIONED_OUTPUT"

echo "--------------------------------------------------------"
echo "如果要安裝此版本 ($TARGET / $VERSION)，請執行："
echo "👉 (local 預設) ./install.sh $TARGET local"
if [ "$TARGET" == "gemini" ]; then
    echo "👉 (user) unzip $VERSIONED_OUTPUT -d ~/.gemini/skills/$SKILL_NAME"
    echo "👉 /skills reload"
elif [ "$TARGET" == "claude" ]; then
    echo "👉 (user) unzip $VERSIONED_OUTPUT -d ~/.claude/skills/$SKILL_NAME"
    echo "👉 /clear（或重啟 Claude Code）"
else
    echo "👉 (user) unzip $VERSIONED_OUTPUT -d ~/.codex/skills/$SKILL_NAME"
    echo "👉 重啟 Codex session 重新載入"
fi
echo "--------------------------------------------------------"
