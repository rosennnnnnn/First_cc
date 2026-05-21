import SwiftUI

struct SettingsView: View {
    @ObservedObject var timerViewModel: TimerViewModel
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            DurationSlider(
                label: "Focus Duration (minutes)",
                value: Binding(
                    get: { Double(timerViewModel.focusDuration) },
                    set: {
                        timerViewModel.focusDuration = Int($0)
                        timerViewModel.refreshDurations()
                    }
                ),
                range: 5...60,
                step: 5
            )

            DurationSlider(
                label: "Short Break (minutes)",
                value: Binding(
                    get: { Double(timerViewModel.shortBreakDuration) },
                    set: {
                        timerViewModel.shortBreakDuration = Int($0)
                        timerViewModel.refreshDurations()
                    }
                ),
                range: 1...15,
                step: 1
            )

            DurationSlider(
                label: "Long Break (minutes)",
                value: Binding(
                    get: { Double(timerViewModel.longBreakDuration) },
                    set: {
                        timerViewModel.longBreakDuration = Int($0)
                        timerViewModel.refreshDurations()
                    }
                ),
                range: 10...30,
                step: 5
            )

            DurationSlider(
                label: "Long Break Interval: \(timerViewModel.longBreakInterval) pomodoros",
                value: Binding(
                    get: { Double(timerViewModel.longBreakInterval) },
                    set: { timerViewModel.longBreakInterval = Int($0) }
                ),
                range: 2...6,
                step: 1
            )

            Divider()
                .padding(.horizontal, 16)

            Toggle(isOn: $soundEnabled) {
                Text("Play sound on completion")
                    .font(.subheadline)
            }
            .padding(.horizontal, 16)

            Spacer()
        }
    }
}

private struct DurationSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)

            HStack {
                Slider(value: $value, in: range, step: step)
                Text("\(Int(value))")
                    .frame(width: 36, alignment: .trailing)
                    .monospacedDigit()
            }
        }
        .padding(.horizontal, 16)
    }
}
