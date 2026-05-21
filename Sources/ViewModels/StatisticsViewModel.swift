import Foundation

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var todayCount: Int = 0
    @Published var weekCount: Int = 0
    @Published var totalCount: Int = 0
    @Published var todayMinutes: Int = 0

    private let store: DataStore

    var records: [PomodoroRecord] {
        store.records.sorted { $0.date > $1.date }
    }

    init(store: DataStore) {
        self.store = store
    }

    func refresh() {
        let allRecords = store.records
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date.distantPast

        let focusRecords = allRecords.filter { $0.type == .focus }
        totalCount = focusRecords.count
        todayCount = focusRecords.filter { $0.date >= today }.count
        weekCount = focusRecords.filter { $0.date >= weekStart }.count
        todayMinutes = focusRecords
            .filter { $0.date >= today }
            .reduce(0) { $0 + $1.duration } / 60
    }
}
