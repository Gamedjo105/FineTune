import Foundation

enum EQPreset: String, CaseIterable, Identifiable {
    case flat
    case bassBoost
    case trebleBoost
    case vocalClarity
    case podcast
    case bassCut

    var id: String { rawValue }

    var name: String {
        switch self {
        case .flat: return "Flat"
        case .bassBoost: return "Bass Boost"
        case .trebleBoost: return "Treble Boost"
        case .vocalClarity: return "Vocal Clarity"
        case .podcast: return "Podcast"
        case .bassCut: return "Bass Cut"
        }
    }

    // Bands: 31, 62, 125, 250, 500, 1k, 2k, 4k, 8k, 16k
    var settings: EQSettings {
        switch self {
        case .flat:
            return EQSettings(bandGains: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
        case .bassBoost:
            return EQSettings(bandGains: [6, 5, 4, 2, 0, 0, 0, 0, 0, 0])
        case .trebleBoost:
            return EQSettings(bandGains: [0, 0, 0, 0, 0, 0, 2, 4, 5, 6])
        case .vocalClarity:
            return EQSettings(bandGains: [-2, -1, 0, -2, 0, 2, 3, 2, 0, 0])
        case .podcast:
            return EQSettings(bandGains: [-4, -3, -1, 0, 0, 1, 3, 3, 1, 0])
        case .bassCut:
            return EQSettings(bandGains: [-6, -5, -4, -2, 0, 0, 0, 0, 0, 0])
        }
    }
}
