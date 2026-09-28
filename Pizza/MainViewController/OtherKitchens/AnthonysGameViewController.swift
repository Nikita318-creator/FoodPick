import UIKit
import SnapKit

final class AnthonysGameViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let currentLevel: Int
    
    // Игровая логика температуры
    private var currentTemperature: Double = 750.0 // Старт ниже нормы
    private let targetMinTemp: Double = 880.0
    private let targetMaxTemp: Double = 920.0
    private let maxTempLimit: Double = 1000.0
    private let minTempLimit: Double = 600.0
    
    // Очки и Таймер удержания
    private var targetTimeRemaining: Double // Время удержания в зеленой зоне (сек)
    private var isInGreenZone: Bool = false
    private var gameTimer: CADisplayLink?
    private var lastFrameTimestamp: CFTimeInterval = 0
    
    // Внешние силы (колебания температуры)
    private var heatLossRate: Double = 35.0 // Степень остывания печи в секунду
    private var randomFluctuation: Double = 0.0

    // MARK: - UI Components
    private let topBarView = UIView()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
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

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 12
        return view
    }()

    private let pizzaEmojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🍕🔥"
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()

    private let tempStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "750°F"
        label.font = .systemFont(ofSize: 36, weight: .black)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let statusSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep oven between 880°F - 920°F!"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()

    // Градусник (Progress View + Zone Indicators)
    private let thermometerContainer = UIView()
    
    private let tempTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let greenZoneIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.35)
        view.layer.cornerRadius = 4
        return view
    }()

    private let tempFillView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemOrange
        view.layer.cornerRadius = 12
        return view
    }()

    private let holdProgressLabel: UILabel = {
        let label = UILabel()
        label.text = "⏱️ Hold Target: 10.0s"
        label.font = .monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private lazy var addCoalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🪵 ADD COAL (+40°)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.35, green: 0.25, blue: 0.20, alpha: 1.0) // Цвета угля
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.addTarget(self, action: #selector(handleAddCoal), for: .touchUpInside)
        return button
    }()

    private lazy var BellowsButton: UIButton = { // Кнопка поддува (быстрый нагрев)
        let button = UIButton(type: .system)
        button.setTitle("💨 BELLOWS (+15°)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0), for: .normal)
        button.backgroundColor = UIColor(red: 0.95, green: 0.90, blue: 0.80, alpha: 1.0)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(handleBellows), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.currentLevel = level
        // На более высоких уровнях удерживать нужно дольше (от 8 до 15 секунд)
        self.targetTimeRemaining = min(8.0 + Double(level) * 0.2, 15.0)
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
        setupGreenZonePosition()
        startLoop()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoop()
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = restaurant.headerBackgroundColor // Лавандово-углистый (#E6CCF2)
        levelTitleLabel.text = "Anthony's — Level \(currentLevel)"
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(levelTitleLabel)

        view.addSubview(cardView)
        cardView.addSubview(pizzaEmojiLabel)
        cardView.addSubview(tempStatusLabel)
        cardView.addSubview(statusSubtitleLabel)
        cardView.addSubview(thermometerContainer)
        
        thermometerContainer.addSubview(tempTrackView)
        tempTrackView.addSubview(greenZoneIndicatorView)
        tempTrackView.addSubview(tempFillView)
        
        cardView.addSubview(holdProgressLabel)
        
        view.addSubview(addCoalButton)
        view.addSubview(BellowsButton)

        topBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        levelTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        cardView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addCoalButton.snp.top).offset(-24)
        }

        pizzaEmojiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }

        tempStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(pizzaEmojiLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        statusSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tempStatusLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        thermometerContainer.snp.makeConstraints { make in
            make.top.equalTo(statusSubtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(32)
        }

        tempTrackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tempFillView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(0) // Динамически обновляется в CADisplayLink
        }

        holdProgressLabel.snp.makeConstraints { make in
            make.top.equalTo(thermometerContainer.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
        }

        addCoalButton.snp.makeConstraints { make in
            make.bottom.equalTo(BellowsButton.snp.top).offset(-12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }

        BellowsButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(46)
        }
    }

    private func setupGreenZonePosition() {
        view.layoutIfNeeded()

        // Зеленая зона от 880° до 920° на шкале 600°...1000° (ширина диапазона = 400°)
        let minRatio = CGFloat(targetMinTemp - minTempLimit) / CGFloat(maxTempLimit - minTempLimit)
        let maxRatio = CGFloat(targetMaxTemp - minTempLimit) / CGFloat(maxTempLimit - minTempLimit)

        greenZoneIndicatorView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(tempTrackView.bounds.width * minRatio)
            make.width.equalTo(tempTrackView.bounds.width * (maxRatio - minRatio))
        }
    }

    // MARK: - Game Loop
    private func startLoop() {
        lastFrameTimestamp = CACurrentMediaTime()
        gameTimer = CADisplayLink(target: self, selector: #selector(updateGameLoop))
        gameTimer?.add(to: .main, forMode: .common)
    }

    private func stopLoop() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    @objc private func updateGameLoop(displayLink: CADisplayLink) {
        let currentTime = displayLink.timestamp
        let deltaTime = currentTime - lastFrameTimestamp
        lastFrameTimestamp = currentTime

        // 1. Случайные колебания ветра/огня
        if Int.random(in: 0...30) == 0 {
            randomFluctuation = Double.random(in: -20.0...15.0)
        }

        // 2. Падение температуры со временем + колебания
        currentTemperature -= (heatLossRate + randomFluctuation) * deltaTime
        currentTemperature = max(minTempLimit, min(maxTempLimit, currentTemperature))

        // 3. Проверка попадания в целевую зону
        let inZone = currentTemperature >= targetMinTemp && currentTemperature <= targetMaxTemp
        
        if inZone {
            targetTimeRemaining -= deltaTime
            if targetTimeRemaining <= 0 {
                targetTimeRemaining = 0
                finishGame(success: true)
                return
            }
        }

        // 4. Обновление UI
        updateUI(inZone: inZone)
    }

    private func updateUI(inZone: Bool) {
        tempStatusLabel.text = "\(Int(currentTemperature))°F"
        holdProgressLabel.text = String(format: "⏱️ Hold Target: %.1fs", max(0, targetTimeRemaining))
        
        // Изменение цвета заполнителя термометра
        if currentTemperature > targetMaxTemp {
            tempFillView.backgroundColor = .systemRed // Перегрев
            tempStatusLabel.textColor = .systemRed
        } else if inZone {
            tempFillView.backgroundColor = .systemGreen // Идеально
            tempStatusLabel.textColor = .systemGreen
        } else {
            tempFillView.backgroundColor = .systemOrange // Недогрев
            tempStatusLabel.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        }

        // Расчет ширины заполнителя
        let ratio = CGFloat((currentTemperature - minTempLimit) / (maxTempLimit - minTempLimit))
        let clampedRatio = max(0, min(1, ratio))
        let fillWidth = tempTrackView.bounds.width * clampedRatio

        tempFillView.snp.updateConstraints { make in
            make.width.equalTo(fillWidth)
        }
    }

    // MARK: - Actions
    @objc private func handleAddCoal() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()

        currentTemperature += 45.0
        animateCoalBounce()
    }

    @objc private func handleBellows() {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()

        currentTemperature += 18.0
    }

    private func animateCoalBounce() {
        UIView.animate(withDuration: 0.1, animations: {
            self.pizzaEmojiLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.pizzaEmojiLabel.transform = .identity
            }
        }
    }

    private func finishGame(success: Bool) {
        stopLoop()

        if success {
            LevelManager.shared.completeLevel(currentLevel, for: restaurant.id)
            KitchenManager.shared.addCoins(restaurant.baseReward * currentLevel)

            let alert = UIAlertController(
                title: "Perfect Crust! 🍕🔥",
                message: "You maintained 900°F coal heat like a master!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        }
    }

    @objc private func handleBack() {
        stopLoop()
        dismiss(animated: true)
    }
}
