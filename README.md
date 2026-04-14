# Daily Log Coach Skill

`daily-log-coach` 是一個可同時支援 **Gemini CLI**、**Claude Code** 與 **Codex** 的「純 Prompt Skill」。它不僅是你的工作日誌記錄器，更是一位專業成長教練。

透過攔截你日常的隨機想法、進度更新與目標設定，它能幫你結構化地歸檔記錄，並在你累積足夠的行為軌跡後，主動提供「教練式回饋」，幫助你發現盲點並推進目標。

> **適用對象**：使用 Gemini CLI、Claude Code 或 Codex 的同仁。
> **目前狀態**：三個 target 皆提供對應版本，預設 target 為 Claude，發佈檔統一為 zip 格式。

## 🌟 核心功能

### 1. 五大自動分類系統
當你輸入內容時，Agent 會自動判斷語意並歸類：
- **🎯 目標 (Goal)**：設定新的工作目標、方向、計畫。
- **🚀 進度 (Progress)**：正在進行中的工作更新。
- **✅ 完成 (Achievement)**：達成目標、結束任務、交付成果。
- **💡 靈感 (Thought)**：想法、洞見、直覺、創意、發現。
- **📌 待辦 (Todo)**：外部觸發的行動項目（文章、對話、觀察）。

### 2. 即時洞見回饋
每一筆記錄不僅僅是存檔。Agent 會根據你紀錄的內容，提煉一個專業洞見或追問（1-2 句），促使你進一步思考。

### 3. 教練式彙整 (累積觸發)
當你的某個核心關鍵詞在歷史日誌中累積出現 **3 筆以上** 時，Agent 會自動調閱過往紀錄，並提供一段「教練式觀察」，幫助你看出自己在這個主題上的發展軌跡與情緒變化。

### 4. 專案級別儲存 (Git Friendly)
日誌預設儲存在你**當前工作目錄**的 `./daily-logs/YYYY/MM/YYYY-MM-DD.md` 中。
這非常適合將日誌目錄獨立作為一個 Private GitHub Repository 來管理，讓你在公司與家裡的主機之間輕鬆同步你的專業成長軌跡。

---

## 🚀 安裝指南

如果你還沒熟悉安裝流程，請先參考：
- [Daily Log Coach 安裝手冊](./docs/INSTALL.md)

### 選項 A：對話式安裝（提供 GitHub URL 給 Agent）
如果你不熟悉 terminal 指令，可以直接把 GitHub URL 丟給 Agent，請它代為安裝到目前 workspace（local scope）。

GitHub URL：

```text
https://github.com/slee124565/daily-log-coach.git
```

可直接貼給 Agent 的對話範本：

```text
# 給 Claude Code
請幫我用這個 repo 安裝 Daily Log Coach 到目前 workspace：
https://github.com/slee124565/daily-log-coach.git
請執行：
1) git clone（若資料夾已存在可跳過）
2) cd daily-log-coach
3) ./install.sh local
4) 回報安裝結果與實際安裝路徑
```

```text
# 給 Codex
請幫我用這個 repo 安裝 Daily Log Coach 到目前 workspace：
https://github.com/slee124565/daily-log-coach.git
請執行：
1) git clone（若資料夾已存在可跳過）
2) cd daily-log-coach
3) ./install.sh codex local
4) 回報安裝結果與實際安裝路徑
```

```text
# 給 Gemini CLI Agent
請幫我用這個 repo 安裝 Daily Log Coach 到目前 workspace：
https://github.com/slee124565/daily-log-coach.git
請執行：
1) git clone（若資料夾已存在可跳過）
2) cd daily-log-coach
3) ./install.sh gemini local
4) 回報安裝結果與實際安裝路徑
```

安裝完成後請重新載入 Agent：
*   **Claude Code**：執行 `/clear` 或重啟 Claude Code。
*   **Codex**：重啟 Codex session。
*   **Gemini CLI**：執行 `/skills reload`。

### 選項 B：從 Releases 安裝（zip）
到 [Releases](https://github.com/slee124565/daily-log-coach/releases) 下載對應檔案：
- Claude：`daily-log-coach-claude-vX.Y.Z.zip`
- Codex：`daily-log-coach-codex-vX.Y.Z.zip`
- Gemini：`daily-log-coach-gemini-vX.Y.Z.zip`

下載後解壓縮到對應目錄（user scope）：

```bash
# Claude
unzip daily-log-coach-claude-vX.Y.Z.zip -d ~/.claude/skills/daily-log-coach

# Codex
unzip daily-log-coach-codex-vX.Y.Z.zip -d ~/.codex/skills/daily-log-coach

# Gemini
unzip daily-log-coach-gemini-vX.Y.Z.zip -d ~/.gemini/skills/daily-log-coach
```

### 選項 C：開發者安裝 (Gemini / Claude / Codex)
如果你想要自訂教練邏輯或分類系統，可以將專案 Clone 下來，並使用內建的腳本安裝。

```bash
git clone https://github.com/slee124565/daily-log-coach.git
cd daily-log-coach

# 安裝到「目前工作目錄」的本地 agent workspace（預設 target = claude）
./install.sh
./install.sh codex
./install.sh gemini

# 若要安裝到使用者目錄（user scope）
./install.sh user
./install.sh codex user
./install.sh gemini user
```

**安裝後操作：**
*   **Claude Code**：執行 `/clear` 或重啟 Claude Code 重新載入。
*   **Codex**：重啟 Codex session 重新載入。
*   **Gemini CLI**：執行 `/skills reload` 重新載入。

> `install.sh` 參數格式：`./install.sh [gemini|claude|codex] [local|user]`（預設 target 為 `claude`，scope 預設為 `local`）。

### 模型版本結構

```text
skill/
  claude/
    SKILL.md
  codex/
    SKILL.md
  gemini/
    SKILL.md
    references/
```

可使用 `./release.sh`（預設 Claude）、`./release.sh gemini` 或 `./release.sh codex` 產生對應發佈檔。

---

## 📘 新手教學（Tutorial）

如果你是第一次使用，建議先閱讀完整實作教學：

- [TUTORIAL.md](./TUTORIAL.md)

教學內容包含：
- 第一次觸發與日誌寫入驗證
- 五種分類（目標 / 進度 / 完成 / 靈感 / 待辦）完整體驗
- 進階情境（錯別字修正、多筆輸入拆分、分類模糊互動）
- 教練彙整觸發條件與觀察重點

完成教學後，你可以更快把這個 Skill 納入日常工作流。

---

## 💬 使用範例

只要在終端機中自然地對 Agent 說話即可：

*   「我決定要導入 TypeScript 來重構專案」 (觸發：**目標**)
*   「目前 API 文件寫到一半」 (觸發：**進度**)
*   「完成了登入功能的開發」 (觸發：**完成**)
*   「我在想是不是可以把這個工具開源讓大家用」 (觸發：**靈感**)
*   「看到一篇講 Agent 架構的文章，值得深入研究」 (觸發：**待辦**)

Agent 會自動修正錯字、分類、打上標籤，並寫入你當前目錄的 `daily-logs/` 中。

---

## 👨‍💻 授權與貢獻
歡迎提交 Issue 或 Pull Request 來優化教練的引導邏輯與分類系統！
