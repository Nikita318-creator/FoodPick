import UIKit
import SnapKit

final class LevelsViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private var unlockedLevel: Int = 1

    // MARK: - UI Components
    private let topBarView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(LevelCell.self, forCellWithReuseIdentifier: LevelCell.reuseIdentifier)
        return cv
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProgress()
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = restaurant.headerBackgroundColor
        titleLabel.text = "\(restaurant.name) — Select Level"
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(titleLabel)
        view.addSubview(collectionView)

        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        backButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(32)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(40)
            make.trailing.lessThanOrEqualTo(backButton.snp.leading).offset(-8)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func loadProgress() {
        unlockedLevel = LevelManager.shared.getUnlockedLevel(for: restaurant.id)
        collectionView.reloadData()
    }

    // MARK: - Actions
    @objc private func handleBack() {
        dismiss(animated: true)
    }

    private func startLevel(_ level: Int) {
        let gameViewController: UIViewController
        
        switch restaurant.id {
        case "1": // Wing Snob
            gameViewController = KitchenGameViewController(restaurant: restaurant, level: level)
            
        case "2": // Anthony's Coal Fired Pizza
            gameViewController = AnthonysGameViewController(restaurant: restaurant, level: level)
            
        case "3": // Dewey's Pizza
            gameViewController = DeweysGameViewController(restaurant: restaurant, level: level)
            
        case "4": // Dion's
            gameViewController = DionsGameViewController(restaurant: restaurant, level: level)
            
        case "5": // Marco's Pizza
            gameViewController = MarcosGameViewController(restaurant: restaurant, level: level)
            
        case "6": // Dave's Hot Chicken
            gameViewController = DavesGameViewController(restaurant: restaurant, level: level)
            
        case "7": // Jet's Pizza
            gameViewController = JetsGameViewController(restaurant: restaurant, level: level)
            
        case "8": // Giordano's
            gameViewController = GiordanosGameViewController(restaurant: restaurant, level: level)
            
        default:
            gameViewController = KitchenGameViewController(restaurant: restaurant, level: level)
        }

        gameViewController.modalPresentationStyle = .fullScreen
        present(gameViewController, animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension LevelsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100 // 100 уровней
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LevelCell.reuseIdentifier, for: indexPath) as? LevelCell else {
            return UICollectionViewCell()
        }

        let levelNumber = indexPath.item + 1
        let isUnlocked = levelNumber <= unlockedLevel
        cell.configure(level: levelNumber, isUnlocked: isUnlocked, themeColor: restaurant.headerBackgroundColor)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let levelNumber = indexPath.item + 1
        guard levelNumber <= unlockedLevel else {
            // Виброотклик при попытке нажать на заблокированный уровень
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            return
        }

        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()

        startLevel(levelNumber)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Вычисляем ширину для 4 колонок
        let padding: CGFloat = 20 * 2
        let spacing: CGFloat = 12 * 3
        let availableWidth = collectionView.bounds.width - padding - spacing
        let itemWidth = max(60, availableWidth / 4)
        return CGSize(width: itemWidth, height: itemWidth) // Квадратные ячейки
    }
}
