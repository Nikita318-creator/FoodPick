import UIKit
import SnapKit

final class DionsGameViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let level: Int

    // Ингредиенты с эмодзи
    private let ingredientEmojis = [
        "🥬 Lettuce", "🧀 Cheese", "🥩 Ham", "🍅 Tomato",
        "🥒 Cucumber", "🥓 Bacon", "🥑 Avocado", "🧅 Onion"
    ]

    // Настройки сложности
    private var requiredLayersCount: Int
    private var traySpeed: CGFloat
    private var targetIngredient: String = ""
    private var stackedIngredients: [String] = ["🥖 Bottom Bread"]

    // Состояние игры
    private var isDropping = false
    private var currentTrayDirection: CGFloat = 1.0 // 1 - вправо, -1 - влево
    private var displayLink: CADisplayLink?

    // MARK: - UI Components
    private let topBarView = UIView()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let instructionsCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 0.15).cgColor
        return view
    }()

    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = " Tap anywhere to drop the ingredient!\nBuild a balanced sub tower without dropping layers."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 0.8)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    // Контейнер под башню с ингредиентами
    private let gameAreaView = UIView()
    private let towerStackContainer = UIView()

    // Двигающийся поднос с верхним ингредиентом
    private let trayContainer = UIView()
    private let trayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        view.layer.cornerRadius = 6
        return view
    }()

    private let fallingIngredientLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.level = level

        // Динамическая сложность в зависимости от уровня
        self.requiredLayersCount = min(4 + (level / 8), 15) // От 4 до 15 слоев
        self.traySpeed = 2.5 + CGFloat(level) * 0.08         // Скорость раскачивания подноса

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
        setupTapGesture()
        startNewRound()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDisplayLink()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopDisplayLink()
    }

    // MARK: - Setup
    private func setupBackground() {
        // Фисташково-зеленоватый фон Dion's
        view.backgroundColor = UIColor(red: 0.94, green: 0.97, blue: 0.94, alpha: 1.0)
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(titleLabel)

        view.addSubview(instructionsCard)
        instructionsCard.addSubview(instructionsLabel)
        view.addSubview(progressLabel)

        view.addSubview(gameAreaView)
        gameAreaView.addSubview(towerStackContainer)
        gameAreaView.addSubview(trayContainer)

        trayContainer.addSubview(trayView)
        trayContainer.addSubview(fallingIngredientLabel)

        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        instructionsCard.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(46)
        }

        instructionsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }

        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionsCard.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        gameAreaView.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        // Поднос сверху
        trayContainer.frame = CGRect(x: 100, y: 20, width: 140, height: 60)

        trayView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(8)
        }

        fallingIngredientLabel.snp.makeConstraints { make in
            make.bottom.equalTo(trayView.snp.top).offset(-4)
            make.centerX.equalToSuperview()
        }

        // Низовой стек башни
        towerStackContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(180)
            make.height.equalTo(400)
        }

        titleLabel.text = "\(restaurant.name) — Level \(level)"
        renderInitialBread()
        updateProgress()
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapToDrop))
        gameAreaView.addGestureRecognizer(tap)
    }

    private func renderInitialBread() {
        towerStackContainer.subviews.forEach { $0.removeFromSuperview() }
        let breadLabel = createIngredientView(text: stackedIngredients.first!)
        towerStackContainer.addSubview(breadLabel)
        breadLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalTo(160)
        }
    }

    // MARK: - Game Loop (CADisplayLink)
    private func startDisplayLink() {
        stopDisplayLink()
        displayLink = CADisplayLink(target: self, selector: #selector(updateTrayPosition))
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func updateTrayPosition() {
        guard !isDropping else { return }

        var frame = trayContainer.frame
        frame.origin.x += traySpeed * currentTrayDirection

        let minX: CGFloat = 16
        let maxX: CGFloat = view.bounds.width - frame.width - 16

        if frame.origin.x >= maxX {
            frame.origin.x = maxX
            currentTrayDirection = -1.0
        } else if frame.origin.x <= minX {
            frame.origin.x = minX
            currentTrayDirection = 1.0
        }

        trayContainer.frame = frame
    }

    // MARK: - Game Logic
    private func startNewRound() {
        isDropping = false

        // Конец игры — завершающая булочка сверху!
        if stackedIngredients.count == requiredLayersCount - 1 {
            targetIngredient = "🥖 Top Bread"
        } else {
            targetIngredient = ingredientEmojis.randomElement() ?? "🧀 Cheese"
        }

        fallingIngredientLabel.text = targetIngredient
        trayContainer.alpha = 1.0
    }

    @objc private func handleTapToDrop() {
        guard !isDropping else { return }
        isDropping = true

        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()

        // Создаем падающий ингредиент на точке подноса
        let droppingLabel = createIngredientView(text: targetIngredient)
        let initialFrame = gameAreaView.convert(fallingIngredientLabel.bounds, from: fallingIngredientLabel)
        droppingLabel.frame = initialFrame
        gameAreaView.addSubview(droppingLabel)

        // Скрываем на подносе
        fallingIngredientLabel.text = ""

        // Вычисляем целевую Y координату на башне
        let currentStackHeight = CGFloat(stackedIngredients.count) * 32.0
        let targetY = gameAreaView.bounds.height - 40 - currentStackHeight - 32

        let trayCenterX = trayContainer.frame.midX
        let towerCenterX = gameAreaView.bounds.width / 2.0

        // Проверка на попадание (допуск по горизонтали)
        let tolerance: CGFloat = 55.0
        let isSuccess = abs(trayCenterX - towerCenterX) <= tolerance

        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseIn) {
            droppingLabel.frame.origin.y = targetY
            if !isSuccess {
                // Если промах — ингредиент сваливается в сторону
                droppingLabel.frame.origin.x += (trayCenterX > towerCenterX ? 80 : -80)
                droppingLabel.transform = CGAffineTransform(rotationAngle: .pi / 4)
                droppingLabel.alpha = 0.0
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            droppingLabel.removeFromSuperview()

            if isSuccess {
                self.handleSuccessfulDrop()
            } else {
                self.handleFailedDrop()
            }
        }
    }

    private func handleSuccessfulDrop() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        stackedIngredients.append(targetIngredient)
        updateProgress()

        // Добавляем постоянное вью в стек башни
        let newLayer = createIngredientView(text: targetIngredient)
        towerStackContainer.addSubview(newLayer)

        let bottomOffset = CGFloat(stackedIngredients.count - 1) * 32.0
        newLayer.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(bottomOffset)
            make.centerX.equalToSuperview()
            make.height.equalTo(34)
            make.width.equalTo(160)
        }

        // Анимация лёгкого пружинения башни
        newLayer.transform = CGAffineTransform(scaleX: 1.15, y: 0.85)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3) {
            newLayer.transform = .identity
        }

        // Плавно подправляем высоту контейнера башни, если она слишком высокая
        if stackedIngredients.count > 7 {
            UIView.animate(withDuration: 0.3) {
                self.towerStackContainer.transform = CGAffineTransform(translationX: 0, y: CGFloat(self.stackedIngredients.count - 7) * 20.0)
            }
        }

        if stackedIngredients.count >= requiredLayersCount {
            finishGame(success: true)
        } else {
            startNewRound()
        }
    }

    private func handleFailedDrop() {
        let errorFeedback = UINotificationFeedbackGenerator()
        errorFeedback.notificationOccurred(.error)

        let alert = UIAlertController(title: "Sub Toppled Over! 🥪💥", message: "Your sandwich lost balance. Try level \(level) again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.resetGame()
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }

    private func resetGame() {
        stackedIngredients = ["🥖 Bottom Bread"]
        towerStackContainer.transform = .identity
        renderInitialBread()
        updateProgress()
        startNewRound()
    }

    private func finishGame(success: Bool) {
        stopDisplayLink()

        // Сохраняем прогресс уровня
        LevelManager.shared.completeLevel(level, for: restaurant.id)
        KitchenManager.shared.addCoins(restaurant.baseReward * level)

        let alert = UIAlertController(title: "Delicious Sub Built! 🎉", message: "Masterpiece level \(level) cleared perfectly!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }

    private func updateProgress() {
        progressLabel.text = "LAYERS: \(stackedIngredients.count) / \(requiredLayersCount)"
    }

    private func createIngredientView(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.layer.borderWidth = 1.5
        container.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 0.8).cgColor

        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center

        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

        return container
    }

    @objc private func handleClose() {
        stopDisplayLink()
        dismiss(animated: true)
    }
}
