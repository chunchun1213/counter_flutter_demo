# Figma 整合快速參考

## 一鍵設定

```bash
# 1. 複製環境變數範本
cp .env.example .env

# 2. 編輯 .env 填入您的資訊
# 使用您慣用的編輯器開啟 .env
nano .env  # 或 vim .env 或 code .env

# 3. 測試連線
dart tools/test_figma_connection.dart
```

## 取得 Figma Token

1. 前往 [Figma Settings](https://www.figma.com/settings)
2. 捲動到 **Personal access tokens**
3. 點擊 **Generate new token**
4. 設定名稱和權限（建議選擇 Read-only）
5. 複製 token（只顯示一次！）
6. 貼到 `.env` 檔案的 `FIGMA_ACCESS_TOKEN`

## 取得 File Key

從 Figma 檔案 URL 複製：

```
https://www.figma.com/file/abc123xyz/Design-Name
                           ^^^^^^^^^^
                           這就是 File Key
```

## 常見指令

```bash
# 測試 Figma 連線
dart tools/test_figma_connection.dart

# 檢查環境變數
echo $FIGMA_ACCESS_TOKEN
echo $FIGMA_FILE_KEY

# 重新載入環境變數（如果使用 shell 設定）
source ~/.zshrc
```

## 疑難排解

### ❌ Token 無效

```bash
# 重新產生新的 token
# 1. 到 Figma Settings 撤銷舊 token
# 2. 產生新 token
# 3. 更新 .env 檔案
```

### ❌ 找不到檔案

```bash
# 確認 File Key 正確
# 確認您有檔案的存取權限
```

### ❌ 權限被拒

```bash
# Token 需要有 "File content" 讀取權限
# 在 Figma 重新產生 token 時確保勾選此權限
```

## 完整文件

詳細設定說明請參考：[docs/figma-setup.md](./figma-setup.md)

---

**快速連結**:
- 📖 [完整設定指南](./figma-setup.md)
- 🔐 [Figma API 文件](https://www.figma.com/developers/api)
- 🏠 [專案 README](../README.md)
