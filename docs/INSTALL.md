# Daily Log Coach Skill 安裝手冊

適用對象：第一次安裝 `daily-log-coach` 的同仁
完成時間：約 10 分鐘

---

## 安裝流程總覽

```
步驟 1：取得 repo 或 release zip
步驟 2：選擇 target（Claude / Codex / Gemini）
步驟 3：安裝到 local 或 user scope
步驟 4：重新載入對應 Agent
步驟 5：確認 Skill 已載入
```

---

## 步驟 1：取得 repo 或 release zip

你可以用兩種方式取得 Skill：

- 直接 clone repo 後執行 `install.sh`
- 下載 Releases 的 zip 後解壓縮到對應技能目錄

GitHub URL：

```text
https://github.com/slee124565/daily-log-coach.git
```

---

## 步驟 2：選擇 target

`daily-log-coach` 支援三個 target，預設為 Claude：

- `claude`
- `codex`
- `gemini`

如果你沒有特別指定，`./install.sh` 會預設安裝到 `claude`。

---

## 步驟 3：安裝到 local 或 user scope

### local scope

安裝到目前工作目錄的 Agent workspace：

```bash
cd daily-log-coach
./install.sh
```

若要指定 target：

```bash
./install.sh codex
./install.sh gemini
```

### user scope

安裝到個人使用者目錄：

```bash
./install.sh user
./install.sh codex user
./install.sh gemini user
```

---

## 步驟 4：重新載入對應 Agent

- Claude：執行 `/clear` 或重啟 Claude Code
- Codex：重啟 Codex session
- Gemini：執行 `/skills reload`

---

## 步驟 5：確認 Skill 已載入

完成後，用一句簡單測試語句確認：

```text
我今天完成了第一次安裝測試
```

如果 Agent 正常回應記錄與回饋，就代表安裝成功。
