import Foundation

final class KitchenManager {
    static let shared = KitchenManager()
    
    private enum Keys {
        static let userCoins = "kitchen_user_coins"
        static let completedOrders = "kitchen_completed_orders"
    }
    
    private(set) var coins: Int {
        get { UserDefaults.standard.integer(forKey: Keys.userCoins) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.userCoins) }
    }
    
    private(set) var completedOrdersCount: Int {
        get { UserDefaults.standard.integer(forKey: Keys.completedOrders) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.completedOrders) }
    }
    
    private init() {}
    
    func addCoins(_ amount: Int) {
        coins += amount
        completedOrdersCount += 1
    }
}
