# 快速開始指南：計數器應用程式

**專案**: 計數器應用程式  
**功能分支**: `001-counter-feature`  
**目標讀者**: 開發者、QA 測試人員、專案維護者

**目的**: 提供完整的環境設定、建構、執行和測試指南，讓新加入的開發者能快速開始貢獻。

---

## 1. 系統需求

### 1.1 必要條件

| 工具 | 最低版本 | 建議版本 | 驗證指令 |
|------|---------|---------|---------|
| Flutter SDK | 3.16.0 | 3.19+ | `flutter --version` |
| Dart SDK | 3.2.0 | 3.3+ | `dart --version` |
| Android Studio | 2023.1.1+ | 最新穩定版 | - |
| Xcode (macOS) | 15.0+ | 最新穩定版 | `xcodebuild -version` |
| Git | 2.30+ | 最新穩定版 | `git --version` |

### 1.2 支援平台

| 平台 | 支援狀態 | 最低 OS 版本 |
|------|---------|-------------|
| Android | ✅ 完全支援 | Android 5.0 (API 21) |
| iOS | ✅ 完全支援 | iOS 12.0 |
| Web | ❌ 不支援 | - |
| Windows | ❌ 不支援 | - |
| macOS | ❌ 不支援 | - |
| Linux | ❌ 不支援 | - |

---

## 2. 環境設定

### 2.1 安裝 Flutter SDK

#### macOS / Linux
```bash
# 下載 Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# 設定環境變數（新增到 ~/.zshrc 或 ~/.bashrc）
export PATH="$PATH:$HOME/flutter/bin"

# 重新載入環境變數
source ~/.zshrc  # 或 source ~/.bashrc

# 驗證安裝
flutter doctor
```

#### Windows
1. 下載 Flutter SDK: https://flutter.dev/docs/get-started/install/windows
2. 解壓縮到 `C:\src\flutter`
3. 將 `C:\src\flutter\bin` 新增到 PATH 環境變數
4. 執行 `flutter doctor` 驗證安裝

### 2.2 安裝相依工具

#### Android 開發環境
```bash
# 安裝 Android Studio
# 下載: https://developer.android.com/studio

# 開啟 Android Studio > Settings > Appearance & Behavior > System Settings > Android SDK
# 安裝以下元件:
# - Android SDK Platform (API 33)
# - Android SDK Build-Tools
# - Android SDK Platform-Tools
# - Android Emulator

# 接受 Android 許可證
flutter doctor --android-licenses
```

#### iOS 開發環境（僅 macOS）
```bash
# 安裝 Xcode
# 從 App Store 安裝 Xcode

# 安裝 Xcode Command Line Tools
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# 安裝 CocoaPods
sudo gem install cocoapods

# 驗證安裝
flutter doctor
```

### 2.3 驗證環境

```bash
# 執行 Flutter 環境檢查
flutter doctor -v

# 期望輸出（所有項目都有綠色勾選）:
# [✓] Flutter (Channel stable, 3.19.0)
# [✓] Android toolchain
# [✓] Xcode (僅 macOS)
# [✓] Android Studio
# [✓] VS Code (可選)
# [✓] Connected device (至少一個裝置或模擬器)
```

---

## 3. 專案設定

### 3.1 取得程式碼

```bash
# 複製專案儲存庫
git clone <repository-url> counter_flutter_demo
cd counter_flutter_demo

# 切換到功能分支
git checkout 001-counter-feature
```

### 3.2 安裝相依套件

```bash
# 取得 Flutter 套件
flutter pub get

# 期望輸出:
# Running "flutter pub get" in counter_flutter_demo...
# Resolving dependencies...
# + google_fonts 6.1.0
# Changed 1 dependency!
```

### 3.3 驗證專案結構

```bash
# 檢查專案結構
tree -L 2 -I 'build|.dart_tool'

# 期望輸出:
# .
# ├── lib/
# │   ├── main.dart
# │   ├── models/
# │   ├── widgets/
# │   ├── screens/
# │   ├── constants/
# │   └── utils/
# ├── test/
# │   ├── unit/
# │   └── widget/
# ├── pubspec.yaml
# └── README.md
```

---

## 4. 執行應用程式

### 4.1 列出可用裝置

```bash
# 查看連接的裝置和模擬器
flutter devices

# 範例輸出:
# 2 connected devices:
# 
# Android SDK built for arm64 (mobile) • emulator-5554 • android-arm64 • Android 13 (API 33)
# iPhone 15 Pro (mobile)                • 12345678-1234-1234-1234-123456789012 • ios • iOS 17.0
```

### 4.2 啟動 Android 模擬器

```bash
# 列出可用的 Android 模擬器
flutter emulators

# 啟動模擬器（使用輸出中的 ID）
flutter emulators --launch Pixel_7_API_33
```

### 4.3 啟動 iOS 模擬器（僅 macOS）

```bash
# 開啟 iOS Simulator
open -a Simulator

# 或使用 Flutter 指令
flutter emulators --launch apple_ios_simulator
```

### 4.4 執行應用程式

```bash
# 在預設裝置上執行（Debug 模式）
flutter run

# 在特定裝置上執行
flutter run -d emulator-5554

# 執行並啟用熱重載
flutter run --hot

# 期望輸出:
# Launching lib/main.dart on Android SDK built for arm64 in debug mode...
# ✓ Built build/app/outputs/flutter-apk/app-debug.apk.
# Syncing files to device Android SDK built for arm64...
# Flutter run key commands.
# r Hot reload.
# R Hot restart.
# h List all available interactive commands.
# d Detach (terminate "flutter run" but leave application running).
# c Clear the screen
# q Quit (terminate the application on the device).
```

### 4.5 熱重載與熱重啟

| 操作 | 快捷鍵 | 用途 | 保留狀態 |
|------|--------|------|---------|
| 熱重載 | `r` | 重新載入修改的程式碼 | ✅ 是 |
| 熱重啟 | `R` | 完整重啟應用程式 | ❌ 否 |

**使用範例**:
```bash
# 修改 lib/widgets/counter_display.dart
# 在終端機按 'r' 進行熱重載
# 應用程式立即更新，計數值保持不變
```

---

## 5. 執行測試

### 5.1 執行所有測試

```bash
# 執行所有單元測試和 Widget 測試
flutter test

# 期望輸出:
# 00:02 +10: All tests passed!
```

### 5.2 執行特定測試

```bash
# 執行 Counter 單元測試
flutter test test/unit/counter_test.dart

# 執行 Widget 測試
flutter test test/widget/counter_screen_test.dart

# 執行特定測試案例（使用名稱過濾）
flutter test --name "應顯示初始計數值 0"
```

### 5.3 測試覆蓋率

```bash
# 產生測試覆蓋率報告
flutter test --coverage

# 查看覆蓋率報告（HTML 格式）
# macOS / Linux:
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Windows:
# 使用 VS Code 外掛: Coverage Gutters
```

### 5.4 持續測試（監聽模式）

```bash
# 安裝 test_runner（可選）
dart pub global activate test_runner

# 監聽檔案變更並自動執行測試
flutter test --watch
```

---

## 6. 程式碼品質

### 6.1 程式碼格式化

```bash
# 格式化所有 Dart 檔案
dart format .

# 檢查格式但不修改
dart format --output=none --set-exit-if-changed .

# 期望輸出:
# Formatted 10 files (0 changed) in 0.5 seconds.
```

### 6.2 靜態分析

```bash
# 執行 Flutter 分析器
flutter analyze

# 期望輸出:
# Analyzing counter_flutter_demo...
# No issues found!
```

### 6.3 憲章檢查清單

| 原則 | 檢查指令 | 通過標準 |
|------|---------|---------|
| **Code Quality** | `flutter analyze` | 零警告 |
| **Testing Standards** | `flutter test --coverage` | ≥80% 覆蓋率 |
| **UX Consistency** | 手動檢查 Figma 設計 | 視覺一致 |
| **Performance** | `flutter run --profile` | <3s 冷啟動 |
| **Documentation Language** | 檢查 spec.md, plan.md | 全部 zh-TW |

---

## 7. 建構與部署

### 7.1 建構 Android APK

```bash
# 建構 Debug APK
flutter build apk --debug

# 建構 Release APK
flutter build apk --release

# 輸出位置:
# build/app/outputs/flutter-apk/app-release.apk
```

### 7.2 建構 iOS IPA（僅 macOS）

```bash
# 建構 Release IPA
flutter build ios --release

# 使用 Xcode Archive（需要開發者帳號）
open ios/Runner.xcworkspace
# Xcode > Product > Archive
```

### 7.3 安裝 APK 到裝置

```bash
# 使用 adb 安裝
adb install build/app/outputs/flutter-apk/app-release.apk

# 或在執行時直接安裝
flutter install
```

---

## 8. 開發工具

### 8.1 VS Code 設定

**推薦外掛**:
- Flutter (Dart-Code.flutter)
- Dart (Dart-Code.dart-code)
- Flutter Widget Snippets
- Error Lens
- Coverage Gutters

**launch.json 設定**:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter: Run",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart"
    },
    {
      "name": "Flutter: Run (Profile)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "flutterMode": "profile"
    }
  ]
}
```

### 8.2 Android Studio 設定

**推薦外掛**:
- Flutter 外掛（官方）
- Dart 外掛（官方）

**Run Configuration**:
1. Run > Edit Configurations
2. 新增 Flutter 設定
3. Dart entry point: `lib/main.dart`
4. 儲存並執行

---

## 9. 疑難排解

### 9.1 常見問題

| 問題 | 解決方案 |
|------|---------|
| `flutter: command not found` | 檢查 Flutter 是否在 PATH 中：`echo $PATH` |
| `Waiting for another flutter command to release the startup lock` | 刪除 `flutter/bin/cache/lockfile` |
| `CocoaPods not installed` | 執行 `sudo gem install cocoapods` |
| `Gradle build failed` | 清除建構：`flutter clean && flutter pub get` |
| `Xcode build failed` | 更新 CocoaPods：`cd ios && pod repo update && pod install` |
| 熱重載不工作 | 使用熱重啟 `R` 或完整重啟應用程式 |

### 9.2 清理建構快取

```bash
# 清除 Flutter 建構快取
flutter clean

# 清除 pub 快取
flutter pub cache repair

# 重新取得套件
flutter pub get
```

### 9.3 重設 Flutter SDK

```bash
# 重設 Flutter SDK（最後手段）
cd $HOME/flutter
git clean -xfd
git reset --hard
flutter doctor
```

---

## 10. 效能測量

### 10.1 測量啟動時間

```bash
# 執行 Profile 模式
flutter run --profile

# 在應用程式啟動後，查看 DevTools
# 開啟瀏覽器前往: http://127.0.0.1:9100/
# Performance > Timeline > 查看啟動時間

# 憲章目標: < 3 秒冷啟動
```

### 10.2 測量 UI 效能

```bash
# 啟用效能覆蓋層
# 在執行中的應用程式按 'P' 鍵

# 或在程式碼中啟用:
flutter run --profile --enable-impeller
```

### 10.3 記憶體使用

```bash
# 使用 DevTools 監控記憶體
flutter run --profile
# 開啟 DevTools > Memory

# 憲章目標: < 150 MB
```

---

## 11. Git 工作流程

### 11.1 提交程式碼

```bash
# 1. 確保程式碼品質
dart format .
flutter analyze
flutter test

# 2. 檢視變更
git status
git diff

# 3. 暫存變更
git add lib/models/counter.dart
git add test/unit/counter_test.dart

# 4. 提交（使用傳統式提交訊息）
git commit -m "feat: 實作 Counter 模型與邊界檢查"

# 5. 推送到遠端
git push origin 001-counter-feature
```

### 11.2 Pull Request 檢查清單

- [ ] 所有測試通過（`flutter test`）
- [ ] 測試覆蓋率 ≥80%
- [ ] 無靜態分析警告（`flutter analyze`）
- [ ] 程式碼已格式化（`dart format .`）
- [ ] 文件已更新（如適用）
- [ ] 符合憲章所有原則

---

## 12. 相關資源

### 12.1 專案文件

- [功能規格 (spec.md)](./spec.md)
- [實作計劃 (plan.md)](./plan.md)
- [資料模型 (data-model.md)](./data-model.md)
- [研究報告 (research.md)](./research.md)
- [憲章 (constitution.md)](../../.specify/memory/constitution.md)

### 12.2 外部資源

- [Flutter 官方文件](https://flutter.dev/docs)
- [Dart 語言導覽](https://dart.dev/guides/language/language-tour)
- [Material Design 指南](https://m3.material.io/)
- [Flutter Widget 目錄](https://flutter.dev/docs/development/ui/widgets)
- [Flutter Testing 指南](https://flutter.dev/docs/testing)

### 12.3 套件文件

- [google_fonts](https://pub.dev/packages/google_fonts)

---

## 13. 下一步行動

完成環境設定後，建議按照以下順序進行開發：

1. ✅ **閱讀文件**: spec.md, plan.md, data-model.md
2. ⏳ **執行 /speckit.task**: 產生詳細的實作任務清單（tasks.md）
3. ⏳ **實作 Counter 模型**: `lib/models/counter.dart`
4. ⏳ **撰寫單元測試**: `test/unit/counter_test.dart`
5. ⏳ **實作 UI 元件**: CounterDisplay, PlusButton
6. ⏳ **撰寫 Widget 測試**: `test/widget/counter_screen_test.dart`
7. ⏳ **整合與測試**: 完整功能測試
8. ⏳ **效能驗證**: 確保符合憲章目標

---

**快速開始指南版本**: 1.0.0  
**文件狀態**: ✅ 完成  
**最後更新**: 2025-11-21

**如有問題，請聯絡專案維護者或查閱專案 README.md。**
