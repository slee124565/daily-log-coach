# Daily Log Coach Skill

`daily-log-coach` 是一個可同時支援 **Gemini CLI**、**Claude Code** 與 **Codex** 的「純 Prompt Skill」。它不僅是你的工作日誌記錄器，更是一位專業成長教練。

透過攔截你日常的隨機想法、進度更新與目標設定，它能幫你結構化地歸檔記錄，並在你累積足夠的行為軌跡後，主動提供「教練式回饋」，幫助你發現盲點並推進目標。

> **適用對象**：使用 Gemini CLI、Claude Code 或 Codex 的同仁。
> **目前狀態**：Gemini 版本為主要發佈版本；Claude / Codex 版本已加入 repo 結構支援，可按各平台規格持續優化。

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

### 選項 A：一鍵安裝 (Gemini)
這是最快的 Gemini 安裝方式。只需在終端機執行以下指令，即可下載 GitHub 上最新發布的 `.skill` 檔案並交由 Gemini CLI 安裝。
（*安裝前請確認已安裝 `curl` 與 `gemini` 指令*）

```bash
curl -sL https://github.com/slee124565/daily-log-coach/releases/latest/download/daily-log-coach.skill -o /tmp/daily-log-coach.skill && gemini skills install /tmp/daily-log-coach.skill --scope user
```
> **提示**：我們目前提供自動打包功能，您也可以在 [Releases](https://github.com/slee124565/daily-log-coach/releases) 頁面下載特定版本的 `.skill` 檔，並使用 `gemini skills install <檔案路徑> --scope user` 安裝。

### 選項 B：開發者安裝 (Gemini / Claude / Codex)
如果你想要自訂教練邏輯或分類系統，可以將專案 Clone 下來，並使用內建的腳本安裝。

```bash
git clone https://github.com/slee124565/daily-log-coach.git
cd daily-log-coach

# 安裝到「目前工作目錄」的本地 agent workspace（預設 local scope）
./install.sh gemini
./install.sh claude
./install.sh codex

# 若要安裝到使用者目錄（user scope）
./install.sh gemini user
./install.sh claude user
./install.sh codex user
```

**安裝後操作：**
*   **Gemini CLI**：執行 `/skills reload` 重新載入。
*   **Claude Code**：執行 `/clear` 或重啟 Claude Code 重新載入。
*   **Codex**：重啟 Codex session 重新載入。

> `install.sh` 參數格式：`./install.sh [gemini|claude|codex] [local|user]`（預設為 `local`）。

### 模型版本結構

```text
skill/
  gemini/
    SKILL.md
    references/
  claude/
    SKILL.md
    references/
  codex/
    SKILL.md
```

可使用 `./release.sh gemini`、`./release.sh claude` 或 `./release.sh codex` 產生對應發佈檔。

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
