import AppKit
import AVFoundation

@MainActor
final class SoundService {
    static let shared = SoundService()

    private var player: AVAudioPlayer?

    private init() {
        if let url = Bundle.main.url(forResource: "complete", withExtension: "aiff") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        }
    }

    func playCompletion() {
        guard let player = player else {
            NSSound.beep()
            return
        }
        player.currentTime = 0
        player.play()
    }
}
