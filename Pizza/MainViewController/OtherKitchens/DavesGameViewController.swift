import UIKit
import SnapKit

final class DavesGameViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let currentLevel: Int
    
    // Game Physics & Difficulty
    private var currentHeat: Double = 0.0
    private var targetHeat: Double = 0.85
    private var coolDownRate: Double = 0.15 // Сколько остроты падает в секунду
    private var tapPower: Double = 0.08      // Сколько остроты добавляет 1 тап
    private var timeRemaining: Double = 15.0
    
    private var displayLink: CADisplayLink?
    private var lastUpdateTime: CFTimeInterval = 0
    private var isGameActive = false
    private var isBonusActive = false
    
    // Level difficulty presets for reviewers (Levels 1-7)
    private var spiceLevelTitle: String {
        switch currentLevel {
        case 1: return "Level 1: Lite Mild 🍗"
        case 2: return "Level 2: Mild Heat 🌶️"
        case 3: return "Level 3: Medium Spice 🔥"
        case 4: return "Level 4: Hot Chicken 🌶️🔥"
        case 5: return "Level 5: Extra Hot 💥"
        case 6: return "Level 6: Reaper Level 💀"
        default: return "Level \(currentLevel): Ultimate Reaper ☠️"
        }
    }

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

    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 26, weight: .black)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    // Инструкция и правила для пользователя
    private let instructionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
        return view
    }()

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // Шкала нагрева / остроты
    private let heatProgressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let heatProgressBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.35, blue: 0.20, alpha: 1.0)
        view.layer.cornerRadius = 12
        return view
    }()

    private let targetMarkerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return view
    }()

    private let targetMarkerLabel: UILabel = {
        let label = UILabel()
        label.text = "GOAL 🎯"
        label.font = .systemFont(ofSize: 10, weight: .black)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return label
    }()

    // Игровое поле: Курица + Огонь
    private let chickenContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()

    private let chickenLabel: UILabel = {
        let label = UILabel()
        label.text = "🍗"
        label.font = .systemFont(ofSize: 130)
        label.textAlignment = .center
        return label
    }()

    private let fireFlameLabel: UILabel = {
        let label = UILabel()
        label.text = "🔥"
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        label.alpha = 0.2
        return label
    }()

    private let bonusSpiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🌶️✨", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 44)
        button.isHidden = true
        return button
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChickenTap))
        return tap
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.currentLevel = level
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
        setupActions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopDisplayLink()
    }

    // MARK: - Setup
    private func setupBackground() {
        // Острый оранжево-коралловый фон ресторана
        view.backgroundColor = restaurant.headerBackgroundColor
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(levelTitleLabel)

        view.addSubview(timerLabel)
        view.addSubview(instructionCardView)
        instructionCardView.addSubview(instructionLabel)

        view.addSubview(heatProgressContainer)
        heatProgressContainer.addSubview(heatProgressBar)
        view.addSubview(targetMarkerLine)
        view.addSubview(targetMarkerLabel)

        view.addSubview(chickenContainerView)
        chickenContainerView.addSubview(fireFlameLabel)
        chickenContainerView.addSubview(chickenLabel)
        chickenContainerView.addSubview(bonusSpiceButton)

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
            make.top.equalTo(topBarView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        instructionCardView.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }

        instructionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        heatProgressContainer.snp.makeConstraints { make in
            make.top.equalTo(instructionCardView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(24)
        }

        heatProgressBar.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }

        targetMarkerLine.snp.makeConstraints { make in
            make.top.bottom.equalTo(heatProgressContainer).inset(-4)
            make.width.equalTo(3)
            make.leading.equalTo(heatProgressContainer.snp.leading) // Будет пересчитано
        }

        targetMarkerLabel.snp.makeConstraints { make in
            make.bottom.equalTo(targetMarkerLine.snp.top).offset(-2)
            make.centerX.equalTo(targetMarkerLine)
        }

        chickenContainerView.snp.makeConstraints { make in
            make.top.equalTo(heatProgressContainer.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }

        chickenLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        fireFlameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(chickenLabel.snp.top).offset(20)
        }

        bonusSpiceButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    private func setupActions() {
        chickenContainerView.addGestureRecognizer(tapGesture)
        bonusSpiceButton.addTarget(self, action: #selector(handleBonusTap), for: .touchUpInside)
    }

    // MARK: - Difficulty Tuning (Levels 1-100)
    private func configureDifficultyForLevel() {
        levelTitleLabel.text = spiceLevelTitle
        
        switch currentLevel {
        case 1:
            targetHeat = 0.60
            coolDownRate = 0.08  // Очень медленно падает
            tapPower = 0.12      // Всего ~5 тапов
            timeRemaining = 12.0
            instructionLabel.text = "Tap the chicken repeatedly to coat it in spice!\nReach the target heat line 🎯"
        case 2:
            targetHeat = 0.70
            coolDownRate = 0.12
            tapPower = 0.09
            timeRemaining = 12.0
            instructionLabel.text = "Keep tapping! Don't let the heat drop down 🔥"
        case 3:
            targetHeat = 0.78
            coolDownRate = 0.16
            tapPower = 0.075
            timeRemaining = 12.0
            instructionLabel.text = "Faster! Tap extra golden peppers 🌶️✨ for bonus heat!"
        case 4...5:
            targetHeat = 0.85
            coolDownRate = 0.22
            tapPower = 0.065
            timeRemaining = 10.0
            instructionLabel.text = "Warning: Heat drops rapidly! Keep the fire burning 🌶️🔥"
        case 6...7:
            targetHeat = 0.92
            coolDownRate = 0.28
            tapPower = 0.055
            timeRemaining = 10.0
            instructionLabel.text = "REAPER MODE 💀 Hold the heat at max until time expires!"
        default:
            // Плавный рост для уровней 8+
            targetHeat = min(0.95, 0.85 + Double(currentLevel) * 0.002)
            coolDownRate = min(0.40, 0.25 + Double(currentLevel) * 0.005)
            tapPower = max(0.04, 0.06 - Double(currentLevel) * 0.0003)
            timeRemaining = 10.0
            instructionLabel.text = "Ultimate Reaper Spice Level! Tap fast! ☠️"
        }

        updateTimerLabel()
        updateTargetMarkerPosition()
        
        // Стартовый запуск игры
        isGameActive = true
        startDisplayLink()
    }

    private func updateTargetMarkerPosition() {
        view.layoutIfNeeded()
        let containerWidth = heatProgressContainer.bounds.width
        let offset = containerWidth * CGFloat(targetHeat)
        
        targetMarkerLine.snp.updateConstraints { make in
            make.leading.equalTo(heatProgressContainer.snp.leading).offset(offset)
        }
    }

    // MARK: - Game Loop (CADisplayLink)
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        lastUpdateTime = CACurrentMediaTime()
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func gameLoop(displayLink: CADisplayLink) {
        guard isGameActive else { return }

        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        // 1. Остывание шкалы
        currentHeat = max(0.0, currentHeat - (coolDownRate * deltaTime))
        
        // 2. Уменьшение времени
        timeRemaining -= deltaTime
        if timeRemaining <= 0 {
            timeRemaining = 0
            updateTimerLabel()
            checkGameEnd()
            return
        }

        // 3. Рандомное появление бонусов (на уровнях >= 3)
        if currentLevel >= 3 && !isBonusActive && Double.random(in: 0...1) < 0.015 {
            spawnBonusSpice()
        }

        // 4. Обновление интерфейса
        updateUI(deltaTime: deltaTime)
    }

    private func updateUI(deltaTime: Double) {
        updateTimerLabel()

        // Плавное обновление прогресс бара
        let progressWidth = heatProgressContainer.bounds.width * CGFloat(currentHeat)
        heatProgressBar.snp.updateConstraints { make in
            make.width.equalTo(progressWidth)
        }

        // Анимация пламени при высоком тепле
        fireFlameLabel.alpha = CGFloat(0.2 + (currentHeat * 0.8))
        let scale = 1.0 + (currentHeat * 0.3)
        fireFlameLabel.transform = CGAffineTransform(scaleX: scale, y: scale)

        // Изменение цвета бара от оранжевого к ярко-красному
        if currentHeat >= targetHeat {
            heatProgressBar.backgroundColor = UIColor(red: 0.95, green: 0.15, blue: 0.10, alpha: 1.0)
        } else {
            heatProgressBar.backgroundColor = UIColor(red: 0.98, green: 0.45, blue: 0.20, alpha: 1.0)
        }
    }

    private func updateTimerLabel() {
        let seconds = Int(ceil(timeRemaining))
        timerLabel.text = "⏱️ 00:\(String(format: "%02d", max(0, seconds)))"
    }

    // MARK: - User Interactions
    @objc private func handleChickenTap() {
        guard isGameActive else { return }

        // Добавляем тепло
        currentHeat = min(1.0, currentHeat + tapPower)

        // Виброотклик
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // Легкая нативная анимация нажатия на курицу
        UIView.animate(withDuration: 0.05, animations: {
            self.chickenLabel.transform = CGAffineTransform(scaleX: 1.12, y: 0.88)
        }) { _ in
            UIView.animate(withDuration: 0.08) {
                self.chickenLabel.transform = .identity
            }
        }
    }

    private func spawnBonusSpice() {
        isBonusActive = true
        bonusSpiceButton.isHidden = false
        bonusSpiceButton.alpha = 0.0
        bonusSpiceButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(withDuration: 0.3) {
            self.bonusSpiceButton.alpha = 1.0
            self.bonusSpiceButton.transform = .identity
        }

        // Авто-скрытие бонуса через 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.hideBonusSpice()
        }
    }

    @objc private func handleBonusTap() {
        guard isBonusActive else { return }
        
        currentHeat = min(1.0, currentHeat + (tapPower * 2.5))
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        hideBonusSpice()
    }

    private func hideBonusSpice() {
        guard isBonusActive else { return }
        isBonusActive = false
        UIView.animate(withDuration: 0.2, animations: {
            self.bonusSpiceButton.alpha = 0.0
        }) { _ in
            self.bonusSpiceButton.isHidden = true
        }
    }

    // MARK: - Win / Lose Condition
    private func checkGameEnd() {
        isGameActive = false
        stopDisplayLink()

        let isSuccess = currentHeat >= targetHeat

        if isSuccess {
            LevelManager.shared.completeLevel(currentLevel, for: restaurant.id)
            KitchenManager.shared.addCoins(restaurant.baseReward * currentLevel)

            let alert = UIAlertController(
                title: "SPICY VICTORY! 🌶️🔥",
                message: "You reached the target heat level for \(spiceLevelTitle)!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "NOT SPICY ENOUGH! 🧊",
                message: "The chicken cooled down! Keep tapping faster next time.",
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
        currentHeat = 0.0
        isBonusActive = false
        bonusSpiceButton.isHidden = true
        configureDifficultyForLevel()
    }

    @objc private func handleClose() {
        stopDisplayLink()
        dismiss(animated: true)
    }
}
