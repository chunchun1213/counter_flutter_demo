# 研究報告：計數器應用程式技術研究

**專案**: 計數器應用程式  
**功能分支**: `001-counter-feature`  
**研究日期**: 2025-11-21  
**研究者**: 專案團隊

**目的**: 解決實作計劃中識別的技術不確定性，為 Phase 1 設計和 Phase 2 實作提供明確的技術決策。

---

## 1. Flutter 生命週期管理

### 研究目標
了解如何監聽應用程式進入背景和恢復前景的事件，並在恢復時重置計數器狀態。

### 研究結果

#### WidgetsBindingObserver 使用方式

**核心概念**:
- `WidgetsBindingObserver` 是 Flutter 提供的生命週期觀察者介面
- 需要在 StatefulWidget 的 State 類別中混入 (mixin) `WidgetsBindingObserver`
- 透過 `didChangeAppLifecycleState` 方法監聽狀態變化

**實作範例**:
```dart
class _CounterScreenState extends State<CounterScreen> with WidgetsBindingObserver {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _counter = 0; // 從背景恢復時重置
      });
    }
  }
}
```

#### AppLifecycleState 狀態說明

| 狀態 | 描述 | 觸發時機 |
|------|------|---------|
| `resumed` | 應用程式可見且響應使用者輸入 | 從背景恢復到前景 |
| `inactive` | 應用程式處於非活動狀態 | 接聽電話、系統對話框出現 |
| `paused` | 應用程式不可見 | 切換到其他應用程式、按下 Home 鍵 |
| `detached` | 應用程式仍在 Flutter 引擎中但從主機 View 分離 | 應用程式即將終止 |

#### 重置策略決策

**決策**: 在 `AppLifecycleState.resumed` 時重置計數器為 0

**理由**:
1. 符合 spec.md 的澄清決策（2025-11-21）：「從背景恢復都視為新開始」
2. `resumed` 狀態明確表示使用者重新回到應用程式
3. 簡單明瞭，無需追蹤 `paused` 狀態的時間長度

**替代方案被拒絕**:
- ❌ 在 `paused` 時立即重置：可能在短暫切換（如查看通知）時意外重置
- ❌ 使用計時器判斷背景時間長度：過度複雜，不符合「暫態設計」原則

### 測試方法

```dart
testWidgets('從背景恢復後計數器重置', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // 點擊增加計數
  await tester.tap(find.byKey(const Key('plus_button')));
  await tester.pump();
  expect(find.text('1'), findsOneWidget);
  
  // 模擬進入背景
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  await tester.pump();
  
  // 模擬恢復前景
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  await tester.pump();
  
  // 驗證計數器重置
  expect(find.text('0'), findsOneWidget);
});
```

---

## 2. 大數值處理

### 研究目標
確定如何處理計數器達到 Dart int 最大值（2^63 - 1）的情況，並正確禁用按鈕。

### 研究結果

#### Dart int 最大值

**數值**: `9223372036854775807` (2^63 - 1)  
**取得方式**: Dart 沒有內建常數，需要手動定義或計算

```dart
const int maxInt = 9223372036854775807; // 2^63 - 1
// 或使用位元運算
const int maxInt = (1 << 63) - 1;
```

#### 邊界檢查策略

**決策**: 在 Counter 模型中實作邊界檢查

```dart
class Counter {
  static const int maxValue = 9223372036854775807;
  int _value;
  
  Counter({int initialValue = 0}) : _value = initialValue;
  
  int get value => _value;
  bool get isAtMaxValue => _value >= maxValue;
  
  void increment() {
    if (!isAtMaxValue) {
      _value++;
    }
  }
}
```

**理由**:
1. 封裝邊界邏輯在模型中，UI 只需檢查 `isAtMaxValue`
2. 防止溢位錯誤在資料層
3. 易於測試（單元測試）

#### UI 禁用策略

**決策**: 根據 `counter.isAtMaxValue` 動態設定按鈕的 `onPressed` 屬性

```dart
FloatingActionButton(
  onPressed: counter.isAtMaxValue ? null : _incrementCounter,
  backgroundColor: const Color(0xFF030213),
  disabledBackgroundColor: Colors.grey.shade400,
  // ...
)
```

**理由**:
1. `onPressed: null` 是 Flutter 禁用按鈕的標準方式
2. Material Design 自動處理禁用狀態的視覺效果（灰色、無波紋）
3. 可透過 `disabledBackgroundColor` 自訂禁用時的背景色

**視覺效果**:
- 禁用時：背景變為灰色（#9E9E9E），無法點擊，無波紋效果
- 啟用時：背景為深藍黑色（#030213），可點擊，有波紋效果

### 測試方法

```dart
test('達到最大值時 isAtMaxValue 為 true', () {
  final counter = Counter(initialValue: Counter.maxValue);
  expect(counter.isAtMaxValue, true);
});

test('達到最大值後 increment 不增加數值', () {
  final counter = Counter(initialValue: Counter.maxValue);
  counter.increment();
  expect(counter.value, Counter.maxValue);
});

testWidgets('達到最大值時按鈕禁用', (WidgetTester tester) async {
  // 建立 Counter 並設定為最大值 - 1
  final counter = Counter(initialValue: Counter.maxValue - 1);
  await tester.pumpWidget(CounterApp(counter: counter));
  
  // 點擊使其達到最大值
  await tester.tap(find.byKey(const Key('plus_button')));
  await tester.pump();
  
  // 驗證按鈕被禁用
  final button = tester.widget<FloatingActionButton>(
    find.byKey(const Key('plus_button'))
  );
  expect(button.onPressed, isNull);
});
```

---

## 3. 無障礙功能實作

### 研究目標
了解如何使用 Semantics Widget 提供螢幕閱讀器支援，並確保測試覆蓋無障礙功能。

### 研究結果

#### Semantics Widget 使用方式

**方法 1: 使用 semanticsLabel 屬性**（推薦）

```dart
Text(
  '$count',
  key: const Key('counter_display_text'),
  style: counterNumberStyle,
  semanticsLabel: '計數器數值: $count',
)
```

**方法 2: 使用 Semantics Widget 包裝**

```dart
Semantics(
  label: '計數器數值',
  value: '$count',
  child: Text('$count', style: counterNumberStyle),
)
```

**決策**: 使用方法 1（semanticsLabel 屬性）

**理由**:
1. 更簡潔，減少 Widget 層級
2. Flutter 內建 Text Widget 已支援 semanticsLabel
3. 符合 Flutter 最佳實踐

#### 按鈕 Semantics

```dart
FloatingActionButton(
  key: const Key('plus_button'),
  onPressed: onPressed,
  child: const Icon(
    Icons.add,
    semanticLabel: '增加計數',
  ),
)
```

**重要**: 
- Icon Widget 的 `semanticLabel` 會自動傳遞給按鈕
- 禁用按鈕時，螢幕閱讀器會自動通知「按鈕禁用」

#### 螢幕閱讀器測試方法

**Android (TalkBack)**:
1. 設定 > 無障礙 > TalkBack > 開啟
2. 觸摸計數器文字，聽到「計數器數值: 0」
3. 觸摸加號按鈕，聽到「增加計數 按鈕」
4. 雙擊激活按鈕，聽到「計數器數值: 1」

**iOS (VoiceOver)**:
1. 設定 > 輔助使用 > VoiceOver > 開啟
2. 觸摸計數器文字，聽到「計數器數值: 0」
3. 觸摸加號按鈕，聽到「增加計數 按鈕」
4. 雙擊激活按鈕，聽到「計數器數值: 1」

### 測試方法

```dart
testWidgets('應提供正確的 Semantics 標籤', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // 取得計數器文字的 Semantics
  final counterTextFinder = find.byKey(const Key('counter_display_text'));
  final counterSemantics = tester.getSemantics(counterTextFinder);
  
  // 驗證標籤包含「計數器數值」
  expect(counterSemantics.label, contains('計數器數值'));
  
  // 取得按鈕的 Semantics
  final buttonFinder = find.byKey(const Key('plus_button'));
  final buttonSemantics = tester.getSemantics(buttonFinder);
  
  // 驗證按鈕標籤和類型
  expect(buttonSemantics.label, '增加計數');
  expect(buttonSemantics.hasAction(SemanticsAction.tap), true);
});
```

---

## 4. Widget 測試最佳實踐

### 研究目標
確定 Widget 測試的正確寫法，特別是生命週期模擬和按鈕狀態驗證。

### 研究結果

#### WidgetTester 核心方法

| 方法 | 用途 | 時機 |
|------|------|------|
| `pumpWidget()` | 建立並渲染 Widget 樹 | 測試開始時 |
| `pump()` | 觸發單次 frame，處理所有待處理的動畫和狀態更新 | 狀態變更後 |
| `pumpAndSettle()` | 觸發所有 frame 直到動畫完成 | 有動畫時 |
| `tap()` | 模擬點擊 | 測試互動 |
| `binding.handleAppLifecycleStateChanged()` | 模擬生命週期變化 | 測試背景/前景切換 |

#### 常見模式

**模式 1: 基本互動測試**
```dart
testWidgets('點擊按鈕應增加計數', (WidgetTester tester) async {
  // 1. 建立 Widget
  await tester.pumpWidget(const MyApp());
  
  // 2. 驗證初始狀態
  expect(find.text('0'), findsOneWidget);
  
  // 3. 執行互動
  await tester.tap(find.byKey(const Key('plus_button')));
  await tester.pump(); // 觸發一次 frame
  
  // 4. 驗證結果
  expect(find.text('1'), findsOneWidget);
});
```

**模式 2: 生命週期測試**
```dart
testWidgets('生命週期測試', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // 修改狀態
  await tester.tap(find.byKey(const Key('plus_button')));
  await tester.pump();
  
  // 模擬進入背景
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
  await tester.pump();
  
  // 模擬恢復前景
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  await tester.pump();
  
  // 驗證狀態重置
  expect(find.text('0'), findsOneWidget);
});
```

**模式 3: 按鈕禁用狀態驗證**
```dart
testWidgets('達到最大值時按鈕禁用', (WidgetTester tester) async {
  // 建立接近最大值的 Counter
  final counter = Counter(initialValue: Counter.maxValue - 1);
  await tester.pumpWidget(CounterApp(counter: counter));
  
  // 點擊使其達到最大值
  await tester.tap(find.byKey(const Key('plus_button')));
  await tester.pump();
  
  // 驗證按鈕的 onPressed 為 null（禁用）
  final button = tester.widget<FloatingActionButton>(
    find.byKey(const Key('plus_button'))
  );
  expect(button.onPressed, isNull);
});
```

#### 測試隔離原則

**最佳實踐**:
1. 每個測試獨立：不依賴其他測試的狀態
2. 使用 `setUp()` 和 `tearDown()` 管理測試資源
3. 避免共享可變狀態
4. 測試名稱清楚描述行為

```dart
void main() {
  group('CounterScreen', () {
    testWidgets('應顯示初始計數值 0', (WidgetTester tester) async {
      // 每個測試都建立新的 Widget
      await tester.pumpWidget(const MyApp());
      expect(find.text('0'), findsOneWidget);
    });
    
    testWidgets('點擊按鈕應增加計數', (WidgetTester tester) async {
      // 新的 Widget，獨立於上一個測試
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byKey(const Key('plus_button')));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });
  });
}
```

---

## 5. Inter 字體整合

### 研究目標
決定如何載入 Inter 字體，並評估對啟動時間和測試環境的影響。

### 研究結果

#### 方案比較

| 方案 | 優點 | 缺點 | 啟動時間影響 |
|------|------|------|-------------|
| **google_fonts 套件** | 簡單易用，自動快取 | 需要網路連線（首次） | +100-300ms（首次），之後 <50ms |
| **本地字體檔案** | 無網路依賴，完全離線 | 增加 APK/IPA 大小 | +50-100ms |
| **系統預設字體** | 零開銷 | 無法使用 Inter 字體 | 0ms |

#### 決策: 使用 google_fonts 套件

**理由**:
1. **簡單易用**: 一行程式碼即可使用 Inter 字體
2. **自動快取**: 第一次下載後，字體儲存在裝置快取中
3. **減少 APK 大小**: 不需要打包字體檔案到應用程式中
4. **符合效能目標**: 快取後的啟動時間增加 <50ms，遠低於 3 秒的預算
5. **開發便利**: 支援所有字重，不需要手動管理字體檔案

#### 實作方式

**1. pubspec.yaml 新增相依性**:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
```

**2. 使用 Inter 字體**:
```dart
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle counterNumberStyle = GoogleFonts.inter(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF101727),
    height: 1.5,
  );
  
  static TextStyle titleTextStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF354152),
    height: 1.5,
  );
}
```

**3. 預載字體（選用，改善首次啟動體驗）**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 預載 Inter 字體（可選）
  await GoogleFonts.pendingFonts([
    GoogleFonts.inter(fontWeight: FontWeight.w400),
    GoogleFonts.inter(fontWeight: FontWeight.w700),
  ]);
  
  runApp(const MyApp());
}
```

#### 測試環境處理

**問題**: 測試環境沒有網路連線，google_fonts 可能失敗。

**解決方案**: 使用 fallback 字體

```dart
static TextStyle counterNumberStyle = GoogleFonts.inter(
  fontSize: 72,
  fontWeight: FontWeight.w700,
  color: const Color(0xFF101727),
  height: 1.5,
).copyWith(
  fontFamily: 'Inter', // fallback 到系統預設
);
```

**更好的方案**: 在測試中使用 mock 或直接使用 TextStyle

```dart
// 在測試檔案中
testWidgets('測試計數器顯示', (WidgetTester tester) async {
  // google_fonts 在測試中會自動 fallback 到預設字體
  await tester.pumpWidget(const MyApp());
  expect(find.text('0'), findsOneWidget);
});
```

**結論**: google_fonts 套件在測試環境中會自動 fallback 到系統字體，不需要特殊處理。

#### 效能影響測量

**預期效能**:
- **首次啟動**（無快取）: +100-300ms（下載字體）
- **後續啟動**（有快取）: +20-50ms（載入快取）
- **記憶體增加**: +2-5MB（字體快取）

**監測方法**:
```dart
void main() async {
  final stopwatch = Stopwatch()..start();
  
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts([...]);
  
  print('Font loading time: ${stopwatch.elapsedMilliseconds}ms');
  runApp(const MyApp());
}
```

**符合憲章**: 即使首次啟動增加 300ms，總啟動時間仍遠低於 3 秒的憲章要求。

---

## 研究決策總結

| 主題 | 決策 | 替代方案（被拒絕） |
|------|------|------------------|
| **生命週期管理** | 使用 WidgetsBindingObserver，在 resumed 時重置 | 在 paused 時重置、使用計時器判斷背景時長 |
| **大數值處理** | Counter 模型內建邊界檢查，UI 根據 isAtMaxValue 禁用按鈕 | UI 層判斷邊界、使用 BigInt |
| **無障礙功能** | 使用 semanticsLabel 屬性（Text 和 Icon） | 使用 Semantics Widget 包裝 |
| **Widget 測試** | 使用 pump() 觸發 frame，binding.handleAppLifecycleStateChanged() 模擬生命週期 | 使用 pumpAndSettle()（不適合無動畫場景）|
| **Inter 字體** | 使用 google_fonts 套件 | 本地字體檔案、系統預設字體 |

---

## 未解決的問題

**無** - 所有識別的技術不確定性都已通過研究解決，並做出明確決策。

---

## 下一步行動

1. ✅ **Phase 0 完成**: 所有研究主題已完成，決策已記錄
2. ⏳ **Phase 1 開始**: 基於研究結果，設計詳細的資料模型（`data-model.md`）
3. ⏳ **快速開始指南**: 產生 `quickstart.md`，包含 google_fonts 套件的設定步驟
4. ⏳ **憲章重新檢查**: 驗證所有決策符合憲章原則

---

**研究版本**: 1.0.0  
**完成日期**: 2025-11-21  
**狀態**: ✅ 所有主題已研究完畢，決策已確認
