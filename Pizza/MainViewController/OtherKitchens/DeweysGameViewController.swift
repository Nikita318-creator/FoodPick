import UIKit
import SnapKit

final class DeweysGameViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let level: Int

    private var timeRemaining: Int
    private var requiredCatches: Int
    private var currentCatches: Int = 0
    private var score: Int = 0

    private var gameTimer: Timer?
    private var isDoughInFlight: Bool = false
    private var isDoughInTargetZone: Bool = false

    // Level scaling
    private var flightDuration: TimeInterval
    private var targetZoneHeight: CGFloat

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

    private let levelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let scoreBadgeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 14
        return view
    }()

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
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

    private let instructionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // Game Field
    private let gameAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()

    private let targetZoneView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        view.layer.borderColor = UIColor.systemGreen.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 16
        return view
    }()

    private let targetZoneLabel: UILabel = {
        let label = UILabel()
        label.text = "🎯 CATCH ZONE"
        label.font = .systemFont(ofSize: 14, weight: .black)
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()

    private let doughLabel: UILabel = {
        let label = UILabel()
        label.text = "🫓"
        label.font = .systemFont(ofSize: 60)
        label.textAlignment = .center
        return label
    }()

    // Controls
    private lazy var tossButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🚀 TOSS DOUGH", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleToss), for: .touchUpInside)
        return button
    }()

    private lazy var catchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎯 CATCH!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleCatch), for: .touchUpInside)
        return button
    }()

    private let feedbackLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .black)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.level = level
        
        self.timeRemaining = max(15, 30 - (level / 5))
        self.requiredCatches = min(10, 3 + (level / 10))
        
        // Время полета теста: от 1.8 сек (легко) до 0.7 сек (100 уровень)
        self.flightDuration = max(0.7, 1.8 - (Double(level) * 0.011))
        self.targetZoneHeight = max(60.0, 120.0 - CGFloat(level) * 0.6)

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
        updateUI()
        startTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer?.invalidate()
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = restaurant.headerBackgroundColor
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(levelTitleLabel)
        topBarView.addSubview(scoreBadgeView)
        scoreBadgeView.addSubview(scoreLabel)

        view.addSubview(timerLabel)
        view.addSubview(instructionCardView)
        instructionCardView.addSubview(instructionLabel)

        view.addSubview(gameAreaView)
        gameAreaView.addSubview(targetZoneView)
        targetZoneView.addSubview(targetZoneLabel)
        gameAreaView.addSubview(doughLabel)
        gameAreaView.addSubview(feedbackLabel)

        let buttonsStack = UIStackView(arrangedSubviews: [tossButton, catchButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.distribution = .fillEqually
        view.addSubview(buttonsStack)

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

        scoreBadgeView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.height.equalTo(28)
        }

        scoreLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        instructionCardView.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        instructionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }

        gameAreaView.snp.makeConstraints { make in
            make.top.equalTo(instructionCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(buttonsStack.snp.top).offset(-20)
        }

        targetZoneView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(targetZoneHeight)
        }

        targetZoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.centerX.equalToSuperview()
        }

        buttonsStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }

        feedbackLabel.snp.makeConstraints { make in
            make.center.equalTo(targetZoneView)
        }

        levelTitleLabel.text = "Dewey's — Level \(level)"
        instructionLabel.text = "1. Tap TOSS 🚀  2. Tap CATCH 🎯 inside Green Zone!"
        
        resetDoughPosition()
    }

    private func updateUI() {
        scoreLabel.text = "🍕 \(currentCatches)/\(requiredCatches)"
    }

    private func startTimer() {
        timerLabel.text = "⏱️ 00:\(String(format: "%02d", timeRemaining))"
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.timerLabel.text = "⏱️ 00:\(String(format: "%02d", max(0, self.timeRemaining)))"

            if self.timeRemaining <= 0 {
                self.finishGame(success: false)
            }
        }
    }

    private func resetDoughPosition() {
        doughLabel.layer.removeAllAnimations()
        doughLabel.text = "🫓"
        doughLabel.transform = .identity
        
        doughLabel.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(60)
        }
        gameAreaView.layoutIfNeeded()
    }

    // MARK: - Game Mechanics
    @objc private func handleToss() {
        guard !isDoughInFlight else { return }
        
        isDoughInFlight = true
        isDoughInTargetZone = false
        
        tossButton.isEnabled = false
        tossButton.alpha = 0.5
        catchButton.isEnabled = true
        catchButton.alpha = 1.0

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        // Анимация полета через SnapKit + UIView.animate
        doughLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(-80) // Улетает наверх
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }

        // Тайминг вхождения в зону
        let enterZoneDelay = flightDuration * 0.45
        let exitZoneDelay = flightDuration * 0.80

        DispatchQueue.main.asyncAfter(deadline: .now() + enterZoneDelay) { [weak self] in
            guard let self = self, self.isDoughInFlight else { return }
            self.isDoughInTargetZone = true
            self.targetZoneView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + exitZoneDelay) { [weak self] in
            guard let self = self, self.isDoughInFlight else { return }
            self.isDoughInTargetZone = false
            self.targetZoneView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        }

        UIView.animate(withDuration: flightDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.doughLabel.transform = CGAffineTransform(rotationAngle: .pi)
            self.gameAreaView.layoutIfNeeded()
        }) { [weak self] completed in
            guard let self = self else { return }
            if completed && self.isDoughInFlight {
                // Если не успел нажать CATCH
                self.handleMiss(reason: "TOO LATE! 💨")
            }
        }
    }

    @objc private func handleCatch() {
        guard isDoughInFlight else { return }
        
        doughLabel.layer.removeAllAnimations()
        isDoughInFlight = false
        catchButton.isEnabled = false
        catchButton.alpha = 0.5

        if isDoughInTargetZone {
            // УСПЕХ!
            currentCatches += 1
            doughLabel.text = "🍕"
            showFeedback("PERFECT! ✨", color: .systemGreen)
            
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(.success)
            
            updateUI()

            if currentCatches >= requiredCatches {
                finishGame(success: true)
            } else {
                prepareNextToss()
            }
        } else {
            // ПРОМАХ!
            handleMiss(reason: "MISSED! ❌")
        }
    }

    private func handleMiss(reason: String) {
        isDoughInFlight = false
        doughLabel.layer.removeAllAnimations()
        doughLabel.text = "💥"
        
        timeRemaining = max(0, timeRemaining - 2)
        timerLabel.text = "⏱️ 00:\(String(format: "%02d", timeRemaining))"

        showFeedback(reason, color: .systemRed)
        
        let haptic = UINotificationFeedbackGenerator()
        haptic.notificationOccurred(.error)

        prepareNextToss()
    }

    private func prepareNextToss() {
        targetZoneView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self = self else { return }
            self.resetDoughPosition()
            self.tossButton.isEnabled = true
            self.tossButton.alpha = 1.0
        }
    }

    private func showFeedback(_ text: String, color: UIColor) {
        feedbackLabel.text = text
        feedbackLabel.textColor = color
        feedbackLabel.alpha = 1.0
        
        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
            self.feedbackLabel.alpha = 0
        })
    }

    private func finishGame(success: Bool) {
        gameTimer?.invalidate()

        if success {
            LevelManager.shared.completeLevel(level, for: restaurant.id)
            KitchenManager.shared.addCoins(restaurant.baseReward * level)

            let alert = UIAlertController(title: "Level Cleared! 🍕🎉", message: "You caught all \(requiredCatches) doughs!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Time's Up! ⏳", message: "Try level \(level) again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.currentCatches = 0
                self.timeRemaining = max(15, 30 - (self.level / 5))
                self.updateUI()
                self.resetDoughPosition()
                self.tossButton.isEnabled = true
                self.tossButton.alpha = 1.0
                self.catchButton.isEnabled = false
                self.catchButton.alpha = 0.5
                self.startTimer()
            }))
            alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        }
    }

    @objc private func handleBack() {
        gameTimer?.invalidate()
        dismiss(animated: true)
    }
}
