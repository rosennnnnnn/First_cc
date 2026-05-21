import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    @ObservedObject var timerViewModel: TimerViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Tasks")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.activeTaskCount) active")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            HStack(spacing: 8) {
                TextField("New task...", text: $viewModel.newTaskTitle)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { viewModel.addTask() }

                Button(action: { viewModel.addTask() }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isNewTaskTitleEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            Divider()

            if viewModel.tasks.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checklist")
                        .font(.largeTitle)
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("No tasks yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.tasks) { task in
                        TaskRowView(
                            task: task,
                            isSelected: viewModel.selectedTask?.id == task.id,
                            onTap: {
                                viewModel.toggleSelection(for: task, timerViewModel: timerViewModel)
                            },
                            onToggleComplete: { viewModel.toggleComplete(task) },
                            onDelete: {
                                viewModel.clearSelection(timerViewModel: timerViewModel)
                                viewModel.deleteTask(task)
                            }
                        )
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
