# Pomodoro 🍅

一个简洁优雅的 **番茄钟 macOS 桌面应用**，帮助你专注工作、管理任务、追踪效率。

## ✨ 功能

- **番茄钟计时器** — 专注 / 短休息 / 长休息 循环模式，经典的番茄工作法流程
- **任务管理** — 创建、编辑、删除任务，绑定番茄钟记录
- **统计面板** — 查看专注历史、完成次数、时间分布
- **系统通知** — 每个番茄钟阶段结束时发送系统通知
- **音效提示** — 阶段切换时播放提示音
- **可自定义** — 每个阶段的时长可在设置中自由调整

## 系统要求

- macOS 14.0+
- Swift 6.0+
- 无需 Xcode，仅需 Command Line Tools

## 快速开始

```bash
# 编译
swift build

# 安装二进制到 App Bundle
cp .build/debug/Pomodoro Pomodoro.app/Contents/MacOS/Pomodoro

# 启动
open Pomodoro.app
```

## 项目结构

```
First_cc/
├── Package.swift                    # Swift 包配置
├── Pomodoro.app/                    # macOS App Bundle
├── README.md
├── Sources/
│   ├── App/
│   │   └── PomodoroApp.swift        # App 入口
│   ├── Models/
│   │   ├── PomodoroTask.swift       # 任务模型
│   │   └── PomodoroRecord.swift     # 记录模型
│   ├── Services/
│   │   ├── DataStore.swift          # 数据持久化（JSON）
│   │   ├── NotificationService.swift # 系统通知
│   │   └── SoundService.swift       # 音效服务
│   ├── ViewModels/
│   │   ├── TimerViewModel.swift     # 计时器状态机
│   │   ├── TaskViewModel.swift      # 任务管理
│   │   └── StatisticsViewModel.swift # 统计数据
│   └── Views/
│       ├── ContentView.swift        # 主布局
│       ├── TimerView.swift          # 环形进度条
│       ├── TaskListView.swift       # 任务列表
│       ├── TaskRowView.swift        # 任务行
│       ├── StatisticsView.swift     # 统计视图
│       └── SettingsView.swift       # 设置视图
```

## 架构

MVVM 架构，以 `DataStore` 为单一数据源。不使用 SwiftData，数据通过 JSON 文件持久化。

**数据流：** `DataStore` → `ViewModels` → `Views`

**计时器状态机：**

```
idle → running → paused → running → finished → idle
```

**阶段循环：**

```
focus → shortBreak → focus → longBreak → focus → ...
```

**持久化位置：** `~/Library/Application Support/Pomodoro/`

## 使用

1. 在「Tasks」中创建你想要专注的任务
2. 选中一个任务，点击「Timer」开始计时
3. 专注 25 分钟，休息 5 分钟，每 4 轮专注后进入长休息
4. 在「Statistics」中查看你的效率数据
5. 在「Settings」中调整各阶段时长

## 技术栈

- Swift 6.0
- SwiftUI
- Combine
- AppStorage
- UserNotifications
- AVFoundation
