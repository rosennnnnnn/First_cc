// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pomodoro",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "Pomodoro", targets: ["Pomodoro"])
    ],
    targets: [
        .executableTarget(
            name: "Pomodoro",
            path: "Sources"
        )
    ]
)
