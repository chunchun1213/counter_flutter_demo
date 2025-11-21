# 功能規格：計數器應用程式

**功能分支**: `001-counter-feature`  
**建立日期**: 2025-11-21  
**狀態**: Draft  
**輸入**: 使用者需求描述：「建構計數器前端功能：點擊按鈕使數字遞增，包含 UI 顯示和自動化測試支援」

**注意**: 本規格書依據專案憲章原則 V，使用繁體中文撰寫。

---

## 使用者場景與測試 *(必填)*

### 使用者故事 1 - 檢視初始計數 (優先級: P1) 🎯 MVP

使用者開啟應用程式後，立即看到計數器顯示初始值 0，了解當前計數狀態。

**為什麼是此優先級**: 這是應用程式的基本顯示功能，是所有後續互動的基礎。沒有初始顯示，使用者無法了解應用程式狀態。

**獨立測試**: 啟動應用程式後，驗證畫面中央顯示數字「0」，文字大小為 72px，顏色為深灰色（#101727）。

**驗收場景**:

1. **Given** 應用程式尚未啟動，**When** 使用者開啟應用程式，**Then** 畫面顯示標題「計數器」和數字「0」
2. **Given** 應用程式已開啟，**When** 使用者查看畫面，**Then** 計數器數字位於畫面中央，清晰可見
3. **Given** 應用程式已開啟，**When** 自動化測試工具查詢，**Then** 可透過 Key 或 Semantics 精確定位計數器文字元件

---

### 使用者故事 2 - 點擊按鈕增加計數 (優先級: P1) 🎯 MVP

使用者點擊加號按鈕，計數器數字立即增加 1，提供即時互動回饋。

**為什麼是此優先級**: 這是應用程式的核心互動功能，實現計數器的主要用途。

**獨立測試**: 點擊加號按鈕一次，驗證數字從 0 變為 1；連續點擊三次，驗證數字變為 3。

**驗收場景**:

1. **Given** 計數器顯示 0，**When** 使用者點擊加號按鈕一次，**Then** 計數器顯示 1
2. **Given** 計數器顯示 0，**When** 使用者連續點擊加號按鈕三次，**Then** 計數器顯示 3
3. **Given** 計數器顯示任意數字 N，**When** 使用者點擊加號按鈕，**Then** 計數器顯示 N+1
4. **Given** 使用者進行測試，**When** 自動化測試工具操作，**Then** 可透過 Key 或 Semantics 精確定位並點擊加號按鈕

---

### 邊界情況

- 計數器數值達到 Flutter int 最大值時會如何處理？（需要考慮是否需要上限或溢位處理）
- 快速連續點擊按鈕時，是否每次點擊都正確註冊？
- 應用程式在背景時，計數狀態是否需要保留？（目前設計為暫態，不保留）

---

## 需求 *(必填)*

### 功能需求

- **FR-001**: 系統 MUST 在應用程式啟動時顯示初始計數值 0
- **FR-002**: 系統 MUST 提供一個文字元件顯示當前計數數值
- **FR-003**: 系統 MUST 提供一個加號按鈕供使用者點擊
- **FR-004**: 使用者 MUST 能夠點擊加號按鈕使計數值遞增 1
- **FR-005**: 系統 MUST 在使用者每次點擊按鈕後立即更新顯示的計數值
- **FR-006**: 所有 UI 元件 MUST 提供唯一的 Key 或 Semantics 標籤以支援自動化測試定位
- **FR-007**: 計數器文字 MUST 使用清晰易讀的大字體（72px）和深色（#101727）
- **FR-008**: 加號按鈕 MUST 使用深色背景（#030213）和白色加號圖示
- **FR-009**: 加號按鈕 MUST 為圓形，提供足夠的點擊區域（約 64px 直徑）

### 關鍵實體

- **計數器狀態 (Counter State)**: 儲存當前計數值的整數，初始值為 0
- **計數器顯示 (Counter Display)**: 文字元件，顯示當前計數值
- **加號按鈕 (Plus Button)**: 互動按鈕，觸發計數遞增動作

### 非功能性需求 *(憲章驅動)*

**程式碼品質** (依據憲章):
- **NFR-001**: 所有程式碼 MUST 通過 `flutter analyze` 且零警告
- **NFR-002**: 所有程式碼 MUST 使用 `dart format` 格式化

**測試標準** (依據憲章):
- **NFR-003**: 單元測試覆蓋率 MUST ≥80% 針對新增程式碼
- **NFR-004**: P1 使用者故事 MUST 具備整合測試（Widget 測試）
- **NFR-005**: 計數器狀態管理邏輯 MUST 具備單元測試
- **NFR-006**: 按鈕點擊行為 MUST 具備 Widget 測試驗證

**使用者體驗一致性** (依據憲章):
- **NFR-007**: UI MUST 遵循 Material Design 設計規範
- **NFR-008**: UI MUST 支援無障礙功能（Semantics 標籤，螢幕閱讀器支援）
- **NFR-009**: 按鈕點擊 MUST 提供視覺回饋（點擊波紋效果）
- **NFR-010**: 所有文字 MUST 清晰易讀，符合最小對比度要求

**效能需求** (依據憲章):
- **NFR-011**: 應用程式冷啟動 MUST <3 秒
- **NFR-012**: 按鈕點擊回應 MUST 即時（<16ms），維持 60 FPS
- **NFR-013**: 應用程式記憶體使用 MUST <150MB
- **NFR-014**: 計數器更新動畫（如有）MUST 流暢且維持 60 FPS

---

## 成功標準 *(必填)*

### 可衡量的成果

- **SC-001**: 使用者能在 1 秒內理解應用程式功能（顯示計數器和加號按鈕）
- **SC-002**: 使用者點擊按鈕後，計數器 MUST 在 16ms 內更新顯示（60 FPS）
- **SC-003**: 自動化測試 MUST 能夠精確定位並操作所有 UI 元件，成功率 100%
- **SC-004**: 應用程式 MUST 支援連續點擊 100 次而無延遲或錯誤
- **SC-005**: Widget 測試覆蓋率 MUST 達到 100%（涵蓋所有使用者故事）
- **SC-006**: 應用程式在低階設備（2GB RAM）上 MUST 流暢運行（60 FPS）

---

## Figma 設計規格

### 設計檔案資訊

- **Figma 連結**: [Counter App 設計](https://www.figma.com/design/AWdcwmlvvrrjn8t19P0tR7/Untitled?t=c8uQ1x8Dz8UPZ8vA-0)
- **設計資產位置**: `design-assets/`
- **匯出資產**:
  - 完整畫面截圖: `design-assets/screens/counter_app_screen.png` (2x)
  - 加號按鈕: `design-assets/icons/plus_button.png` (2x)
  - 加號圖示: `design-assets/icons/plus_icon.svg`

---

### 色彩系統

本應用程式使用極簡配色方案，強調清晰的視覺層次：

| 色彩名稱 | 十六進制 | RGBA | 使用場景 |
|---------|---------|------|---------|
| **主背景色** | `#FFFFFF` | `rgba(255, 255, 255, 1.0)` | 應用程式主背景、容器背景 |
| **次要背景色** | `#000000` (透明) | `rgba(0, 0, 0, 0.0)` | 透明容器背景 |
| **按鈕背景色** | `#030213` | `rgba(3, 2, 19, 1.0)` | 加號按鈕背景（深藍黑色） |
| **主文字色** | `#101727` | `rgba(16, 23, 39, 1.0)` | 計數器數字（深灰色） |
| **次要文字色** | `#354152` | `rgba(53, 65, 82, 1.0)` | 標題文字（灰藍色） |
| **圖示色** | `#FFFFFF` | `rgba(255, 255, 255, 1.0)` | 加號圖示（白色） |
| **邊框色** | `#1E1E1E` | `rgba(30, 30, 30, 1.0)` | 容器邊框（深灰色） |

**色彩使用原則**:
- 背景使用純白（#FFFFFF）確保最大可讀性
- 按鈕使用深色（#030213）提供強烈視覺對比
- 文字使用深灰色系（#101727, #354152）確保可讀性同時不過於刺眼
- 所有色彩組合符合 WCAG AA 對比度標準（至少 4.5:1）

---

### 排版系統

#### 字體

| 用途 | 字體家族 | 字重 | 大小 | 行高 | 字母間距 |
|------|---------|------|------|------|---------|
| **計數器數字** | Inter | 700 (Bold) | 72px | 108px | 0 |
| **標題文字** | Inter | 400 (Regular) | 16px | 24px | 0 |

**字體使用原則**:
- 使用 Inter 字體確保跨平台一致性和現代感
- 計數器數字使用粗體（700）和大字體（72px）確保可讀性和視覺焦點
- 標題使用標準字重（400）和適中大小（16px）提供清晰的層次結構

#### 命名約定

```dart
// 建議的 Flutter TextStyle 定義
static const TextStyle counterNumberStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 72,
  fontWeight: FontWeight.w700,
  color: Color(0xFF101727),
  height: 1.5, // line-height: 108px / 72px
);

static const TextStyle titleTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(0xFF354152),
  height: 1.5, // line-height: 24px / 16px
);
```

---

### 間距系統

#### 標準間距單位

| 名稱 | 數值 | 用途 |
|------|------|------|
| `spacing-base` | 8px | 基礎間距單位（所有間距的倍數） |
| `spacing-xs` | 8px (1x) | 極小間距 |
| `spacing-sm` | 16px (2x) | 小間距 |
| `spacing-md` | 24px (3x) | 中間距 |
| `spacing-lg` | 32px (4x) | 大間距 |
| `spacing-xl` | 48px (6x) | 極大間距 |

#### 元件內邊距 (Padding)

| 元件 | Padding (L, T, R, B) | 說明 |
|------|---------------------|------|
| **Container** | (未設定具體數值) | 容器內邊距，建議使用 `spacing-md` (24px) |
| **Button** | (約 8px 推算) | 按鈕內邊距，確保圖示周圍有足夠空間 |

#### 元件外邊距 (Margin) 與佈局

- **標題與計數器間距**: 約 56px（根據設計推算）
- **計數器與按鈕間距**: 約 148px（根據設計推算）
- **頁面左右邊距**: 約 36.5px（根據設計推算）

```dart
// 建議的 Flutter Padding/Margin 定義
class AppSpacing {
  static const double base = 8.0;
  static const double xs = 8.0;   // 1x
  static const double sm = 16.0;  // 2x
  static const double md = 24.0;  // 3x
  static const double lg = 32.0;  // 4x
  static const double xl = 48.0;  // 6x
}
```

---

### 其他視覺參數

#### 圓角 (Border Radius)

| 元件 | 圓角半徑 | 說明 |
|------|---------|------|
| **Container** | 16px | 容器使用中等圓角，提供友善的視覺效果 |
| **Button** | 全圓形 | 按鈕為完美圓形（cornerRadius = 寬度/2） |

```dart
// Flutter BorderRadius 定義
static const BorderRadius containerRadius = BorderRadius.all(
  Radius.circular(16.0),
);

// Button 使用 CircleAvatar 或設定 borderRadius = width/2
```

#### 陰影 (Elevation/Shadow)

目前設計**未使用陰影效果**，保持扁平化設計風格。如需增加深度感，建議：

- Container 可使用輕微陰影：`elevation: 2`
- Button 可使用適度陰影：`elevation: 4`

#### 邊框 (Border)

| 元件 | 邊框寬度 | 邊框樣式 | 邊框顏色 | 說明 |
|------|---------|---------|---------|------|
| **Container** | 0px | 無邊框 | N/A | 當前設計無邊框 |
| **Button** | 0px | 無邊框 | N/A | 當前設計無邊框 |

*註: 如需增加邊框，建議使用 1-2px 實線邊框，顏色使用 #1E1E1E*

#### 元件尺寸

| 元件 | 寬度 | 高度 | 說明 |
|------|------|------|------|
| **應用程式畫面** | 393px | 852px | 標準手機螢幕尺寸 |
| **Container** | 320px | 372px | 主容器尺寸（約佔螢幕寬度 81%） |
| **加號按鈕** | 64px | 64px | 圓形按鈕，提供足夠點擊區域 |
| **加號圖示** | 16px | 16px | 圖示尺寸（位於按鈕中央） |
| **計數器數字** | 自動 | 108px | 文字高度（基於 72px 字體和行高） |
| **標題文字** | 自動 | 24px | 文字高度（基於 16px 字體和行高） |

---

## UI 元件規格

### 1. 計數器顯示元件 (Counter Display Widget)

#### 元件資訊

- **元件名稱**: CounterDisplay
- **用途**: 顯示當前計數值
- **Figma 節點**: Text "37" (id: 0:8)
- **元件類型**: Text Widget

#### 元件結構與屬性

```
CounterDisplay
├── Container (選用，用於背景/邊距)
└── Text
    ├── data: 計數值字串
    ├── style: counterNumberStyle
    ├── textAlign: center
    └── key: Key('counter_display_text')
```

**屬性說明**:
- **data**: 動態綁定到計數器狀態值
- **style**: 使用 counterNumberStyle（72px, Inter Bold, #101727）
- **textAlign**: 置中對齊
- **key**: 用於測試定位，必須唯一

#### 互動狀態

本元件為顯示元件，無互動狀態。

| 狀態 | 描述 | 視覺效果 |
|------|------|---------|
| Default | 正常顯示狀態 | 顯示當前計數值 |

#### Flutter Widget 程式碼範例

```dart
class CounterDisplay extends StatelessWidget {
  final int count;

  const CounterDisplay({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count',
      key: const Key('counter_display_text'),
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 72,
        fontWeight: FontWeight.w700,
        color: Color(0xFF101727),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
      semanticsLabel: '計數器數值: $count',
    );
  }
}
```

---

### 2. 加號按鈕元件 (Plus Button Widget)

#### 元件資訊

- **元件名稱**: PlusButton
- **用途**: 提供點擊互動以遞增計數值
- **Figma 節點**: Button (id: 0:9) 和 Icon (id: 0:10)
- **元件類型**: IconButton 或 FloatingActionButton

#### 元件結構與屬性

```
PlusButton
├── Container (圓形背景)
│   ├── width: 64
│   ├── height: 64
│   ├── decoration: 圓形, 背景色 #030213
│   └── key: Key('plus_button')
└── Icon (加號)
    ├── icon: Icons.add
    ├── size: 24 (約圖示區域的視覺大小)
    ├── color: #FFFFFF
    └── semanticsLabel: '增加計數'
```

**屬性說明**:
- **尺寸**: 64x64 像素，提供足夠的點擊區域
- **形狀**: 完美圓形
- **背景色**: #030213（深藍黑色）
- **圖示**: Material Icons 的 add 圖示
- **圖示顏色**: #FFFFFF（白色）
- **key**: 用於測試定位

#### 互動狀態

| 狀態 | 描述 | 視覺效果 |
|------|------|---------|
| Default | 預設狀態，等待使用者互動 | 深色背景，白色圖示 |
| Hover | 滑鼠懸停（桌面）| 可選：輕微放大或透明度變化 |
| Pressed | 按鈕被按下 | Material 波紋效果，輕微縮小 |
| Disabled | 按鈕禁用（目前不適用）| N/A |

#### Flutter Widget 程式碼範例

```dart
class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlusButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: FloatingActionButton(
        key: const Key('plus_button'),
        onPressed: onPressed,
        backgroundColor: const Color(0xFF030213),
        elevation: 0, // 扁平化設計，無陰影
        child: const Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 24,
          semanticLabel: '增加計數',
        ),
      ),
    );
  }
}
```

---

### 3. 標題文字元件 (Title Text Widget)

#### 元件資訊

- **元件名稱**: TitleText
- **用途**: 顯示應用程式標題「計數器」
- **Figma 節點**: Text "計數器" (id: 0:6)
- **元件類型**: Text Widget

#### 元件結構與屬性

```
TitleText
└── Text
    ├── data: "計數器"
    ├── style: titleTextStyle
    ├── textAlign: center
    └── key: Key('title_text')
```

#### Flutter Widget 程式碼範例

```dart
class TitleText extends StatelessWidget {
  const TitleText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '計數器',
      key: const Key('title_text'),
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF354152),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
      semanticsLabel: '應用程式標題: 計數器',
    );
  }
}
```

---

## 頁面佈局規格

### 頁面結構樹狀圖

```
Counter App Screen (393 x 852)
└── Container (主容器)
    ├── 背景: 白色 (#FFFFFF)
    ├── 圓角: 16px
    ├── 佈局: Column (垂直)
    └── 子元件:
        ├── TitleText (標題)
        │   └── Text: "計數器"
        ├── Spacer or SizedBox (間距: ~56px)
        ├── CounterDisplay (計數顯示)
        │   └── Text: 當前計數值
        ├── Spacer or SizedBox (間距: ~148px)
        └── PlusButton (加號按鈕)
            └── Icon: add
```

### 元素位置關係和對齊方式

- **主容器**: 
  - 水平置中於螢幕
  - 垂直位置: 距離頂部約 240px
  - 寬度: 320px
  - 高度: 372px

- **標題文字**:
  - 位於主容器頂部
  - 水平置中對齊
  - 距離容器頂部: 約 48px

- **計數器顯示**:
  - 位於主容器中央偏上
  - 水平置中對齊
  - 距離標題: 約 56px

- **加號按鈕**:
  - 位於主容器底部
  - 水平置中對齊
  - 距離計數器顯示: 約 148px

### 關鍵尺寸和斷點

**目標螢幕尺寸**: 393 x 852 (標準手機螢幕)

**響應式設計考量**:
- 小螢幕 (< 360px 寬): 縮小容器寬度至 90% 螢幕寬
- 中等螢幕 (360-600px): 維持 320px 容器寬度
- 大螢幕 (> 600px): 可選擇增加容器寬度或保持居中

**最小支援尺寸**: 320 x 568 (iPhone SE)

### Flutter 頁面程式碼範例

```dart
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 48,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 標題
              const TitleText(),
              
              const SizedBox(height: 56),
              
              // 計數器顯示
              CounterDisplay(count: _counter),
              
              const SizedBox(height: 148),
              
              // 加號按鈕
              PlusButton(
                onPressed: _incrementCounter,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CounterDisplay, PlusButton, TitleText 元件定義見上方「UI 元件規格」章節
```

---

## 測試策略

### 單元測試

**測試目標**:
- 計數器狀態管理邏輯
- 數值遞增功能

**測試案例**:
```dart
test('初始計數值應為 0', () {
  final counter = Counter();
  expect(counter.value, 0);
});

test('increment() 應將計數值加 1', () {
  final counter = Counter();
  counter.increment();
  expect(counter.value, 1);
});

test('連續呼叫 increment() 三次應得到 3', () {
  final counter = Counter();
  counter.increment();
  counter.increment();
  counter.increment();
  expect(counter.value, 3);
});
```

### Widget 測試

**測試目標**:
- UI 元件正確渲染
- 使用者互動行為
- 自動化測試定位

**測試案例**:
```dart
testWidgets('應顯示初始計數值 0', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  final counterText = find.byKey(const Key('counter_display_text'));
  expect(counterText, findsOneWidget);
  expect(find.text('0'), findsOneWidget);
});

testWidgets('點擊加號按鈕應增加計數', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // 驗證初始值
  expect(find.text('0'), findsOneWidget);
  
  // 點擊按鈕
  await tester.tap(find.byKey(const Key('plus_button')));
  await tester.pump();
  
  // 驗證計數增加
  expect(find.text('1'), findsOneWidget);
  expect(find.text('0'), findsNothing);
});

testWidgets('連續點擊三次應顯示 3', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  final button = find.byKey(const Key('plus_button'));
  
  await tester.tap(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
  
  expect(find.text('3'), findsOneWidget);
});
```

### 無障礙測試

**測試目標**:
- Semantics 標籤正確性
- 螢幕閱讀器支援

**測試案例**:
```dart
testWidgets('應提供正確的 Semantics 標籤', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // 驗證計數器文字的 Semantics
  expect(
    tester.getSemantics(find.byKey(const Key('counter_display_text'))),
    matchesSemantics(label: contains('計數器數值')),
  );
  
  // 驗證按鈕的 Semantics
  expect(
    tester.getSemantics(find.byKey(const Key('plus_button'))),
    matchesSemantics(
      label: '增加計數',
      isButton: true,
    ),
  );
});
```

---

## 假設與限制

### 假設

- 使用者裝置支援 Flutter 的最低系統需求
- 計數值不需要持久化儲存（應用程式重啟後重置為 0）
- 計數值不會超過 Dart int 的最大值（2^63 - 1）
- 使用者具備基本的觸控操作能力
- 應用程式僅需支援直向模式（portrait）

### 限制

- 當前版本不支援計數減少功能
- 當前版本不支援計數重置功能
- 計數值不保存到本地儲存或雲端
- 不支援多使用者或多計數器
- 不支援橫向模式（landscape）
- 不支援深色模式（dark mode）主題切換

---

## 附錄

### 設計資產清單

| 資產名稱 | 檔案路徑 | 格式 | 尺寸/縮放 | 用途 |
|---------|---------|------|----------|------|
| 完整畫面 | `design-assets/screens/counter_app_screen.png` | PNG | 2x (786x1704) | 設計參考、文件說明 |
| 加號按鈕 | `design-assets/icons/plus_button.png` | PNG | 2x (128x128) | UI 實作參考 |
| 加號圖示 | `design-assets/icons/plus_icon.svg` | SVG | 向量 | 可縮放圖示資源 |

### 技術堆疊建議

- **Flutter SDK**: ≥3.0.0
- **Dart SDK**: ≥2.19.0
- **狀態管理**: Provider / Riverpod / Bloc（團隊選擇）
- **測試框架**: flutter_test (內建)
- **字體**: Inter（需在 pubspec.yaml 中宣告或使用 Google Fonts）

### 參考連結

- [Figma 設計檔案](https://www.figma.com/design/AWdcwmlvvrrjn8t19P0tR7/Untitled?t=c8uQ1x8Dz8UPZ8vA-0)
- [Flutter 官方文件 - State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)
- [Flutter 官方文件 - Testing](https://docs.flutter.dev/testing)
- [Material Design - Touch Targets](https://m3.material.io/foundations/interaction/states/overview)

---

**文件版本**: 1.0.0  
**最後更新**: 2025-11-21  
**維護者**: 專案團隊
