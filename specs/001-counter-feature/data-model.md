# 資料模型設計：計數器應用程式

**專案**: 計數器應用程式  
**功能分支**: `001-counter-feature`  
**版本**: 1.0.0  
**日期**: 2025-11-21

**目的**: 定義計數器應用程式的資料結構、狀態管理策略和業務邏輯。

---

## 1. 資料模型概覽

計數器應用程式是一個簡單的暫態應用程式，不需要持久化儲存。資料模型僅包含一個實體：**Counter**。

### 1.1 實體關係圖

```
┌───────────────────────────┐
│       Counter             │
├───────────────────────────┤
│ - _value: int             │
├───────────────────────────┤
│ + Counter({initialValue}) │
│ + value: int              │
│ + isAtMaxValue: bool      │
│ + increment(): void       │
│ + reset(): void           │
└───────────────────────────┘
```

**說明**: Counter 是唯一的資料模型，封裝計數值和相關業務邏輯。

---

## 2. Counter 模型

### 2.1 類別定義

```dart
/// 計數器模型，管理計數值和相關業務邏輯
class Counter {
  /// Dart int 的最大值 (2^63 - 1)
  static const int maxValue = 9223372036854775807;

  /// 私有計數值，封裝內部狀態
  int _value;

  /// 建構函式，允許設定初始值（預設為 0）
  Counter({int initialValue = 0}) : _value = initialValue {
    // 驗證初始值不超過最大值
    if (_value > maxValue) {
      throw ArgumentError('初始值不能超過最大值 $maxValue');
    }
    if (_value < 0) {
      throw ArgumentError('初始值不能為負數');
    }
  }

  /// 取得當前計數值（唯讀）
  int get value => _value;

  /// 檢查是否達到最大值
  bool get isAtMaxValue => _value >= maxValue;

  /// 增加計數值（如果未達最大值）
  void increment() {
    if (!isAtMaxValue) {
      _value++;
    }
  }

  /// 重置計數值為 0
  void reset() {
    _value = 0;
  }

  @override
  String toString() => 'Counter(value: $_value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Counter && other._value == _value;
  }

  @override
  int get hashCode => _value.hashCode;
}
```

### 2.2 屬性說明

| 屬性 | 類型 | 可見性 | 描述 |
|------|------|--------|------|
| `maxValue` | `int` | static const | Dart int 最大值（2^63 - 1） |
| `_value` | `int` | private | 當前計數值，封裝防止外部直接修改 |
| `value` | `int` | public getter | 唯讀屬性，取得當前計數值 |
| `isAtMaxValue` | `bool` | public getter | 唯讀屬性，檢查是否達到最大值 |

### 2.3 方法說明

#### `Counter({int initialValue = 0})`
建構函式，建立 Counter 實例。

**參數**:
- `initialValue`: 初始計數值，預設為 0

**驗證規則**:
- 初始值必須 >= 0
- 初始值必須 <= maxValue

**例外**:
- `ArgumentError`: 初始值不在有效範圍內

**範例**:
```dart
final counter1 = Counter(); // 初始值為 0
final counter2 = Counter(initialValue: 100); // 初始值為 100
```

#### `int get value`
取得當前計數值。

**回傳**:
- `int`: 當前計數值（0 到 maxValue）

**範例**:
```dart
final counter = Counter();
print(counter.value); // 輸出: 0
```

#### `bool get isAtMaxValue`
檢查計數值是否達到最大值。

**回傳**:
- `true`: 計數值 >= maxValue
- `false`: 計數值 < maxValue

**用途**: UI 根據此屬性決定是否禁用增加按鈕

**範例**:
```dart
final counter = Counter(initialValue: Counter.maxValue);
print(counter.isAtMaxValue); // 輸出: true
```

#### `void increment()`
增加計數值 1。

**行為**:
- 如果 `isAtMaxValue == false`，則 `_value++`
- 如果 `isAtMaxValue == true`，則不執行任何操作（冪等）

**無回傳值**

**範例**:
```dart
final counter = Counter();
counter.increment();
print(counter.value); // 輸出: 1

counter.increment();
print(counter.value); // 輸出: 2
```

#### `void reset()`
重置計數值為 0。

**行為**:
- 將 `_value` 設定為 0，無條件執行

**用途**: 應用程式從背景恢復時呼叫

**無回傳值**

**範例**:
```dart
final counter = Counter(initialValue: 100);
counter.reset();
print(counter.value); // 輸出: 0
```

### 2.4 業務規則

| 規則 ID | 規則描述 | 實作位置 |
|---------|---------|---------|
| BR-001 | 計數值必須 >= 0 | 建構函式驗證 |
| BR-002 | 計數值必須 <= 2^63 - 1 | 建構函式驗證 + increment() 邊界檢查 |
| BR-003 | 達到最大值後，increment() 不增加數值 | increment() 方法 |
| BR-004 | reset() 總是將計數值設為 0 | reset() 方法 |
| BR-005 | 從背景恢復時自動重置 | UI 層生命週期處理（不在模型內）|

---

## 3. 狀態管理策略

### 3.1 選擇的方案: StatefulWidget + setState

**理由**:
1. 專案要求明確指定使用 setState
2. 應用程式狀態簡單（單一整數）
3. 無需跨 Widget 狀態共享
4. 無需複雜的狀態組合或衍生狀態

### 3.2 狀態持有者

**CounterScreen** 是唯一的 StatefulWidget，持有 Counter 實例。

```dart
class _CounterScreenState extends State<CounterScreen> with WidgetsBindingObserver {
  late Counter _counter;

  @override
  void initState() {
    super.initState();
    _counter = Counter(); // 建立 Counter 實例
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter.increment(); // 呼叫模型方法
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _counter.reset(); // 從背景恢復時重置
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CounterDisplay(count: _counter.value),
            const SizedBox(height: 24),
            PlusButton(
              onPressed: _counter.isAtMaxValue ? null : _incrementCounter,
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3.3 資料流向

```
使用者點擊按鈕
    ↓
PlusButton.onPressed 回呼
    ↓
_incrementCounter()
    ↓
setState(() { _counter.increment(); })
    ↓
Counter._value++
    ↓
build() 重新執行
    ↓
CounterDisplay 收到新的 count 屬性
    ↓
UI 更新顯示新數值
```

### 3.4 狀態生命週期

| 事件 | 觸發時機 | 狀態變化 |
|------|---------|---------|
| 應用程式啟動 | `initState()` | Counter 建立，_value = 0 |
| 使用者點擊按鈕 | `onPressed` | _value++ (如果 < maxValue) |
| 達到最大值 | `isAtMaxValue == true` | 按鈕禁用，_value 不變 |
| 應用程式進入背景 | `AppLifecycleState.paused` | 無狀態變化 |
| 應用程式恢復前景 | `AppLifecycleState.resumed` | _value = 0 |
| 應用程式關閉 | `dispose()` | Counter 銷毀 |

---

## 4. 資料驗證

### 4.1 輸入驗證

| 輸入 | 驗證規則 | 錯誤處理 |
|------|---------|---------|
| `initialValue` | >= 0 且 <= maxValue | 拋出 ArgumentError |

### 4.2 狀態不變性保證

| 不變性 | 保證方式 |
|--------|---------|
| 計數值永遠 >= 0 | 建構函式驗證 + reset() 設為 0 |
| 計數值永遠 <= maxValue | 建構函式驗證 + increment() 邊界檢查 |
| 外部無法直接修改 _value | 私有屬性，僅提供 getter |

---

## 5. 測試策略

### 5.1 單元測試（Counter 模型）

```dart
void main() {
  group('Counter', () {
    test('預設初始值為 0', () {
      final counter = Counter();
      expect(counter.value, 0);
    });

    test('可設定初始值', () {
      final counter = Counter(initialValue: 100);
      expect(counter.value, 100);
    });

    test('負數初始值應拋出 ArgumentError', () {
      expect(
        () => Counter(initialValue: -1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('超過最大值的初始值應拋出 ArgumentError', () {
      expect(
        () => Counter(initialValue: Counter.maxValue + 1),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('increment() 應增加數值', () {
      final counter = Counter();
      counter.increment();
      expect(counter.value, 1);
    });

    test('達到最大值時 isAtMaxValue 為 true', () {
      final counter = Counter(initialValue: Counter.maxValue);
      expect(counter.isAtMaxValue, true);
    });

    test('達到最大值後 increment() 不增加數值', () {
      final counter = Counter(initialValue: Counter.maxValue);
      counter.increment();
      expect(counter.value, Counter.maxValue);
    });

    test('reset() 應將數值設為 0', () {
      final counter = Counter(initialValue: 100);
      counter.reset();
      expect(counter.value, 0);
    });

    test('toString() 應回傳正確格式', () {
      final counter = Counter(initialValue: 42);
      expect(counter.toString(), 'Counter(value: 42)');
    });

    test('相同數值的 Counter 應相等', () {
      final counter1 = Counter(initialValue: 10);
      final counter2 = Counter(initialValue: 10);
      expect(counter1, counter2);
    });
  });
}
```

### 5.2 Widget 測試（狀態管理整合）

參見 `spec.md` 的測試章節。

---

## 6. 效能考量

### 6.1 記憶體使用

| 物件 | 大小估算 | 數量 | 總計 |
|------|---------|------|------|
| Counter 實例 | 24 bytes（物件標頭 + int） | 1 | 24 bytes |
| _CounterScreenState | ~200 bytes | 1 | ~200 bytes |

**總記憶體使用**: < 1 KB

**符合憲章**: 遠低於 150MB 的記憶體預算。

### 6.2 運算複雜度

| 操作 | 時間複雜度 | 說明 |
|------|-----------|------|
| `Counter()` | O(1) | 簡單賦值 |
| `increment()` | O(1) | 一次比較 + 一次加法 |
| `reset()` | O(1) | 簡單賦值 |
| `isAtMaxValue` | O(1) | 一次比較 |

**符合憲章**: 所有操作都是 O(1)，按鈕響應時間 < 1ms，遠低於 16ms 的目標。

---

## 7. 延展性考量

### 7.1 未來可能的擴展

| 擴展需求 | 修改策略 | 影響範圍 |
|---------|---------|---------|
| 支援減少計數 | 新增 `decrement()` 方法 | Counter 模型 + UI |
| 持久化儲存 | 新增 `save()` 和 `load()` 方法 | Counter 模型 + 新增儲存層 |
| 步進值可調整 | 新增 `step` 屬性，修改 `increment()` | Counter 模型 |
| 多計數器 | 使用 List<Counter> | CounterScreen 狀態 |

### 7.2 不支援的功能（有意排除）

| 功能 | 排除理由 |
|------|---------|
| 持久化儲存 | spec.md 明確定義為「暫態設計」 |
| 減少計數 | spec.md 未包含此需求 |
| 計數歷史記錄 | 超出 MVP 範圍 |
| 多使用者同步 | 單機應用程式 |

---

## 8. 資料模型變更記錄

| 版本 | 日期 | 變更內容 | 理由 |
|------|------|---------|------|
| 1.0.0 | 2025-11-21 | 初始版本 | 基於 spec.md 和 research.md 建立 |

---

## 9. 相依關係

### 9.1 對外相依性

- **flutter**: SDK（提供 Widget 系統）
- **dart:core**: Dart 核心函式庫（int, bool 等）

### 9.2 被相依性

- **CounterScreen**: 使用 Counter 作為狀態模型
- **單元測試**: 測試 Counter 的業務邏輯

---

## 10. 檔案結構

```
lib/
├── models/
│   └── counter.dart          # Counter 類別定義
test/
├── unit/
│   └── counter_test.dart     # Counter 單元測試
```

---

**資料模型版本**: 1.0.0  
**文件狀態**: ✅ 完成  
**下一步**: 產生 `quickstart.md` 並開始實作
