# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
swift build                                      # compile (requires Swift 6.0+)
cp .build/debug/Pomodoro Pomodoro.app/Contents/MacOS/Pomodoro
open Pomodoro.app                                # launch
```

No Xcode required — Command Line Tools with Swift 6.0+ is sufficient.

## Architecture

MVVM with a centralized `DataStore` as the single source of truth. No SwiftData — persistence uses JSON files.

**Data flow:** `DataStore` → `ViewModels` → `Views`. Views never touch persistence directly. `ContentView` owns all state objects and injects them.

**Persistence:** `DataStore` reads/writes `tasks.json` and `records.json` in `~/Library/Application Support/Pomodoro/`. Each entity type has its own targeted save method (not bulk). Records capped at 500 entries.

## Key Components

### DataStore (`Sources/Services/DataStore.swift`)
`@MainActor` `ObservableObject`. Holds `@Published tasks` and `@Published records`. All mutations go through methods (`addTask`, `updateTask`, `addRecord`, etc.) that persist immediately. Split save methods (`saveTasks` / `saveRecords`) — adding a task does not rewrite records.

### TimerViewModel (`Sources/ViewModels/TimerViewModel.swift`)
State machine: `idle → running → paused/running → finished → idle`. Phases: `.focus → .shortBreak/.longBreak → .focus`.

- Timer driven by `Timer.publish(every: 1, on: .main)` Combine publisher
- When `remainingSeconds` hits 0, timer is cancelled and state moves to `.finished`
- `justFinishedPhase: TimerPhase?` exposes which phase just ended (for record-keeping)
- Duration settings via `@AppStorage` with `refreshDurations()` to apply changes
- `TimerPhase` extension holds `title` and `color` computed properties

### ViewModels
- `TaskViewModel` — task CRUD, selection state, computed `activeTaskCount` and `isNewTaskTitleEmpty`
- `StatisticsViewModel` — reads from DataStore, `records` is a computed property (not duplicate `@Published`)

### ContentView orchestration
Uses `onReceive(timerViewModel.$state.filter { $0 == .finished })` instead of `onChange` to avoid firing on every state transition. `handlePhaseCompletion()` creates a `PomodoroRecord`, increments the task's pomodoro count, sends notification, and plays sound.

### Models
- `PomodoroTask` — struct with `Identifiable, Codable, Equatable`
- `PomodoroRecord` — struct with `RecordType` enum (`.focus`, `.shortBreak`, `.longBreak`), `Identifiable, Codable`
- `RecordType: String, Codable` — not a raw string

### Services (singletons, `@MainActor`)
- `NotificationService.shared` — `UserNotifications` permission + delivery. `send()` is `nonisolated`.
- `SoundService.shared` — preloads `AVAudioPlayer` at init, reuses it. Falls back to `NSSound.beep()`.

### Views
- `NavigationSplitView` with sidebar tabs: Timer, Tasks, Statistics, Settings
- `TimerView` — circular progress ring (no animation — 1 Hz tick), phase-colored, state-dependent buttons
- `TaskListView` / `TaskRowView` — task management with selection synced to timer
- `SettingsView` — uses extracted `DurationSlider` component for 4 slider blocks
- `StatisticsView` — stat cards + recent records list
