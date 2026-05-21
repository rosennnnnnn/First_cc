import Foundation

struct PomodoroTask: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var createdAt: Date
    var isCompleted: Bool
    var completedPomodoros: Int

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.createdAt = Date()
        self.isCompleted = false
        self.completedPomodoros = 0
    }
}
