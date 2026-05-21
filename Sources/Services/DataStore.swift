import Foundation
import OSLog

private let logger = Logger(subsystem: "com.pomodoro.app", category: "DataStore")

@MainActor
final class DataStore: ObservableObject {
    @Published var tasks: [PomodoroTask] = []
    @Published var records: [PomodoroRecord] = []

    private let maxRecords = 500
    private let tasksURL: URL
    private let recordsURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("Pomodoro")
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        tasksURL = folder.appendingPathComponent("tasks.json")
        recordsURL = folder.appendingPathComponent("records.json")
        load()
    }

    private func saveTasks() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(tasks)
            try data.write(to: tasksURL)
        } catch {
            logger.error("Failed to save tasks: \(error.localizedDescription)")
        }
    }

    private func saveRecords() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(records)
            try data.write(to: recordsURL)
        } catch {
            logger.error("Failed to save records: \(error.localizedDescription)")
        }
    }

    private func load() {
        let decoder = JSONDecoder()
        if let data = try? Data(contentsOf: tasksURL),
           let loaded = try? decoder.decode([PomodoroTask].self, from: data) {
            tasks = loaded
        }
        if let data = try? Data(contentsOf: recordsURL),
           let loaded = try? decoder.decode([PomodoroRecord].self, from: data) {
            records = loaded
        }
    }

    func addTask(_ task: PomodoroTask) {
        tasks.append(task)
        saveTasks()
    }

    func deleteTask(_ task: PomodoroTask) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }

    func updateTask(_ task: PomodoroTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }

    func addRecord(_ record: PomodoroRecord) {
        records.append(record)
        if records.count > maxRecords {
            records = Array(records.suffix(maxRecords))
        }
        saveRecords()
    }
}
