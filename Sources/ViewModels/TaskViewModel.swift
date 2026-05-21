import Foundation
import SwiftUI

@MainActor
final class TaskViewModel: ObservableObject {
    @Published var newTaskTitle: String = ""
    @Published var selectedTask: PomodoroTask?

    private let store: DataStore

    var tasks: [PomodoroTask] { store.tasks }

    var activeTaskCount: Int {
        tasks.lazy.filter { !$0.isCompleted }.count
    }

    var isNewTaskTitleEmpty: Bool {
        newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(store: DataStore) {
        self.store = store
    }

    func addTask() {
        guard !isNewTaskTitleEmpty else { return }
        store.addTask(PomodoroTask(title: newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)))
        newTaskTitle = ""
    }

    func deleteTask(_ task: PomodoroTask) {
        store.deleteTask(task)
    }

    func toggleComplete(_ task: PomodoroTask) {
        var updated = task
        updated.isCompleted.toggle()
        store.updateTask(updated)
    }

    func incrementPomodoro(_ task: PomodoroTask) {
        var updated = task
        updated.completedPomodoros += 1
        store.updateTask(updated)
    }

    func toggleSelection(for task: PomodoroTask, timerViewModel: TimerViewModel) {
        if selectedTask?.id == task.id {
            selectedTask = nil
            timerViewModel.setTask(nil)
        } else {
            selectedTask = task
            timerViewModel.setTask(task.title)
        }
    }

    func clearSelection(timerViewModel: TimerViewModel) {
        selectedTask = nil
        timerViewModel.setTask(nil)
    }
}
