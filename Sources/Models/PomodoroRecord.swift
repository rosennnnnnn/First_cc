import Foundation

enum RecordType: String, Codable {
    case focus
    case shortBreak
    case longBreak
}

struct PomodoroRecord: Identifiable, Codable {
    var id: UUID
    var date: Date
    var duration: Int
    var type: RecordType
    var taskTitle: String?

    init(date: Date, duration: Int, type: RecordType, taskTitle: String? = nil) {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.type = type
        self.taskTitle = taskTitle
    }
}
