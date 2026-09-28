import UIKit

struct OriginSlide {
    let title: String
    let subtitle: String
    let storyText: String
    let imageName: String // Имя картинки или системного иконки для слайда
    let menuHighlight: String? // Выделенный пункт меню
}

struct RestaurantOrigin {
    let restaurantId: String
    let restaurantName: String
    let themeColor: UIColor
    let tagline: String
    let slides: [OriginSlide]
}
