import Foundation

final class LevelManager {
    static let shared = LevelManager()
    private let defaults = UserDefaults.standard
    
    private func key(for restaurantId: String) -> String {
        return "completed_level_restaurant_\(restaurantId)"
    }
    
    /// Возвращает номер максимального доступного уровня (1...100)
    func getUnlockedLevel(for restaurantId: String) -> Int {
        let saved = defaults.integer(forKey: key(for: restaurantId))
        return saved == 0 ? 1 : saved // Уровень 1 всегда открыт по умолчанию
    }
    
    /// Сохраняем победу на уровне
    func completeLevel(_ level: Int, for restaurantId: String) {
        let currentUnlocked = getUnlockedLevel(for: restaurantId)
        if level >= currentUnlocked && level < 100 {
            defaults.set(level + 1, forKey: key(for: restaurantId))
        }
    }
}
