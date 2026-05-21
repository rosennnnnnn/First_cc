import SwiftUI

struct ContentView: View {
    @StateObject private var store: DataStore
    @StateObject private var timerViewModel = TimerViewModel()
    @StateObject private var taskViewModel: TaskViewModel
    @StateObject private var statisticsViewModel: StatisticsViewModel
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    @State private var selectedTab: Tab = .timer

    enum Tab: String, CaseIterable {
        case timer = "Timer"
        case tasks = "Tasks"
        case statistics = "Statistics"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .timer: return "timer"
            case .tasks: return "checklist"
            case .statistics: return "chart.bar"
            case .settings: return "gearshape"
            }
        }
    }

    init() {
        let store = DataStore()
        _store = StateObject(wrappedValue: store)
        _taskViewModel = StateObject(wrappedValue: TaskViewModel(store: store))
        _statisticsViewModel = StateObject(wrappedValue: StatisticsViewModel(store: store))
    }

    var body: some View {
        NavigationSplitView {
            List(Tab.allCases, id: \.self, selection: $selectedTab) { tab in
                Label(tab.rawValue, systemImage: tab.icon)
                    .font(.body)
            }
            .listStyle(.sidebar)
            .frame(minWidth: 160)
        } detail: {
            switch selectedTab {
            case .timer:
                TimerView(viewModel: timerViewModel)
            case .tasks:
                TaskListView(viewModel: taskViewModel, timerViewModel: timerViewModel)
            case .statistics:
                StatisticsView(viewModel: statisticsViewModel)
            case .settings:
                SettingsView(timerViewModel: timerViewModel)
            }
        }
        .frame(minWidth: 600, minHeight: 440)
        .onAppear {
            NotificationService.shared.requestPermission()
        }
        .onReceive(timerViewModel.$state.filter { $0 == .finished }) { _ in
            handlePhaseCompletion()
        }
    }

    private func handlePhaseCompletion() {
        statisticsViewModel.refresh()

        if let taskTitle = timerViewModel.currentTaskTitle,
           let task = store.tasks.first(where: { $0.title == taskTitle && !$0.isCompleted }) {
            taskViewModel.incrementPomodoro(task)
        }

        let justFinishedWasFocus = timerViewModel.justFinishedPhase == .focus
        let recordType: RecordType = justFinishedWasFocus ? .focus : .shortBreak
        let record = PomodoroRecord(
            date: Date(),
            duration: timerViewModel.totalSeconds - timerViewModel.remainingSeconds,
            type: recordType,
            taskTitle: timerViewModel.currentTaskTitle
        )
        store.addRecord(record)

        let title = justFinishedWasFocus ? "Focus Done" : "Break Over"
        let body = justFinishedWasFocus
            ? "Great job! Time for a break."
            : "Break is over. Ready to focus?"

        NotificationService.shared.send(title: title, body: body)

        if soundEnabled {
            SoundService.shared.playCompletion()
        }
    }
}
