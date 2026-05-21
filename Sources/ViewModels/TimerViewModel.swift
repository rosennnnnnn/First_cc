import Foundation
import Combine
import SwiftUI

enum TimerState {
    case idle
    case running
    case paused
    case finished
}

enum TimerPhase: String {
    case focus
    case shortBreak
    case longBreak
}

extension TimerPhase {
    var title: String {
        switch self {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }

    var color: Color {
        switch self {
        case .focus: return .orange
        case .shortBreak: return .green
        case .longBreak: return .blue
        }
    }
}

final class TimerViewModel: ObservableObject {
    @Published var state: TimerState = .idle
    @Published var phase: TimerPhase = .focus
    @Published var remainingSeconds: Int = 1500
    @Published var totalSeconds: Int = 1500
    @Published var currentTaskTitle: String?
    @Published var completedPomodorosInSession: Int = 0

    @AppStorage("focusDuration") var focusDuration: Int = 25
    @AppStorage("shortBreakDuration") var shortBreakDuration: Int = 5
    @AppStorage("longBreakDuration") var longBreakDuration: Int = 15
    @AppStorage("longBreakInterval") var longBreakInterval: Int = 4

    private var timer: AnyCancellable?

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - Double(remainingSeconds) / Double(totalSeconds)
    }

    var timeDisplay: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var stateDisplay: String {
        switch state {
        case .running: return "Running"
        case .paused: return "Paused"
        default: return "Ready"
        }
    }

    var justFinishedPhase: TimerPhase? {
        if state == .finished {
            switch phase {
            case .focus: return .shortBreak
            case .shortBreak, .longBreak: return .focus
            }
        }
        return nil
    }

    func start() {
        if state == .idle || state == .finished {
            totalSeconds = remainingSeconds
        }
        state = .running
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func pause() {
        state = .paused
        timer?.cancel()
        timer = nil
    }

    func reset() {
        timer?.cancel()
        timer = nil
        state = .idle
        phase = .focus
        remainingSeconds = focusDuration * 60
        totalSeconds = remainingSeconds
    }

    func skip() {
        timer?.cancel()
        timer = nil
        finishPhase()
    }

    private func tick() {
        guard remainingSeconds > 0 else {
            timer?.cancel()
            timer = nil
            finishPhase()
            return
        }
        remainingSeconds -= 1
    }

    private func finishPhase() {
        state = .finished

        if phase == .focus {
            completedPomodorosInSession += 1
            phase = (completedPomodorosInSession % longBreakInterval == 0) ? .longBreak : .shortBreak
        } else {
            phase = .focus
        }

        remainingSeconds = duration(for: phase) * 60
        totalSeconds = remainingSeconds
    }

    func setTask(_ title: String?) {
        currentTaskTitle = title
    }

    func refreshDurations() {
        if state == .idle {
            remainingSeconds = duration(for: phase) * 60
            totalSeconds = remainingSeconds
        }
    }

    private func duration(for phase: TimerPhase) -> Int {
        switch phase {
        case .focus: return focusDuration
        case .shortBreak: return shortBreakDuration
        case .longBreak: return longBreakDuration
        }
    }
}
