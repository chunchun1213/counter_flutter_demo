<!--
SYNC IMPACT REPORT
==================
Version Change: [INITIAL] → 1.0.0
Change Type: MINOR (Initial constitution establishment)
Modified Principles: N/A (Initial version)
Added Sections:
  - Core Principles (4 principles established)
  - Performance Standards
  - Development Workflow
  - Governance
Removed Sections: N/A
Templates Status:
  ✅ plan-template.md - Updated: Constitution Check section with concrete requirements
  ✅ spec-template.md - Updated: Added Non-Functional Requirements section based on constitution
  ✅ tasks-template.md - Updated: Changed tests from OPTIONAL to MANDATORY per constitution
  ✅ checklist-template.md - Updated: Added constitution-based quality gates checklist
  ⚠ agent-file-template.md - No update required: Template is auto-generated at runtime
Follow-up TODOs:
  - None currently identified
  - Monitor performance budgets in practice and adjust thresholds if needed
  - Consider adding CI/CD configuration examples in future iterations
Runtime Documents:
  ✅ README.md - Updated: Added constitution reference and core principles summary
Commit Message: docs: establish constitution v1.0.0 (code quality, testing, UX, performance principles)
-->

# Counter Flutter Demo Constitution

## Core Principles

### I. 程式碼品質 (NON-NEGOTIABLE)

所有程式碼必須符合以下品質標準：

- **可讀性優先**: 程式碼必須清晰表達意圖，使用有意義的命名和適當的註解
- **靜態分析零警告**: 所有程式碼必須通過 `flutter analyze` 且無警告或錯誤
- **格式化一致性**: 使用 `dart format` 自動格式化，不允許手動調整格式
- **依賴性注入**: 避免硬編碼依賴，使用建構函式注入或服務定位器模式
- **單一職責原則**: 每個類別、函式應只有一個明確的職責
- **程式碼審查必要性**: 所有變更必須經過至少一位團隊成員審查

**理由**: 高品質程式碼降低維護成本、減少 bug 產生率，並提升團隊協作效率。品質標準的一致性確保專案長期可維護性。

### II. 測試標準 (NON-NEGOTIABLE)

測試是品質保證的核心，必須遵循以下規範：

- **測試優先開發**: 對於新功能，先寫測試（描述預期行為）→ 測試失敗 → 實作 → 測試通過
- **三層測試金字塔**:
  - **單元測試**: 覆蓋所有業務邏輯、工具函式、資料模型（目標覆蓋率 ≥80%）
  - **元件測試**: 驗證 Widget 行為和狀態管理互動
  - **整合測試**: 關鍵使用者旅程的端到端測試（至少覆蓋 P1 使用者故事）
- **測試必須可重複執行**: 測試不應依賴外部狀態或執行順序
- **快速回饋**: 單元測試套件必須在 30 秒內完成執行
- **Mock 外部依賴**: 網路、資料庫、系統 API 必須使用 mock 進行測試

**理由**: 測試優先確保需求理解正確，自動化測試提供信心進行重構和新增功能，防止迴歸錯誤。

### III. 使用者體驗一致性

提供流暢、直覺且一致的使用者體驗：

- **設計系統遵循**: 使用統一的顏色、字型、間距、圓角等設計令牌
- **平台慣例**: 遵循 Material Design (Android) 和 Human Interface Guidelines (iOS) 的平台規範
- **回應式設計**: 介面必須適應不同螢幕尺寸（手機、平板、桌面）
- **無障礙支援**: 提供語意化標籤（Semantics），支援螢幕閱讀器和鍵盤導覽
- **即時回饋**: 使用者操作必須提供即時視覺回饋（載入指示器、按鈕狀態變化等）
- **錯誤處理友善**: 錯誤訊息必須清晰、可操作，避免技術術語

**理由**: 一致的 UX 降低學習曲線，提升使用者滿意度和保留率。遵循平台慣例確保應用程式感覺「原生」。

### IV. 效能需求

應用程式必須維持高效能標準：

- **啟動時間**: 冷啟動時間 <3 秒，熱啟動 <1 秒
- **流暢度**: 維持 60 FPS（16.67ms/frame），動畫和滾動必須流暢無卡頓
- **記憶體使用**: 單頁面記憶體使用 <150MB，避免記憶體洩漏
- **網路最佳化**: 使用快取策略，減少不必要的網路請求，支援離線功能（如適用）
- **Bundle 大小**: APK/IPA 大小應儘可能小，使用程式碼分割和資源最佳化
- **效能分析工具**: 使用 DevTools 定期分析效能瓶頸

**理由**: 效能直接影響使用者體驗和應用程式評價。低階設備也應提供可接受的效能。

## Performance Standards

### 效能監控

- 每個 Sprint 結束前必須執行效能分析
- 使用 Flutter DevTools 的 Timeline 和 Memory 工具進行分析
- 記錄關鍵頁面的渲染時間和記憶體使用

### 效能預算

- **Build 時間**: 完整建構 <5 分鐘
- **Hot Reload**: <2 秒
- **清單滾動**: 即使有 1000+ 項目，仍須維持 60 FPS（使用 ListView.builder 或類似最佳化）
- **影像載入**: 使用快取和適當的影像格式/尺寸，避免大影像阻塞 UI

### 效能優化策略

- 使用 `const` 建構函式減少重建
- 實作適當的 `shouldRepaint`/`shouldRebuild` 邏輯
- 避免在 build 方法中執行昂貴的計算
- 使用 `Isolate` 處理 CPU 密集型任務

## Development Workflow

### 開發流程

1. **需求確認**: 從 `spec.md` 確認使用者故事和驗收標準
2. **計畫審查**: 檢查 `plan.md` 確保符合憲章原則
3. **測試先行**: 為新功能撰寫失敗的測試
4. **實作**: 實作功能使測試通過
5. **程式碼審查**: 提交 PR，通過審查和所有檢查
6. **整合**: 合併到主分支，觸發 CI/CD

### 品質閘門

所有 Pull Request 必須通過：

- ✅ `dart analyze` 無錯誤或警告
- ✅ `dart format --set-exit-if-changed .` 格式化檢查通過
- ✅ 所有測試通過（單元、元件、整合）
- ✅ 測試覆蓋率符合標準（≥80% 對於新增程式碼）
- ✅ 至少一位審查者批准
- ✅ 效能指標未迴歸（關鍵頁面）

### 分支策略

- **main**: 穩定的生產程式碼，受保護分支
- **feature/###-feature-name**: 功能開發分支，從 main 建立
- **hotfix/###-description**: 緊急修復分支

### 持續整合

- 自動執行程式碼分析、格式檢查和測試
- 自動建構預覽版本供測試
- 失敗的建構阻止合併

## Governance

本憲章是專案的最高指導原則，所有開發實踐必須遵循：

- **憲章優先級**: 當實踐與憲章衝突時，憲章優先
- **修訂程序**: 憲章修訂需要團隊共識和文件化的理由，包含變更的影響分析
- **版本控制**: 使用語意化版本（MAJOR.MINOR.PATCH）
  - MAJOR: 移除或重新定義核心原則（向後不相容）
  - MINOR: 新增原則或重大擴充
  - PATCH: 澄清、措辭改善、小修正
- **合規審查**: 程式碼審查時必須驗證是否符合憲章原則
- **例外處理**: 任何偏離憲章的行為必須在 `plan.md` 的「複雜度追蹤」表格中說明理由
- **執行時指引**: 團隊成員應參考 `.specify/templates/agent-file-template.md` 以了解開發指引的最新資訊

**Version**: 1.0.0 | **Ratified**: 2025-11-21 | **Last Amended**: 2025-11-21
