import UIKit
import SnapKit

final class MainViewController: UIViewController {

    // MARK: - UI Components
    private let headerView = UIView()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "🛵 FoodPick"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return label
    }()
    
    private let statsBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.00, green: 0.78, blue: 0.23, alpha: 0.3)
        view.layer.cornerRadius = 14
        return view
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return label
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What are you\ncraving tonight?"
        label.font = .systemFont(ofSize: 34, weight: .black)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.numberOfLines = 2
        return label
    }()
    
    private let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
        return view
    }()
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search deep dish, hot chicken, wings..."
        textField.font = .systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleSearchTextChange), for: .editingChanged)
        return textField
    }()

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        cv.register(RestaurantCardCell.self, forCellWithReuseIdentifier: RestaurantCardCell.reuseIdentifier)
        cv.register(UpcomingRestaurantCardCell.self, forCellWithReuseIdentifier: UpcomingRestaurantCardCell.reuseIdentifier)
        return cv
    }()

    // MARK: - State
    private var selectedCategory: RestaurantCategory = .all
    private var allRestaurants: [RestaurantModel] = []
    private var filteredRestaurants: [RestaurantModel] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLayout()
        setupKeyboardDismiss() // <--- Добавили скрытие клавиатуры
        loadInitialData()
        updateStats()
    }

    // Настраиваем делегат поля ввода и TapGesture:
    private func setupKeyboardDismiss() {
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Важно: чтобы не блокировать тапы по ячейкам!
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0)
    }

    private func setupLayout() {
        view.addSubview(headerView)
        headerView.addSubview(logoLabel)
        headerView.addSubview(statsBadge)
        statsBadge.addSubview(statsLabel)
        
        view.addSubview(mainTitleLabel)
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchIconImageView)
        searchContainerView.addSubview(searchTextField)
        view.addSubview(collectionView)

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(36)
        }

        logoLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        statsBadge.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.height.equalTo(28)
        }

        statsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }

        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        searchIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchIconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func updateStats() {
        let coins = KitchenManager.shared.coins
        statsLabel.text = "🪙 \(coins) Coins"
    }

    private func loadInitialData() {
        allRestaurants = [
            RestaurantModel(
                id: "1",
                name: "Wing Snob",
                category: "Wings",
                headerBackgroundColor: UIColor(red: 0.99, green: 0.80, blue: 0.28, alpha: 1.0),
                logoImageName: "wingsnob_logo",
                badgeText: "Hot Buffalo is back",
                descriptionText: "Traditional and boneless wings, tenders and loaded flavored fries",
                isAvailable: true,
                baseReward: 150
            ),
            RestaurantModel(
                id: "2",
                name: "Anthony's Coal Fired Pizza",
                category: "Pizza & wings",
                headerBackgroundColor: UIColor(red: 0.90, green: 0.80, blue: 0.95, alpha: 1.0),
                logoImageName: "anthonys_logo",
                badgeText: "20% off takeout Tuesdays",
                descriptionText: "Pizza baked at 900° in a coal-fired oven, with jumbo wings",
                isAvailable: true,
                baseReward: 200
            ),
            RestaurantModel(
                id: "3",
                name: "Dewey's Pizza",
                category: "Pizza",
                headerBackgroundColor: UIColor(red: 0.72, green: 0.78, blue: 0.96, alpha: 1.0),
                logoImageName: "deweys_logo",
                badgeText: "Seasonal: Tito Santana",
                descriptionText: "Craft pizzas, fresh salads and build-your-own calzones",
                isAvailable: true,
                baseReward: 180
            ),
            RestaurantModel(
                id: "4",
                name: "Dion's",
                category: "Pizza & subs",
                headerBackgroundColor: UIColor(red: 0.68, green: 0.85, blue: 0.70, alpha: 1.0),
                logoImageName: "dions_logo",
                badgeText: nil,
                descriptionText: "Hand-made pizza, subs and salads from Albuquerque",
                isAvailable: true,
                baseReward: 130
            ),
            RestaurantModel(
                id: "5",
                name: "Marco's Pizza",
                category: "Pizza",
                headerBackgroundColor: UIColor(red: 0.96, green: 0.74, blue: 0.72, alpha: 1.0),
                logoImageName: "marcos_logo",
                badgeText: "Online promo codes",
                descriptionText: "Italian-style pizza with a signature three-cheese blend",
                isAvailable: true,
                baseReward: 160
            ),
            RestaurantModel(
                id: "6",
                name: "Dave's Hot Chicken",
                category: "Chicken",
                headerBackgroundColor: UIColor(red: 0.98, green: 0.68, blue: 0.52, alpha: 1.0),
                logoImageName: "daves_logo",
                badgeText: "New Big Trio",
                descriptionText: "Nashville-style hot tenders and sliders, from no heat to reaper",
                isAvailable: true,
                baseReward: 220
            ),
            RestaurantModel(
                id: "7",
                name: "Jet's Pizza",
                category: "Pizza & wings",
                headerBackgroundColor: UIColor(red: 0.99, green: 0.85, blue: 0.62, alpha: 1.0),
                logoImageName: "jets_logo",
                badgeText: "New Cajun Ranch",
                descriptionText: "Detroit-style square pizza with crunchy corners, wings and salads",
                isAvailable: true,
                baseReward: 190
            ),
            RestaurantModel(
                id: "8",
                name: "Giordano's",
                category: "Pizza",
                headerBackgroundColor: UIColor(red: 0.75, green: 0.86, blue: 0.72, alpha: 1.0),
                logoImageName: "giordanos_logo",
                badgeText: "New Italian Combo",
                descriptionText: "Chicago stuffed deep dish since 1974, plus thin crust and tavern-style",
                isAvailable: true,
                baseReward: 250
            )
        ]
        applyFilter()
    }

    private func applyFilter() {
        let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""

        filteredRestaurants = allRestaurants.filter { item in
            let matchesCategory: Bool
            switch selectedCategory {
            case .all:
                matchesCategory = true
            case .pizza:
                matchesCategory = item.category.lowercased().contains("pizza")
            case .wings:
                matchesCategory = item.category.lowercased().contains("wing") || item.category.lowercased().contains("chicken")
            }

            let matchesSearch = searchText.isEmpty || item.name.lowercased().contains(searchText) || item.descriptionText.lowercased().contains(searchText)
            return matchesCategory && matchesSearch
        }

        collectionView.reloadSections(IndexSet(integer: 1))
    }

    @objc private func handleSearchTextChange() {
        applyFilter()
    }

    // MARK: - Layout Creation
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(90))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(300), heightDimension: .absolute(90))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 16, trailing: 20)
                section.interGroupSpacing = 12
                return section
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(330))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(330))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 20, trailing: 14)
                return section
            }
        }
    }
    
    // MARK: - Actions
    private func presentKitchenGame(for restaurant: RestaurantModel) {
        let levelsVC = LevelsViewController(restaurant: restaurant)
        levelsVC.modalPresentationStyle = .fullScreen
        present(levelsVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return RestaurantCategory.allCases.count
        } else {
            return filteredRestaurants.count + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            let category = RestaurantCategory.allCases[indexPath.item]
            cell.configure(category: category, isSelectedCategory: category == selectedCategory)
            return cell
        } else {
            if indexPath.item < filteredRestaurants.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCardCell.reuseIdentifier, for: indexPath) as? RestaurantCardCell else {
                    return UICollectionViewCell()
                }
                let model = filteredRestaurants[indexPath.item]
                cell.configure(with: model)
                cell.onOrderTap = { [weak self] in
                    self?.presentKitchenGame(for: model)
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingRestaurantCardCell.reuseIdentifier, for: indexPath) as? UpcomingRestaurantCardCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedCategory = RestaurantCategory.allCases[indexPath.item]
            collectionView.reloadSections(IndexSet(integer: 0))
            applyFilter()
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
