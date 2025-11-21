# Figma Personal Access Token 設定指南

## 概述

本指南將協助您建立和設定 Figma Personal Access Token (PAT)，以便在開發流程中整合 Figma 設計資源。

## 目錄

- [為什麼需要 Personal Access Token](#為什麼需要-personal-access-token)
- [建立 Personal Access Token](#建立-personal-access-token)
- [設定環境變數](#設定環境變數)
- [驗證設定](#驗證設定)
- [安全性最佳實踐](#安全性最佳實踐)
- [常見問題](#常見問題)

---

## 為什麼需要 Personal Access Token

Figma Personal Access Token 允許您的應用程式透過 Figma API 存取設計檔案，實現：

- 📥 自動匯出設計資產（圖示、影像）
- 🎨 讀取設計規範（顏色、字型、間距）
- 🔄 同步設計變更到程式碼
- 📊 整合設計與開發工作流程

---

## 建立 Personal Access Token

### 步驟 1: 登入 Figma

1. 前往 [Figma 官網](https://www.figma.com/)
2. 使用您的帳號登入

### 步驟 2: 進入帳號設定

1. 點擊右上角的個人頭像
2. 選擇 **Settings**（設定）

### 步驟 3: 建立新的 Token

1. 在左側選單中，點擊 **Account**（帳號）標籤
2. 向下捲動找到 **Personal access tokens** 區塊
3. 點擊 **Generate new token**（產生新令牌）按鈕

### 步驟 4: 設定 Token 資訊

1. **Token 名稱**: 輸入有意義的名稱（例如：`Counter Flutter Demo - Development`）
2. **Token 描述**（選填）: 說明此 token 的用途
3. **Expiration**（到期日）: 建議選擇合理的到期時間
   - 開發環境：30-90 天
   - 持續整合：可選擇較長期限，但定期更新
4. **Scopes**（權限範圍）: 選擇必要的權限
   - ✅ **File content** - 讀取檔案內容（必要）
   - ✅ **Read-only** - 唯讀存取（建議，較安全）

### 步驟 5: 產生並複製 Token

1. 點擊 **Generate token**（產生令牌）按鈕
2. **重要**: Token 只會顯示一次，請立即複製並安全保存
3. Token 格式範例：`figd_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`

⚠️ **警告**: 此 Token 等同於您的密碼，請勿分享或提交到版本控制系統！

---

## 設定環境變數

### 方法 1: 使用 .env 檔案（推薦）

1. 在專案根目錄建立 `.env` 檔案：

```bash
# 在專案根目錄執行
touch .env
```

2. 編輯 `.env` 檔案，加入以下內容：

```properties
# Figma API 設定
FIGMA_ACCESS_TOKEN=your_personal_access_token_here
FIGMA_FILE_KEY=your_figma_file_key_here
```

3. 確保 `.env` 已加入 `.gitignore`：

```bash
# 檢查 .gitignore
cat .gitignore | grep .env

# 如果沒有，加入以下行
echo ".env" >> .gitignore
```

### 方法 2: 系統環境變數

#### macOS / Linux

編輯 `~/.zshrc` 或 `~/.bashrc`：

```bash
export FIGMA_ACCESS_TOKEN="your_personal_access_token_here"
export FIGMA_FILE_KEY="your_figma_file_key_here"
```

重新載入設定：

```bash
source ~/.zshrc  # 或 source ~/.bashrc
```

#### Windows

使用 PowerShell：

```powershell
[System.Environment]::SetEnvironmentVariable('FIGMA_ACCESS_TOKEN', 'your_token_here', 'User')
[System.Environment]::SetEnvironmentVariable('FIGMA_FILE_KEY', 'your_file_key_here', 'User')
```

### 取得 Figma File Key

Figma File Key 可從設計檔案 URL 中取得：

```
https://www.figma.com/file/{FILE_KEY}/File-Name
                              ^^^^^^^^
                              這就是 File Key
```

範例：
- URL: `https://www.figma.com/file/abc123xyz789/My-Design`
- File Key: `abc123xyz789`

---

## 驗證設定

### 使用 cURL 測試

```bash
# 測試 API 連線
curl -H "X-Figma-Token: YOUR_TOKEN" \
     "https://api.figma.com/v1/files/YOUR_FILE_KEY"
```

成功回應應包含檔案資訊的 JSON 資料。

### 使用 Flutter/Dart 測試

建立測試腳本 `test_figma_connection.dart`：

```dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  final token = Platform.environment['FIGMA_ACCESS_TOKEN'];
  final fileKey = Platform.environment['FIGMA_FILE_KEY'];

  if (token == null || fileKey == null) {
    print('❌ 環境變數未設定');
    print('請設定 FIGMA_ACCESS_TOKEN 和 FIGMA_FILE_KEY');
    exit(1);
  }

  print('🔍 正在測試 Figma API 連線...');
  print('File Key: $fileKey');

  final url = Uri.parse('https://api.figma.com/v1/files/$fileKey');
  final response = await http.get(
    url,
    headers: {'X-Figma-Token': token},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('✅ 連線成功！');
    print('檔案名稱: ${data['name']}');
    print('最後修改: ${data['lastModified']}');
  } else {
    print('❌ 連線失敗');
    print('狀態碼: ${response.statusCode}');
    print('錯誤訊息: ${response.body}');
  }
}
```

執行測試：

```bash
# 安裝 http 套件（如果尚未安裝）
flutter pub add http

# 執行測試
dart run test_figma_connection.dart
```

---

## 安全性最佳實踐

### ✅ 務必遵守

1. **永不提交 Token 到 Git**
   ```bash
   # 檢查是否不小心提交
   git log -p | grep -i "figma"
   
   # 如果發現，立即撤銷並重新產生 token
   ```

2. **使用 .env 檔案並加入 .gitignore**
   ```gitignore
   # .gitignore
   .env
   .env.local
   .env.*.local
   ```

3. **定期輪換 Token**
   - 建議每 90 天更新一次
   - 如有安全疑慮，立即重新產生

4. **最小權限原則**
   - 只授予必要的權限（通常只需 read-only）
   - 避免授予寫入權限，除非絕對必要

5. **團隊協作**
   - 每位開發者使用自己的 Token
   - 不要共用 Token
   - 在團隊文件中說明如何建立個人 Token

### 🔒 環境隔離

為不同環境使用不同的 Token：

```properties
# .env.development
FIGMA_ACCESS_TOKEN=dev_token_here

# .env.production
FIGMA_ACCESS_TOKEN=prod_token_here
```

### 🚨 Token 洩漏處理

如果 Token 不慎洩漏：

1. **立即撤銷** Token（在 Figma 設定頁面）
2. **產生新的** Token
3. **更新所有** 使用該 Token 的環境
4. **檢查 Git 歷史**，確認是否需要清除歷史記錄
5. **通知團隊** 安全事件

---

## 常見問題

### Q1: Token 顯示「無效」或「已過期」

**A**: 檢查以下項目：
- Token 是否正確複製（包含完整的 `figd_` 前綴）
- Token 是否已過期
- Figma 帳號是否仍有效
- 網路連線是否正常

**解決方案**: 重新產生新的 Token

### Q2: API 回應 403 Forbidden

**A**: 可能原因：
- Token 權限不足
- 檔案未分享給您的帳號
- 檔案已刪除或移動

**解決方案**:
1. 確認您有檔案的存取權限
2. 檢查 Token 的 scopes 設定
3. 確認 File Key 正確

### Q3: 如何在 CI/CD 中使用 Token

**A**: 使用環境變數或 Secret 管理工具：

**GitHub Actions**:
```yaml
env:
  FIGMA_ACCESS_TOKEN: ${{ secrets.FIGMA_ACCESS_TOKEN }}
```

在 GitHub Repository Settings → Secrets 中新增 `FIGMA_ACCESS_TOKEN`。

**GitLab CI**:
```yaml
variables:
  FIGMA_ACCESS_TOKEN: $FIGMA_ACCESS_TOKEN
```

在 GitLab Project Settings → CI/CD → Variables 中新增。

### Q4: Token 可以設定為永不過期嗎？

**A**: 不建議。基於安全考量：
- 選擇合理的過期時間（30-90 天）
- 設定行事曆提醒定期更新
- 建立標準作業程序（SOP）簡化更新流程

### Q5: 多個專案可以共用同一個 Token 嗎？

**A**: 技術上可以，但不建議：
- 每個專案使用獨立的 Token
- 便於管理和撤銷
- 提高安全性（Token 洩漏影響範圍較小）

---

## 相關資源

### 官方文件
- [Figma API 文件](https://www.figma.com/developers/api)
- [Personal Access Tokens 說明](https://help.figma.com/hc/en-us/articles/8085703771159-Manage-personal-access-tokens)

### 實用工具
- [Figma API Explorer](https://www.figma.com/developers/api#api-explorer) - 互動式 API 測試工具
- [Figma Plugins](https://www.figma.com/community/plugins) - 社群開發的擴充功能

### Flutter 整合套件
- [figma_api](https://pub.dev/packages/figma_api) - Dart Figma API 客戶端
- [figma_to_flutter](https://pub.dev/packages/figma_to_flutter) - 設計轉程式碼工具

---

## 支援

如有問題或需要協助：

1. 查閱本專案的 [README.md](../README.md)
2. 參考專案憲章 [.specify/memory/constitution.md](../.specify/memory/constitution.md)
3. 聯絡團隊技術負責人

---

**最後更新**: 2025-11-21  
**文件版本**: 1.0.0  
**維護者**: 專案團隊

---

> 📝 **注意**: 本文件遵循專案憲章原則 V - 文件語言規範，使用繁體中文撰寫。
