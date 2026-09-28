import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        // Вкладка 1: Главный экран с ресторанами и играми
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(
            title: "Restaurants",
            image: UIImage(systemName: "fork.knife"),
            tag: 0
        )

        // Вкладка 2: Истории происхождения и меню
        let originsVC = OriginsViewController()
        originsVC.tabBarItem = UITabBarItem(
            title: "Origins",
            image: UIImage(systemName: "book.fill"),
            tag: 1
        )

        viewControllers = [mainVC, originsVC]
    }

    private func setupAppearance() {
        tabBar.tintColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        tabBar.unselectedItemTintColor = .systemGray2
        tabBar.backgroundColor = .white
        
        // Верхняя граница таббара
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.systemGray5.cgColor
        tabBar.clipsToBounds = true
    }
}
