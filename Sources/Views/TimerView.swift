import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.phase.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(viewModel.phase.color)

            if let task = viewModel.currentTaskTitle {
                Text(task)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            ZStack {
                Circle()
                    .stroke(lineWidth: 12)
                    .opacity(0.15)
                    .foregroundColor(viewModel.phase.color)

                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .foregroundColor(viewModel.phase.color)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text(viewModel.timeDisplay)
                        .font(.system(size: 52, weight: .light, design: .monospaced))
                        .foregroundColor(.primary)

                    Text(viewModel.stateDisplay)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 240, height: 240)

            HStack(spacing: 20) {
                if viewModel.state == .idle || viewModel.state == .finished {
                    Button(action: { viewModel.start() }) {
                        Label("Start", systemImage: "play.fill")
                            .font(.title3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                }

                if viewModel.state == .running {
                    Button(action: { viewModel.pause() }) {
                        Label("Pause", systemImage: "pause.fill")
                            .font(.title3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                }

                if viewModel.state == .paused {
                    Button(action: { viewModel.start() }) {
                        Label("Resume", systemImage: "play.fill")
                            .font(.title3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                }

                if viewModel.state != .idle {
                    Button(action: { viewModel.reset() }) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.title3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                }

                if viewModel.state == .running || viewModel.state == .paused {
                    Button(action: { viewModel.skip() }) {
                        Label("Skip", systemImage: "forward.end.fill")
                            .font(.title3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding(32)
    }
}
