# 📈 Real-Time Instruments Dashboard with BLoC

This Flutter project demonstrates real-time financial instrument tracking using BLoC, WebSocket, and REST APIs.

## 🧠 Event Handling Strategy

We handle distinct event types in a clear and maintainable way using separate `on<Event>` handlers.

### 📦 Event Types

| Event               | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `LoadInstruments`   | Fetches the full list of instruments from the REST API, initializes WebSocket, and sets up internal cache. |
| `InstrumentUpdated` | Triggered by a WebSocket update; updates the specific instrument using its ID. |

```dart
on<LoadInstruments>(_onLoadInstruments);
on<InstrumentUpdated>(_onInstrumentUpdated);
```

### 🧩 Strategy Highlights

- **Isolated Handlers**: Each event has a dedicated handler method for clarity.
- **Granular Updates**: Instruments are updated by ID; avoids unnecessary list reprocessing.
- **Internal Cache**: `_cachedInstruments` enables quick state restoration and fast lookup.

---

## 🔄 Connection Lifecycle Handling

We use [`connectivity_plus`](https://pub.dev/packages/connectivity_plus) to monitor network status and manage reconnection behavior.

### ⚙️ Features

- Detects changes in network state.
- Automatically reloads instruments on connection restore.
- Clears cache and emits error on disconnection.
- Gracefully cleans up and re-establishes WebSocket streams.

```dart
_connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
  if (result != _lastConnectionStatus) {
    _lastConnectionStatus = result;
    if (result == ConnectivityResult.none) {
      _cachedInstruments.clear();
      emit(InstrumentsError("No internet connection"));
    } else {
      add(LoadInstruments());
    }
  }
});
```

---

## ⚖️ Design Trade-Offs

### ✅ Chosen

| Decision | Reason |
|---------|--------|
| Internal cache (`_cachedInstruments`) | Enables efficient mutation and avoids full re-fetches. |
| `List.from(...)` when emitting | Prevents shallow mutation issues that can break UI rendering. |
| Stream cleanup in `close()` | Ensures memory-safe shutdown of WebSocket & listeners. |

### ❌ Avoided

| Option | Reason for Avoidance |
|--------|----------------------|
| Emitting entire state on every update | Too costly for large lists and inefficient. |
| Union event types or dynamic dispatch | Harder to read, debug, and test. |
| Keeping WebSocket always active | Wasteful during disconnection; breaks user expectations. |