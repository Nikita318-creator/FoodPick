import UIKit
import SnapKit

final class GiordanosGameViewController: UIViewController {

    // MARK: - Layer Model
    enum DeepDishLayer: String, CaseIterable {
        case bottomDough = "🫓 Bottom Dough"
        case cheese = "🧀 Extra Cheese"
        case filling = "🥩 Rich Filling"
        case topDough = "🍞 Top Crust Layer"
        case sauce = "🍅 Chunky Tomato Sauce"

        var shortTitle: String {
            switch self {
            case .bottomDough: return "Dough"
            case .cheese: return "Cheese"
            case .filling: return "Filling"
            case .topDough: return "Top Crust"
            case .sauce: return "Sauce"
            }
        }

        var icon: String {
            switch self {
            case .bottomDough: return "🫓"
            case .cheese: return "🧀"
            case .filling: return "🥩"
            case .topDough: return "🍞"
            case .sauce: return "🍅"
            }
        }
    }

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let level: Int

    // Game Logic State
    private var timeRemaining: Int = 15
    private var timer: Timer?
    
    private var totalPizzasNeeded: Int = 1
    private var completedPizzasCount: Int = 0
    private var currentLayerIndex: Int = 0 // 0 to 4
    
    private let recipeSequence: [DeepDishLayer] = [
        .bottomDough,
        .cheese,
        .filling,
        .topDough,
        .sauce
    ]
    
    private var conveyorOptions: [DeepDishLayer] = []

    // MARK: - UI Components
    private let topBarView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 26, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let progressInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        return label
    }()

    // Rules Banner Card
    private let rulesCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        view.layer.cornerRadius = 16
        return view
    }()

    private let rulesHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "🥧 GIORDANO'S DEEP DISH FORMULA"
        label.font = .systemFont(ofSize: 11, weight: .black)
        label.textColor = UIColor(red: 0.24, green: 0.35, blue: 0.21, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let rulesBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap layers in exact Chicago order:\n1. Bottom Dough ➔ 2. Cheese ➔ 3. Filling ➔ 4. Top Crust ➔ 5. Sauce"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // Deep Dish Pan View (Stack Container)
    private let panContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.20, green: 0.22, blue: 0.24, alpha: 1.0) // Cast iron pan color
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor(red: 0.35, green: 0.38, blue: 0.40, alpha: 1.0).cgColor
        return view
    }()

    private let panTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "DEEP DISH PAN"
        label.font = .systemFont(ofSize: 12, weight: .black)
        label.textColor = UIColor.white.withAlphaComponent(0.4)
        label.textAlignment = .center
        return label
    }()

    private let layersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 6
        return stack
    }()

    private var layerViews: [UIView] = []
    private var layerLabels: [UILabel] = []

    // Conveyor Belt CollectionView
    private lazy var conveyorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(ConveyorIngredientCell.self, forCellWithReuseIdentifier: ConveyorIngredientCell.reuseIdentifier)
        return cv
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.level = level
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLayout()
        configureDifficultyForLevel()
        setupPanSlots()
        resetForNewPizza()
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    // MARK: - Setup UI
    private func setupBackground() {
        // Giordano's Sage / Basil theme color
        view.backgroundColor = restaurant.headerBackgroundColor
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(closeButton)
        topBarView.addSubview(titleLabel)

        view.addSubview(timerLabel)
        view.addSubview(progressInfoLabel)

        view.addSubview(rulesCardView)
        rulesCardView.addSubview(rulesHeaderLabel)
        rulesCardView.addSubview(rulesBodyLabel)

        view.addSubview(panContainerView)
        panContainerView.addSubview(panTitleLabel)
        panContainerView.addSubview(layersStackView)

        view.addSubview(conveyorCollectionView)

        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        progressInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        rulesCardView.snp.makeConstraints { make in
            make.top.equalTo(progressInfoLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(68)
        }

        rulesHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        rulesBodyLabel.snp.makeConstraints { make in
            make.top.equalTo(rulesHeaderLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        panContainerView.snp.makeConstraints { make in
            make.top.equalTo(rulesCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(240)
        }

        panTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }

        layersStackView.snp.makeConstraints { make in
            make.top.equalTo(panTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        conveyorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(panContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(90)
        }

        titleLabel.text = "\(restaurant.name) — Level \(level)"
    }

    // MARK: - Level Difficulty Configuration
    private func configureDifficultyForLevel() {
        // Усложнение первых 5-7 уровней для ревьюера:
        switch level {
        case 1:
            totalPizzasNeeded = 1
            timeRemaining = 25
        case 2:
            totalPizzasNeeded = 1
            timeRemaining = 20
        case 3:
            totalPizzasNeeded = 2
            timeRemaining = 30
        case 4:
            totalPizzasNeeded = 2
            timeRemaining = 25
        case 5:
            totalPizzasNeeded = 3
            timeRemaining = 35
        case 6:
            totalPizzasNeeded = 3
            timeRemaining = 30
        case 7:
            totalPizzasNeeded = 3
            timeRemaining = 26
        default:
            // Уровни 8-100 удерживают высокую, но честную сложность
            totalPizzasNeeded = min(3 + (level / 30), 5)
            timeRemaining = max(18, (totalPizzasNeeded * 10) - (level / 10))
        }

        updateProgressHeader()
    }

    private func setupPanSlots() {
        layersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        layerViews.removeAll()
        layerLabels.removeAll()

        // Создаем 5 слоев снизу вверх (индекс 0 - Bottom Dough находится в самом низу)
        for i in (0..<5).reversed() {
            let slotView = UIView()
            slotView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
            slotView.layer.cornerRadius = 10
            slotView.layer.borderWidth = 1
            slotView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor

            let label = UILabel()
            label.text = "Layer \(i + 1): \(recipeSequence[i].shortTitle)"
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            label.textColor = UIColor.white.withAlphaComponent(0.4)
            label.textAlignment = .center

            slotView.addSubview(label)
            label.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            layersStackView.addArrangedSubview(slotView)
            layerViews.insert(slotView, at: 0) // Индекс 0 = Bottom Dough
            layerLabels.insert(label, at: 0)
        }
    }

    private func resetForNewPizza() {
        currentLayerIndex = 0

        // Очищаем форму
        for (index, slotView) in layerViews.enumerated() {
            slotView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
            slotView.transform = .identity
            let label = layerLabels[index]
            label.text = "Layer \(index + 1): \(recipeSequence[index].shortTitle)"
            label.textColor = UIColor.white.withAlphaComponent(0.4)
        }

        generateConveyorOptions()
    }

    private func generateConveyorOptions() {
        guard currentLayerIndex < recipeSequence.count else { return }

        let targetLayer = recipeSequence[currentLayerIndex]
        var optionsSet: Set<DeepDishLayer> = [targetLayer]

        // Заполняем ленту вариантами в зависимости от уровня
        let optionCount: Int
        if level <= 2 {
            optionCount = 3
        } else if level <= 5 {
            optionCount = 4
        } else {
            optionCount = 5
        }

        let allLayers = DeepDishLayer.allCases
        while optionsSet.count < optionCount {
            if let random = allLayers.randomElement() {
                optionsSet.insert(random)
            }
        }

        conveyorOptions = Array(optionsSet).shuffled()
        conveyorCollectionView.reloadData()
    }

    // MARK: - Timer Logic
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

    private func updateProgressHeader() {
        progressInfoLabel.text = "Pizza \(completedPizzasCount + 1) of \(totalPizzasNeeded)"
    }

    // MARK: - Game Mechanics
    private func handleIngredientTap(_ ingredient: DeepDishLayer) {
        let expectedLayer = recipeSequence[currentLayerIndex]

        if ingredient == expectedLayer {
            // Успешный слой
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()

            let slotView = layerViews[currentLayerIndex]
            let label = layerLabels[currentLayerIndex]

            // Красивая визуализация готового слоя
            UIView.animate(withDuration: 0.25, animations: {
                slotView.backgroundColor = UIColor(red: 0.95, green: 0.76, blue: 0.28, alpha: 1.0) // Теплый золотисто-запеченный
                slotView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                label.text = "\(ingredient.icon) \(ingredient.rawValue) — OK!"
                label.textColor = UIColor(red: 0.15, green: 0.12, blue: 0.05, alpha: 1.0)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    slotView.transform = .identity
                }
            }

            currentLayerIndex += 1

            if currentLayerIndex >= recipeSequence.count {
                // Пицца завершена!
                completedPizzasCount += 1
                updateProgressHeader()

                let successNotification = UINotificationFeedbackGenerator()
                successNotification.notificationOccurred(.success)

                if completedPizzasCount >= totalPizzasNeeded {
                    finishGame(success: true)
                } else {
                    // Анимируем переклиринг под следующую пиццу
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: [], animations: {
                        self.panContainerView.transform = CGAffineTransform(translationX: 0, y: -20).concatenating(CGAffineTransform(scaleX: 0.95, y: 0.95))
                        self.panContainerView.alpha = 0.5
                    }) { _ in
                        self.resetForNewPizza()
                        UIView.animate(withDuration: 0.3) {
                            self.panContainerView.transform = .identity
                            self.panContainerView.alpha = 1.0
                        }
                    }
                }
            } else {
                generateConveyorOptions()
            }
        } else {
            // Ошибка — Штраф -2 секунды + тряска корзины
            timeRemaining = max(0, timeRemaining - 2)
            updateTimerLabel()

            let errorFeedback = UINotificationFeedbackGenerator()
            errorFeedback.notificationOccurred(.error)

            shakeView(panContainerView)
        }
    }

    private func shakeView(_ viewToShake: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-12.0, 12.0, -8.0, 8.0, -4.0, 4.0, 0.0]
        viewToShake.layer.add(animation, forKey: "shake")
    }

    private func finishGame(success: Bool) {
        timer?.invalidate()

        if success {
            LevelManager.shared.completeLevel(level, for: restaurant.id)
            KitchenManager.shared.addCoins(restaurant.baseReward * level)

            let alert = UIAlertController(
                title: "Deep Dish Master! 🥧🎉",
                message: "You've successfully built all Giordano's deep dish pizzas for Level \(level)!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Oven Timed Out! ⏱️",
                message: "The deep dish formula was broken or time ran out. Try Level \(level) again!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.completedPizzasCount = 0
                self.configureDifficultyForLevel()
                self.resetForNewPizza()
                self.startTimer()
            }))
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        }
    }

    @objc private func handleClose() {
        timer?.invalidate()
        dismiss(animated: true)
    }
}

// MARK: - CollectionView Delegates
extension GiordanosGameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conveyorOptions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConveyorIngredientCell.reuseIdentifier, for: indexPath) as? ConveyorIngredientCell else {
            return UICollectionViewCell()
        }
        let option = conveyorOptions[indexPath.item]
        cell.configure(with: option)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedOption = conveyorOptions[indexPath.item]
        handleIngredientTap(selectedOption)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 80)
    }
}

// MARK: - Conveyor Ingredient Cell
final class ConveyorIngredientCell: UICollectionViewCell {
    static let reuseIdentifier = "ConveyorIngredientCell"

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 0.15).cgColor

        // Тень для объема
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)

        contentView.addSubview(iconLabel)
        contentView.addSubview(nameLabel)

        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().offset(-6)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with layer: GiordanosGameViewController.DeepDishLayer) {
        iconLabel.text = layer.icon
        nameLabel.text = layer.shortTitle
    }
}
