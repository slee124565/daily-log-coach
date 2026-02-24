#!/bin/bash

# Auto-Journal Skill Release Script
# 用法: ./release.sh
# 此腳本會依據 skill 目錄中的 SKILL.md metadata.version 屬性封裝 .skill 檔案

SKILL_NAME="daily-log-coach"
SOURCE_DIR="./skill"

# 檢查來源目錄是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ 錯誤：找不到來源目錄 $SOURCE_DIR"
    exit 1
fi

echo "🚀 準備封裝 $SKILL_NAME..."

# 尋找 global npm 目錄下的 skill-creator 工具
NPM_GLOBAL=$(npm root -g)
PACKAGE_SCRIPT="$NPM_GLOBAL/@google/gemini-cli/node_modules/@google/gemini-cli-core/dist/src/skills/builtin/skill-creator/scripts/package_skill.cjs"

if [ -f "$PACKAGE_SCRIPT" ]; then
    echo "✅ 找到官方 skill-creator 封裝腳本，開始進行驗證與封裝..."
    # 執行官方封裝指令，輸出至目前目錄
    node "$PACKAGE_SCRIPT" "$SOURCE_DIR" ./
    
    # skill-creator 會依照 SKILL.md 中的 name 屬性產生 .skill 檔案
    # 針對 auto-journal，產生的檔案名稱預期為 auto-journal.skill
    EXPECTED_OUTPUT="./${SKILL_NAME}.skill"
    
    if [ -f "$EXPECTED_OUTPUT" ]; then
        echo "✅ 成功封裝為：$EXPECTED_OUTPUT"
    else
        echo "⚠️ 封裝腳本執行完畢，請確認目前目錄下的 .skill 檔案："
        ls -l *.skill
    fi
else
    echo "⚠️ 找不到官方 skill-creator 腳本，可能是 Gemini CLI 未進行全域安裝。"
    echo "使用標準 zip 工具進行備用封裝..."
    
    EXPECTED_OUTPUT="./${SKILL_NAME}.skill"
    TEMP_DIR=$(mktemp -d)
    
    # 複製檔案以確保 .skill 檔案的根目錄是 SKILL.md
    cp -r "$SOURCE_DIR/"* "$TEMP_DIR/"
    cd "$TEMP_DIR" || exit 1
    zip -r "../$EXPECTED_OUTPUT" ./* > /dev/null
    cd - > /dev/null || exit 1
    rm -rf "$TEMP_DIR"
    
    echo "✅ 成功建立：$EXPECTED_OUTPUT"
fi

echo "--------------------------------------------------------"
echo "如果要安裝此版本，請執行："
echo "👉 gemini skills install $EXPECTED_OUTPUT --scope user"
echo "--------------------------------------------------------"
