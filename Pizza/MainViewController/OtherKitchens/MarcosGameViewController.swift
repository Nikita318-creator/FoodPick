import UIKit
import SnapKit

final class MarcosGameViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let level: Int

    // Игровые данные
    private let allPossibleToppings: [String] = [
        "🧀 Cheddar", "🧀 Mozzarella", "🧀 Parmesan",
        "🍕 Pepperoni", "🍄 Mushroom", "🧅 Onion",
        "🫑 Pepper", "🥓 Bacon", "🫒 Olives", "🍅 Tomato"
    ]

    private var targetRecipe: [String] = []
    private var selectedToppings: [String] = []
    private var availableOptions: [String] = []

    private var recallTimeRemaining: Int = 10
    private var memorizeTimer: Timer?
    private var recallTimer: Timer?

    private enum GamePhase {
        case memorizing
        case recalling
        case finished
    }
    private var currentPhase: GamePhase = .memorizing

    // MARK: - UI Components
    private let topBarView = UIView()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Marco's Pizza"
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let levelBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0.85, green: 0.25, blue: 0.20, alpha: 1.0) // Marco's Red
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    private let statusCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
        return view
    }()

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 16, weight: .heavy)
        label.textColor = UIColor(red: 0.85, green: 0.25, blue: 0.20, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    // Карточка Пиззы / Заказа
    private let pizzaContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.99, green: 0.94, blue: 0.86, alpha: 1.0)
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
        return view
    }()

    private let pizzaCoverOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.20, green: 0.18, blue: 0.24, alpha: 0.95)
        view.layer.cornerRadius = 22
        view.alpha = 0.0 // Скрыта в фазе запоминания
        return view
    }()

    private let pizzaCoverIcon: UILabel = {
        let label = UILabel()
        label.text = "📦\nSecret Recipe Covered!"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let recipeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()

    // Сетка для выбора вариантов
    private lazy var toppingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(ToppingSelectionCell.self, forCellWithReuseIdentifier: ToppingSelectionCell.reuseIdentifier)
        return cv
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.level = level
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
        configureLevelDifficulty()
        startMemorizePhase()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateTimers()
    }

    // MARK: - Setup UI
    private func setupBackground() {
        // Мягкий тепло-персиковый фон
        view.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.92, alpha: 1.0)
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(titleLabel)
        topBarView.addSubview(levelBadgeLabel)

        view.addSubview(statusCardView)
        statusCardView.addSubview(instructionLabel)
        statusCardView.addSubview(timerLabel)

        view.addSubview(pizzaContainerView)
        pizzaContainerView.addSubview(recipeStackView)
        pizzaContainerView.addSubview(pizzaCoverOverlay)
        pizzaCoverOverlay.addSubview(pizzaCoverIcon)

        view.addSubview(toppingsCollectionView)

        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        levelBadgeLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(72)
            make.height.equalTo(26)
        }

        statusCardView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(64)
        }

        instructionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }

        pizzaContainerView.snp.makeConstraints { make in
            make.top.equalTo(statusCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }

        recipeStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }

        pizzaCoverOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        pizzaCoverIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        toppingsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pizzaContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
        }

        levelBadgeLabel.text = "LVL \(level)"
    }

    // MARK: - Difficulty Scaling Logic
    private func configureLevelDifficulty() {
        // 1. Сколько всего ингридиентов в рецепте (от 2 до 6)
        let recipeCount = min(2 + (level / 20), 6)
        targetRecipe = Array(allPossibleToppings.shuffled().prefix(recipeCount))

        // 2. Сколько вариантов ответа показать в сетке (4, 6 или 8)
        let totalOptionsCount: Int
        if level <= 10 {
            totalOptionsCount = 4
        } else if level <= 30 {
            totalOptionsCount = 6
        } else {
            totalOptionsCount = 8
        }

        var optionsSet = Set(targetRecipe)
        while optionsSet.count < totalOptionsCount {
            if let random = allPossibleToppings.randomElement() {
                optionsSet.insert(random)
            }
        }
        availableOptions = Array(optionsSet).shuffled()

        // 3. Расчет времени на запоминание (от 4.0 сек до 1.5 сек)
        // 4. Расчет времени на выбор (от 15 сек до 6 сек)
        recallTimeRemaining = max(6, 16 - (level / 10))

        renderTargetRecipeUI()
    }

    private func renderTargetRecipeUI() {
        recipeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let titleText = UILabel()
        titleText.text = "🍕 CHEESE & TOPPING MIX"
        titleText.font = .systemFont(ofSize: 12, weight: .black)
        titleText.textColor = UIColor(red: 0.5, green: 0.4, blue: 0.3, alpha: 1.0)

        let ingredientsText = UILabel()
        ingredientsText.text = targetRecipe.joined(separator: "\n")
        ingredientsText.font = .systemFont(ofSize: 18, weight: .bold)
        ingredientsText.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        ingredientsText.textAlignment = .center
        ingredientsText.numberOfLines = 0

        recipeStackView.addArrangedSubview(titleText)
        recipeStackView.addArrangedSubview(ingredientsText)
    }

    // MARK: - Game Flow
    private func startMemorizePhase() {
        currentPhase = .memorizing
        instructionLabel.text = "🧠 Memorize Marco's Secret Recipe!"
        
        let memorizeDuration = max(1.5, 4.0 - (Double(level) * 0.025))
        var countdown = memorizeDuration

        timerLabel.text = String(format: "Closing box in %.1fs", countdown)

        memorizeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] t in
            guard let self = self else { return }
            countdown -= 0.1
            if countdown <= 0 {
                t.invalidate()
                self.startRecallPhase()
            } else {
                self.timerLabel.text = String(format: "Closing box in %.1fs", max(0, countdown))
            }
        }
    }

    private func startRecallPhase() {
        currentPhase = .recalling

        // Плавное закрытие коробки пиццы
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) {
            self.pizzaCoverOverlay.alpha = 1.0
        }

        instructionLabel.text = "👇 Recreate the recipe from memory!"
        updateRecallTimerLabel()

        // Включаем сетку кнопок
        toppingsCollectionView.reloadData()

        recallTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recallTimeRemaining -= 1
            self.updateRecallTimerLabel()

            if self.recallTimeRemaining <= 0 {
                self.finishGame(success: false, reason: "Time's up! The customer left.")
            }
        }
    }

    private func updateRecallTimerLabel() {
        timerLabel.text = "⏱️ Time left: \(max(0, recallTimeRemaining))s"
    }

    private func handleToppingTap(_ topping: String) {
        guard currentPhase == .recalling else { return }

        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()

        if targetRecipe.contains(topping) && !selectedToppings.contains(topping) {
            selectedToppings.append(topping)

            // Проверяем, собран ли полностью рецепт
            if selectedToppings.count == targetRecipe.count {
                finishGame(success: true, reason: "Perfect match! Marco is proud! 🍕")
            }
        } else {
            // Ошибка: штраф по времени или проигрыш на высоких уровнях
            let errorFeedback = UINotificationFeedbackGenerator()
            errorFeedback.notificationOccurred(.error)

            if level > 20 {
                finishGame(success: false, reason: "Wrong ingredient! Order ruined.")
            } else {
                recallTimeRemaining = max(0, recallTimeRemaining - 3)
                updateRecallTimerLabel()
                
                // Вспышка красным рамки статуса
                UIView.animate(withDuration: 0.15, animations: {
                    self.statusCardView.layer.borderColor = UIColor.systemRed.cgColor
                }) { _ in
                    UIView.animate(withDuration: 0.15) {
                        self.statusCardView.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
                    }
                }
            }
        }
    }

    private func finishGame(success: Bool, reason: String) {
        currentPhase = .finished
        invalidateTimers()

        // Открываем рецепт для проверки
        UIView.animate(withDuration: 0.3) {
            self.pizzaCoverOverlay.alpha = 0.0
        }

        if success {
            LevelManager.shared.completeLevel(level, for: restaurant.id)
            KitchenManager.shared.addCoins(restaurant.baseReward * level)

            let alert = UIAlertController(
                title: "Level \(level) Passed! 🎉",
                message: reason,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Next / Continue", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Order Failed! ❌",
                message: reason,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] _ in
                self?.restartGame()
            }))
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        }
    }

    private func restartGame() {
        selectedToppings.removeAll()
        pizzaCoverOverlay.alpha = 0.0
        configureLevelDifficulty()
        startMemorizePhase()
    }

    private func invalidateTimers() {
        memorizeTimer?.invalidate()
        memorizeTimer = nil
        recallTimer?.invalidate()
        recallTimer = nil
    }

    @objc private func handleBack() {
        invalidateTimers()
        dismiss(animated: true)
    }
}

// MARK: - CollectionView Delegate & DataSource
extension MarcosGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableOptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToppingSelectionCell.reuseIdentifier, for: indexPath) as? ToppingSelectionCell else {
            return UICollectionViewCell()
        }

        let topping = availableOptions[indexPath.item]
        let isSelected = selectedToppings.contains(topping)
        let isEnabled = (currentPhase == .recalling)

        cell.configure(toppingTitle: topping, isSelected: isSelected, isEnabled: isEnabled)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTopping = availableOptions[indexPath.item]
        handleToppingTap(selectedTopping)
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: 54)
    }
}

// MARK: - ToppingSelectionCell
final class ToppingSelectionCell: UICollectionViewCell {
    static let reuseIdentifier = "ToppingSelectionCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(toppingTitle: String, isSelected: Bool, isEnabled: Bool) {
        titleLabel.text = toppingTitle

        if isSelected {
            contentView.backgroundColor = UIColor(red: 0.85, green: 0.95, blue: 0.85, alpha: 1.0) // Светло-зеленый выбранный
            contentView.layer.borderColor = UIColor.systemGreen.cgColor
            contentView.alpha = 0.6
            isUserInteractionEnabled = false
        } else {
            contentView.backgroundColor = .white
            contentView.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
            contentView.alpha = isEnabled ? 1.0 : 0.5
            isUserInteractionEnabled = isEnabled
        }
    }
}
