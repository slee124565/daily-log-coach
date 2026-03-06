#!/bin/bash

# Daily Log Coach Skill Release Script
# 用法: ./release.sh [gemini|claude|codex]
# 此腳本會依據 skill/<model>/SKILL.md metadata.version 屬性封裝發佈檔

TARGET=${1:-gemini}
SKILL_NAME="daily-log-coach"
SOURCE_DIR="./skill/$TARGET"

if [ "$TARGET" != "gemini" ] && [ "$TARGET" != "claude" ] && [ "$TARGET" != "codex" ]; then
    echo "❌ 錯誤：不支援的 target '$TARGET'"
    echo "用法：./release.sh [gemini|claude|codex]"
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

if [ "$TARGET" == "gemini" ]; then
    # 預期產生的檔名 (包含版本號)
    VERSIONED_OUTPUT="./${SKILL_NAME}-gemini-v${VERSION}.skill"

    # 尋找 global npm 目錄下的 skill-creator 工具
    NPM_GLOBAL=$(npm root -g)
    PACKAGE_SCRIPT="$NPM_GLOBAL/@google/gemini-cli/node_modules/@google/gemini-cli-core/dist/src/skills/builtin/skill-creator/scripts/package_skill.cjs"

    if [ -f "$PACKAGE_SCRIPT" ]; then
        echo "✅ 找到官方 skill-creator 封裝腳本，開始進行驗證與封裝..."
        # 執行官方封裝指令，輸出至目前目錄
        node "$PACKAGE_SCRIPT" "$SOURCE_DIR" ./

        # skill-creator 可能會依照 SKILL.md 中的 name 屬性產生檔名 (例如 daily-log-coach.skill)
        # 或是依來源資料夾名稱 (例如 gemini.skill)，或預設產生 skill.skill
        DEFAULT_OUTPUT="./${SKILL_NAME}.skill"
        TARGET_OUTPUT="./${TARGET}.skill"
        FALLBACK_OUTPUT="./skill.skill"

        if [ -f "$DEFAULT_OUTPUT" ]; then
            mv "$DEFAULT_OUTPUT" "$VERSIONED_OUTPUT"
            echo "✅ 成功封裝並更名為：$VERSIONED_OUTPUT"
        elif [ -f "$TARGET_OUTPUT" ]; then
            mv "$TARGET_OUTPUT" "$VERSIONED_OUTPUT"
            echo "✅ 成功封裝並將 ${TARGET}.skill 更名為：$VERSIONED_OUTPUT"
        elif [ -f "$FALLBACK_OUTPUT" ]; then
            mv "$FALLBACK_OUTPUT" "$VERSIONED_OUTPUT"
            echo "✅ 成功封裝並將預設檔名更名為：$VERSIONED_OUTPUT"
        else
            echo "⚠️ 封裝腳本執行完畢，但找不到輸出檔案"
            ls -l *.skill
        fi
    else
        echo "⚠️ 找不到官方 skill-creator 腳本，可能是 Gemini CLI 未進行全域安裝。"
        echo "使用標準 zip 工具進行備用封裝..."

        TEMP_DIR=$(mktemp -d)

        # 複製檔案以確保 .skill 檔案的根目錄是 SKILL.md
        cp -r "$SOURCE_DIR/"* "$TEMP_DIR/"
        cd "$TEMP_DIR" || exit 1
        zip -r "../$VERSIONED_OUTPUT" ./* > /dev/null
        cd - > /dev/null || exit 1
        rm -rf "$TEMP_DIR"

        echo "✅ 成功建立：$VERSIONED_OUTPUT"
    fi
elif [ "$TARGET" == "claude" ]; then
    VERSIONED_OUTPUT="./${SKILL_NAME}-claude-v${VERSION}.zip"
    echo "📦 Claude 版本使用 zip 封裝：$VERSIONED_OUTPUT"
    (
        cd "$SOURCE_DIR" || exit 1
        zip -r "../../$(basename "$VERSIONED_OUTPUT")" ./* > /dev/null
    )
    echo "✅ 成功建立：$VERSIONED_OUTPUT"
else
    VERSIONED_OUTPUT="./${SKILL_NAME}-codex-v${VERSION}.zip"
    echo "📦 Codex 版本使用 zip 封裝：$VERSIONED_OUTPUT"
    (
        cd "$SOURCE_DIR" || exit 1
        zip -r "../../$(basename "$VERSIONED_OUTPUT")" ./* > /dev/null
    )
    echo "✅ 成功建立：$VERSIONED_OUTPUT"
fi

echo "--------------------------------------------------------"
echo "如果要安裝此版本 ($TARGET / $VERSION)，請執行："
if [ "$TARGET" == "gemini" ]; then
    echo "👉 (local 預設) ./install.sh gemini local"
    echo "👉 (user) gemini skills install $VERSIONED_OUTPUT --scope user"
elif [ "$TARGET" == "claude" ]; then
    echo "👉 (local 預設) ./install.sh claude local"
    echo "👉 (user) unzip $VERSIONED_OUTPUT -d ~/.claude/skills/$SKILL_NAME"
    echo "👉 /clear（或重啟 Claude Code）"
else
    echo "👉 (local 預設) ./install.sh codex local"
    echo "👉 (user) unzip $VERSIONED_OUTPUT -d ~/.codex/skills/$SKILL_NAME"
    echo "👉 重啟 Codex session 重新載入"
fi
echo "--------------------------------------------------------"
