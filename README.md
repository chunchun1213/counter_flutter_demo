# counter_flutter_demo

Flutter 計數器展示專案，遵循嚴格的程式碼品質、測試標準、使用者體驗一致性和效能需求。

## 專案憲章

本專案遵循 [專案憲章](./.specify/memory/constitution.md) 中定義的核心原則。所有貢獻者和開發實踐必須遵循憲章要求。

### 核心原則

1. **程式碼品質** (NON-NEGOTIABLE): 靜態分析零警告、格式化一致性、程式碼審查必要性
2. **測試標準** (NON-NEGOTIABLE): 測試優先開發、三層測試金字塔（單元≥80%覆蓋率、元件、整合）
3. **使用者體驗一致性**: 設計系統遵循、平台慣例、無障礙支援
4. **效能需求**: 啟動<3秒、60 FPS、記憶體<150MB

## 快速開始

### 環境設定

1. **安裝 Flutter SDK**
   ```bash
   # 檢查 Flutter 版本
   flutter --version
   ```

2. **複製專案**
   ```bash
   git clone https://github.com/chunchun1213/counter_flutter_demo.git
   cd counter_flutter_demo
   ```

3. **安裝相依套件**
   ```bash
   flutter pub get
   ```

4. **Figma 整合設定**（選用）
   
   如需存取 Figma 設計檔案，請參考 [Figma 設定指南](./docs/figma-setup.md) 完成以下步驟：
   
   ```bash
   # 1. 複製環境變數範本
   cp .env.example .env
   
   # 2. 編輯 .env 並填入您的 Figma Token
   # FIGMA_ACCESS_TOKEN=your_token_here
   # FIGMA_FILE_KEY=your_file_key_here
   ```
   
   詳細設定說明請見：📄 [docs/figma-setup.md](./docs/figma-setup.md)

5. **執行應用程式**
   ```bash
   # 執行在模擬器或實體裝置
   flutter run
   
   # 或指定特定裝置
   flutter devices
   flutter run -d <device_id>
   ```

### 開發流程

詳見憲章中的「開發流程」章節。簡要步驟：

1. 需求確認 → 2. 測試先行 → 3. 實作 → 4. 程式碼審查 → 5. 整合

所有 PR 必須通過品質閘門（分析、格式、測試、覆蓋率、審查）。

## 文件

- 📖 [專案憲章](./.specify/memory/constitution.md) - 核心開發原則與規範
- 🎨 [Figma 設定指南](./docs/figma-setup.md) - Personal Access Token 設定教學
- 🔧 開發指引 - 即將推出
