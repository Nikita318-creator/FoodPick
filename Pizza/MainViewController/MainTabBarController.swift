import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupTabs()
        setupAppearance()
    }

    private func makeNav(_ root: UIViewController, title: String, symbol: String, tag: Int) -> UINavigationController {
        root.title = title
        let nav = UINavigationController(rootViewController: root)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: symbol), tag: tag)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.tintColor = Theme.ink

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Theme.background
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [
            .foregroundColor: Theme.ink,
            .font: UIFont.systemFont(ofSize: 34, weight: .black)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: Theme.ink,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        return nav
    }

    private func setupTabs() {
        viewControllers = [
            makeNav(HomeViewController(),    title: "Home",    symbol: "house.fill",            tag: 0),
            makeNav(TestsViewController(),   title: "Tests",   symbol: "checkmark.seal.fill",   tag: 1),
            makeNav(ProfileViewController(), title: "Profile", symbol: "person.crop.circle",    tag: 2)
        ]
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = UIColor.systemGray5

        for item in [appearance.stackedLayoutAppearance, appearance.inlineLayoutAppearance, appearance.compactInlineLayoutAppearance] {
            item.selected.iconColor = Theme.ink
            item.selected.titleTextAttributes = [.foregroundColor: Theme.ink]
            item.normal.iconColor = .systemGray2
            item.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray2]
        }

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = Theme.ink
        tabBar.unselectedItemTintColor = .systemGray2
    }
}
