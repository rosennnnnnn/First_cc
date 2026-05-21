import SwiftUI

@main
struct PomodoroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentMinSize)
        .defaultSize(width: 720, height: 520)
    }
}
