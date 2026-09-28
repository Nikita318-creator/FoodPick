import UIKit
import SnapKit

final class KitchenGameViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let currentLevel: Int
    
    private var requiredIngredients: [String] = []
    private var selectedIngredients: [String] = []
    private var timeRemaining: Int
    private var timer: Timer?

    // MARK: - UI Components
    private let topBarView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()

    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 28, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.progressTintColor = UIColor.systemGreen
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progress.layer.cornerRadius = 6
        progress.clipsToBounds = true
        return progress
    }()

    private let recipeCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 12
        return view
    }()

    private let recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ORDER RECIPE"
        label.font = .systemFont(ofSize: 12, weight: .black)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()

    private let recipeTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .darkText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // Используем UICollectionView для сетки ингредиентов (до 6-8 кнопок)
    private lazy var ingredientsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(IngredientCell.self, forCellWithReuseIdentifier: "IngredientCell")
        return cv
    }()

    private var availableOptions: [String] = []

    // MARK: - Init
    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.currentLevel = level
        // Сложность: с каждым уровнем времени меньше!
        self.timeRemaining = max(8, 20 - (level / 10))
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
        setupGameForLevel()
        startTimer()
    }

    private func setupBackground() {
        view.backgroundColor = restaurant.headerBackgroundColor // Цветовая гамма ресторана на весь экран
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(levelTitleLabel)
        
        view.addSubview(timerLabel)
        view.addSubview(progressBar)
        view.addSubview(recipeCardView)
        
        recipeCardView.addSubview(recipeTitleLabel)
        recipeCardView.addSubview(recipeTextLabel)
        
        view.addSubview(ingredientsCollectionView)

        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        levelTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(12)
        }

        recipeCardView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(120)
        }

        recipeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }

        recipeTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        ingredientsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recipeCardView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        levelTitleLabel.text = "\(restaurant.name) — Level \(currentLevel)"
    }

    // MARK: - Game Logic
    private func setupGameForLevel() {
        let allIngredients = ["🍕 Dough", "🧀 Cheese", "🥩 Sauce", "🍗 Wings", "🔥 Spice", "🍄 Mushrooms", "🧅 Onion", "🍅 Tomato"]
        
        // Чем выше уровень, тем больше ингредиентов требуется для блюда (от 3 до 5)
        let ingredientsCount = min(3 + (currentLevel / 25), 5)
        requiredIngredients = Array(allIngredients.shuffled().prefix(ingredientsCount))
        
        // На экране показываем нужные + сгенерированные случайные (всего 6 вариантов)
        var optionsSet = Set(requiredIngredients)
        while optionsSet.count < 6 {
            if let random = allIngredients.randomElement() {
                optionsSet.insert(random)
            }
        }
        availableOptions = Array(optionsSet).shuffled()

        recipeTextLabel.text = requiredIngredients.joined(separator: " + ")
        progressBar.setProgress(0, animated: false)
        ingredientsCollectionView.reloadData()
    }

    private func startTimer() {
        updateTimerLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.updateTimerLabel()

            if self.timeRemaining <= 0 {
                self.finishGame(success: false)
            }
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = "⏱️ 00:\(String(format: "%02d", max(0, timeRemaining)))"
    }

    private func handleIngredientSelection(_ ingredient: String) {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()

        if requiredIngredients.contains(ingredient) && !selectedIngredients.contains(ingredient) {
            selectedIngredients.append(ingredient)
            
            let progress = Float(selectedIngredients.count) / Float(requiredIngredients.count)
            progressBar.setProgress(progress, animated: true)

            if selectedIngredients.count >= requiredIngredients.count {
                finishGame(success: true)
            }
        } else {
            // Штраф за ошибку: минус 2 секунды!
            timeRemaining = max(0, timeRemaining - 2)
            updateTimerLabel()
            
            let errorFeedback = UINotificationFeedbackGenerator()
            errorFeedback.notificationOccurred(.error)
        }
    }

    private func finishGame(success: Bool) {
        timer?.invalidate()

        if success {
            // Сохраняем прогресс уровня в UserDefaults
            LevelManager.shared.completeLevel(currentLevel, for: restaurant.id)
            KitchenManager.shared.addCoins(restaurant.baseReward * currentLevel)

            let alert = UIAlertController(title: "Level \(currentLevel) Cleared! 🎉", message: "Great job chef! Next level unlocked.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Time's Up! ⏳", message: "Customer left unhappy. Try level \(currentLevel) again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                self?.selectedIngredients.removeAll()
                self?.timeRemaining = max(8, 20 - ((self?.currentLevel ?? 1) / 10))
                self?.setupGameForLevel()
                self?.startTimer()
            }))
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        }
    }

    @objc private func handleBack() {
        timer?.invalidate()
        dismiss(animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension KitchenGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableOptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
        let item = availableOptions[indexPath.item]
        let isSelected = selectedIngredients.contains(item)
        cell.configure(title: item, isSelected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = availableOptions[indexPath.item]
        handleIngredientSelection(selected)
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 12) / 2
        return CGSize(width: width, height: 60)
    }
}

// MARK: - IngredientCell
final class IngredientCell: UICollectionViewCell {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        contentView.layer.cornerRadius = 14
        
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .darkText
        titleLabel.textAlignment = .center
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        contentView.alpha = isSelected ? 0.3 : 1.0
        isUserInteractionEnabled = !isSelected
    }
}
