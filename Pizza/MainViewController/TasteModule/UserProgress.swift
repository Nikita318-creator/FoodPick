import Foundation

import Foundation

struct QuizQuestion {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
}

struct QuizTopic: Hashable {
    let id: Int
    let title: String
    let subtitle: String
    let imageAsset: String
}

struct HomeSection {
    let title: String
    let topics: [QuizTopic]
}

struct QuizResult: Codable {
    let topicId: Int
    let topicTitle: String
    let correct: Int
    let total: Int
    let date: Date

    var percent: Int { total == 0 ? 0 : Int((Double(correct) / Double(total) * 100).rounded()) }
}

struct UserProgress {
    static let xpPerLevel = 150
    static let ranks = ["Rookie Taster", "Street Food Fan", "Flavor Hunter",
                        "Gourmet", "Master Gourmet", "Legendary Chef"]

    let xp: Int

    var level: Int { xp / Self.xpPerLevel + 1 }
    var xpIntoLevel: Int { xp % Self.xpPerLevel }
    var xpToNext: Int { Self.xpPerLevel - xpIntoLevel }
    var progress: Float { Float(xpIntoLevel) / Float(Self.xpPerLevel) }
    var rankTitle: String { Self.ranks[min(level - 1, Self.ranks.count - 1)] }
}

final class ResultsStore {
    static let shared = ResultsStore()
    private init() {}

    private let key = "quiz_results_v1"
    private let defaults = UserDefaults.standard

    var results: [QuizResult] {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([QuizResult].self, from: data) else { return [] }
        return decoded
    }

    func save(_ result: QuizResult) {
        var all = results
        all.append(result)
        if let data = try? JSONEncoder().encode(all) {
            defaults.set(data, forKey: key)
        }
    }

    // MARK: - Stats
    var quizzesCompleted: Int { results.count }
    var totalCorrect: Int { results.reduce(0) { $0 + $1.correct } }
    var totalQuestions: Int { results.reduce(0) { $0 + $1.total } }

    var accuracyPercent: Int {
        totalQuestions == 0 ? 0 : Int((Double(totalCorrect) / Double(totalQuestions) * 100).rounded())
    }

    var bestPercent: Int { results.map { $0.percent }.max() ?? 0 }

    var progress: UserProgress { UserProgress(xp: totalCorrect * 10) }
}
