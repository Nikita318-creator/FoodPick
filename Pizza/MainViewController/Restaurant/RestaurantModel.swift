import UIKit

enum RestaurantCategory: String, CaseIterable {
    case all = "All"
    case pizza = "Pizza"
    case wings = "Chicken & Wings"
    
    var icon: String {
        switch self {
        case .all: return "🍽️"
        case .pizza: return "🍕"
        case .wings: return "🍗"
        }
    }
}

struct RestaurantModel {
    let id: String
    let name: String
    let category: String
    let headerBackgroundColor: UIColor
    let logoImageName: String
    let badgeText: String?
    let descriptionText: String
    let isAvailable: Bool
    let baseReward: Int
}
