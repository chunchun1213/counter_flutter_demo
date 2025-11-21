# 實作計劃：計數器應用程式

**功能分支**: `001-counter-feature` | **日期**: 2025-11-21 | **規格**: [spec.md](./spec.md)  
**輸入**: 功能規格來自 `/specs/001-counter-feature/spec.md`

**注意**: 本計劃依據專案憲章原則 V，使用繁體中文撰寫。

---

## 摘要

**主要需求**: 建構計數器前端功能，使用者可透過點擊按鈕使數字遞增，包含 UI 顯示和自動化測試支援。

**技術方案**: 使用 Flutter 3.16+ 搭配 StatefulWidget 和 setState 進行狀態管理。採用扁平化的 Widget 樹結構，利用 Flutter 內建的狀態管理機制，無需引入第三方狀態管理套件。UI 遵循 Material Design 規範，並完整實作無障礙功能支援。

---

## 技術環境

**語言/版本**: Dart 3.2+, Flutter 3.16+  
**主要相依套件**: 
- `flutter` (SDK 內建)
- `flutter_test` (測試框架，SDK 內建)
- `google_fonts` (Inter 字體支援，版本 ^6.1.0)

**儲存**: N/A（純記憶體狀態，不持久化）  
**測試**: `flutter_test` (單元測試 + Widget 測試)  
**目標平台**: Android, iOS（主要針對手機直向模式）  
**專案類型**: Mobile (單一 Flutter 應用程式)  
**效能目標**: 
- 冷啟動 <3 秒
- 按鈕點擊響應 <16ms（維持 60 FPS）
- 記憶體使用 <150MB

**限制條件**: 
- 暫態設計：狀態不持久化，應用程式從背景恢復時重置
- 僅支援直向模式（portrait）
- 不支援深色模式

**規模/範圍**: 
- 單一畫面應用程式
- 4 個使用者故事（2 P1 + 2 P2）
- 12 個功能需求
- 預估 5-8 個 Dart 檔案（主程式 + Widget + 測試）

---

## 憲章檢查

*門檻: 必須在 Phase 0 研究前通過。Phase 1 設計後重新檢查。*

**必要檢查**（基於 `.specify/memory/constitution.md`）:

- ✅ **程式碼品質**: 
  - 已規劃使用 `flutter analyze` 進行靜態分析（零警告要求）
  - 已規劃使用 `dart format` 進行程式碼格式化
  - 程式碼審查流程：所有變更需至少一位團隊成員審查
  - 遵循單一職責原則：每個 Widget 和類別職責明確

- ✅ **測試標準**: 
  - 採用測試先行開發（Test-First）
  - 三層測試金字塔結構：
    - **單元測試**: 涵蓋計數器狀態管理邏輯（目標覆蓋率 ≥80%）
    - **Widget 測試**: 驗證所有 UI 元件行為和互動（4 個使用者故事 + 3 個邊界情況）
    - **整合測試**: N/A（單一畫面應用，Widget 測試已足夠）
  - 測試可重複執行且獨立（不依賴外部狀態）

- ✅ **使用者體驗一致性**: 
  - 遵循 Material Design 設計規範
  - 設計系統：使用 Figma 設計規格定義的色彩、排版、間距系統
  - 無障礙支援：所有 UI 元件提供 Semantics 標籤和 Key
  - 即時回饋：按鈕點擊提供視覺回饋（Material 波紋效果）
  - 響應式設計：支援不同螢幕尺寸（最小 320x568，目標 393x852）

- ✅ **效能需求**: 
  - 冷啟動 <3 秒（憲章要求）
  - 按鈕點擊響應 <16ms，維持 60 FPS（憲章要求）
  - 記憶體使用 <150MB（憲章要求）
  - 使用 `const` 建構函式減少重建
  - 避免在 build 方法中進行昂貴計算

- ✅ **文件語言**: 
  - 本 plan.md 使用繁體中文撰寫（符合憲章原則 V）
  - spec.md 已使用繁體中文撰寫
  - 所有即將產生的文件（research.md, data-model.md, tasks.md）將使用繁體中文

**無違反需要說明** → 所有憲章原則均符合

---

## 專案結構

### 文件結構（本功能）

```text
specs/001-counter-feature/
├── spec.md              # 功能規格（已完成）
├── plan.md              # 本檔案（實作計劃）
├── research.md          # Phase 0 研究輸出（待產生）
├── data-model.md        # Phase 1 資料模型（待產生）
├── quickstart.md        # Phase 1 快速開始指南（待產生）
├── contracts/           # Phase 1 API 合約（N/A - 無後端）
├── checklists/
│   └── requirements.md  # 規格品質檢查清單（已完成）
└── tasks.md             # Phase 2 任務清單（待產生）
```

### 原始碼結構（repository root）

```text
counter_flutter_demo/
├── lib/
│   ├── main.dart                    # 應用程式入口點，MaterialApp 設定
│   ├── models/
│   │   └── counter_model.dart       # Counter 資料模型和業務邏輯
│   ├── widgets/
│   │   ├── counter_display.dart     # 計數器顯示元件
│   │   ├── plus_button.dart         # 加號按鈕元件
│   │   └── title_text.dart          # 標題文字元件
│   ├── screens/
│   │   └── counter_screen.dart      # 計數器主畫面
│   ├── constants/
│   │   ├── app_colors.dart          # 色彩常數（來自 Figma）
│   │   ├── app_text_styles.dart     # 文字樣式常數（來自 Figma）
│   │   └── app_spacing.dart         # 間距常數（來自 Figma）
│   └── utils/
│       └── lifecycle_observer.dart  # 應用程式生命週期觀察者（背景恢復處理）
├── test/
│   ├── unit/
│   │   └── counter_model_test.dart  # Counter 模型單元測試
│   └── widget/
│       ├── counter_display_test.dart    # CounterDisplay Widget 測試
│       ├── plus_button_test.dart        # PlusButton Widget 測試
│       ├── counter_screen_test.dart     # CounterScreen 整合測試
│       └── lifecycle_test.dart          # 生命週期行為測試
├── pubspec.yaml                     # 套件相依性設定
├── analysis_options.yaml            # Dart 分析器設定
└── README.md                        # 專案說明（繁體中文）
```

**結構決策**: 採用**單一 Flutter 專案結構**（Mobile App）。理由如下：

1. **功能簡單**: 單一畫面計數器不需要複雜的模組化架構
2. **無後端**: 純前端應用，不需要 API 或資料庫層
3. **狀態管理簡單**: 使用 setState 足以應付單一計數器狀態
4. **可測試性**: 清晰的 Widget 分層便於編寫單元測試和 Widget 測試
5. **符合 Flutter 最佳實踐**: 
   - `lib/` 存放應用程式程式碼
   - `test/` 存放測試，結構映射 `lib/` 目錄
   - `models/` 存放資料模型和業務邏輯
   - `widgets/` 存放可重用 UI 元件
   - `screens/` 存放完整畫面 Widget
   - `constants/` 存放設計系統常數

---

## Phase 0: 研究與決策（待執行）

### 需要研究的主題

1. **Flutter 生命週期管理**
   - 研究 `WidgetsBindingObserver` 的使用方式
   - 如何監聽 `AppLifecycleState.paused` 和 `AppLifecycleState.resumed`
   - 在狀態恢復時重置計數器的最佳實踐

2. **大數值處理**
   - Dart int 最大值（2^63 - 1）的處理策略
   - 如何在達到最大值時禁用按鈕
   - UI 如何顯示禁用狀態（灰色、透明度、禁用波紋效果）

3. **無障礙功能實作**
   - Semantics Widget 的使用方式
   - 如何為 Text 和 Button 提供適當的語意標籤
   - 螢幕閱讀器測試方法（TalkBack/VoiceOver）

4. **Widget 測試最佳實踐**
   - 如何在測試中模擬應用程式生命週期變化
   - `WidgetTester` 的 `pumpWidget`, `tap`, `pump` 使用時機
   - 如何驗證按鈕的禁用狀態（`onPressed` 為 null）

5. **Inter 字體整合**
   - 使用 `google_fonts` 套件 vs 本地字體檔案
   - 字體載入對啟動時間的影響
   - 如何在測試環境中處理字體

**輸出**: `research.md` 文件，記錄每個主題的研究結果、決策和替代方案。

---

## Phase 1: 資料模型與合約（待執行）

### 資料模型設計

**Counter Model**:
```dart
class Counter {
  int _value;
  
  Counter({int initialValue = 0}) : _value = initialValue;
  
  int get value => _value;
  bool get isAtMaxValue => _value == 9223372036854775807; // 2^63 - 1
  
  void increment() {
    if (!isAtMaxValue) {
      _value++;
    }
  }
  
  void reset() {
    _value = 0;
  }
}
```

**設計決策**:
- 使用私有 `_value` 封裝狀態
- 提供 `isAtMaxValue` getter 供 UI 判斷按鈕是否應禁用
- `increment()` 方法內建邊界檢查
- `reset()` 方法供生命週期恢復時呼叫

### API 合約

**N/A** - 本應用程式無後端 API，純前端狀態管理。

### 快速開始指南

將產生 `quickstart.md`，包含：
- Flutter 環境設定（SDK 3.16+ 安裝）
- 專案設定步驟（`flutter pub get`）
- 執行應用程式（`flutter run`）
- 執行測試（`flutter test`）
- 程式碼格式化和分析（`dart format .`, `flutter analyze`）

**輸出**: 
- `data-model.md`: Counter 模型的詳細設計文件
- `quickstart.md`: 開發環境設定指南
- `contracts/`: 不適用（無後端）

---

## Phase 2: 任務分解（將由 /speckit.task 執行）

Phase 2 將由 `/speckit.task` 指令執行，根據本計劃產生 `tasks.md`。

**預期任務類別**:

1. **環境設定** (1 任務)
   - 設定 Flutter 專案，安裝相依套件，設定 analysis_options.yaml

2. **設計系統實作** (3 任務)
   - 實作 `app_colors.dart`（色彩常數）
   - 實作 `app_text_styles.dart`（文字樣式）
   - 實作 `app_spacing.dart`（間距常數）

3. **資料模型與邏輯** (2 任務)
   - 實作 `counter_model.dart`（包含單元測試）
   - 實作 `lifecycle_observer.dart`（應用程式生命週期觀察者）

4. **UI 元件** (4 任務)
   - 實作 `title_text.dart`（包含 Widget 測試）
   - 實作 `counter_display.dart`（包含 Widget 測試）
   - 實作 `plus_button.dart`（包含 Widget 測試）
   - 實作 `counter_screen.dart`（主畫面，整合所有元件）

5. **整合測試** (3 任務)
   - Widget 整合測試（使用者故事 1-4）
   - 生命週期測試（背景恢復行為）
   - 無障礙測試（Semantics 驗證）

6. **品質保證** (2 任務)
   - 執行完整測試套件，確保覆蓋率 ≥80%
   - 程式碼審查準備（格式化、分析、文件）

**預估總任務數**: 15 個任務  
**預估完成時間**: 2-3 個工作日（1 位開發者）

---

## 複雜度追蹤

> **僅在憲章檢查有需要說明的違反時填寫**

無違反需要說明。本計劃完全符合專案憲章的所有原則。

---

## 憲章符合性總結

| 憲章原則 | 符合狀態 | 備註 |
|---------|---------|------|
| I. 程式碼品質 | ✅ 完全符合 | 使用 flutter analyze + dart format，程式碼審查流程 |
| II. 測試標準 | ✅ 完全符合 | 測試先行，三層測試金字塔，覆蓋率 ≥80% |
| III. 使用者體驗一致性 | ✅ 完全符合 | Material Design + Figma 設計系統 + 無障礙支援 |
| IV. 效能需求 | ✅ 完全符合 | <3s 啟動，60 FPS，<150MB 記憶體 |
| V. 文件語言 | ✅ 完全符合 | 所有文件使用繁體中文 |

---

## Phase 2：憲章重新檢查

**檢查日期**: 2025-11-21  
**檢查範圍**: research.md, data-model.md, quickstart.md

### 憲章原則驗證結果

| 原則 | 符合狀態 | 關鍵證據 |
|------|---------|---------|
| I. 程式碼品質 | ✅ 通過 | Counter 符合 SRP，可測試性設計，10 個單元測試 |
| II. 測試標準 | ✅ 通過 | 測試優先策略，三層金字塔，≥80% 覆蓋率，<30s 執行 |
| III. 使用者體驗 | ✅ 通過 | Semantics 無障礙支援，setState 即時回饋 |
| IV. 效能需求 | ✅ 通過 | O(1) 操作，<1KB 記憶體，google_fonts 快取 |
| V. 文件語言 | ✅ 通過 | 所有文件（research, data-model, quickstart）繁體中文 |

**Phase 1 新增設計決策**:
1. 生命週期重置：`WidgetsBindingObserver` 在 `resumed` 時重置
2. 大數值處理：Counter 內建邊界檢查 + UI 禁用按鈕
3. 無障礙：`semanticsLabel` 屬性
4. 字體：google_fonts 自動快取
5. Counter 模型：私有 `_value`，公開 getter

**憲章合規性**: ✅ 所有設計符合憲章，無例外或違反

---

## 下一步行動

1. ✅ **Phase 0**: research.md 已完成
2. ✅ **Phase 1**: data-model.md, quickstart.md 已完成
3. ✅ **憲章檢查**: 已驗證通過
4. ⏳ **Phase 3**: 執行 `/speckit.task` 產生 tasks.md（15 個預估任務）
5. ⏳ **實作**: 依據 tasks.md 開始開發

---

**計劃版本**: 1.0.0  
**建立日期**: 2025-11-21  
**更新日期**: 2025-11-21 (Phase 0, 1, 憲章檢查完成)  
**狀態**: ✅ Phase 0-2 完成 | ⏳ Phase 3 待執行
