import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Statistics")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            HStack(spacing: 0) {
                StatCard(title: "Today", value: "\(viewModel.todayCount)", unit: "pomos")
                Divider().frame(height: 40)
                StatCard(title: "This Week", value: "\(viewModel.weekCount)", unit: "pomos")
                Divider().frame(height: 40)
                StatCard(title: "Total", value: "\(viewModel.totalCount)", unit: "pomos")
            }
            .padding(.horizontal, 16)

            HStack(spacing: 0) {
                StatCard(title: "Today Focus", value: "\(viewModel.todayMinutes)", unit: "min")
            }
            .padding(.horizontal, 16)

            Divider()
                .padding(.horizontal, 16)

            Text("Recent Records")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)

            if viewModel.records.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar")
                        .font(.largeTitle)
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("No records yet. Complete a pomodoro to see stats!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                List {
                    ForEach(viewModel.records.prefix(50)) { record in
                        HStack {
                            Image(systemName: record.type == .focus ? "flame.fill" : "cup.and.saucer.fill")
                                .foregroundColor(record.type == .focus ? .orange : .green)
                                .font(.caption)

                            VStack(alignment: .leading) {
                                if let task = record.taskTitle {
                                    Text(task)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Text("\(record.duration / 60)m")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .monospacedDigit()
                        }
                        .padding(.vertical, 2)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .monospacedDigit()
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
