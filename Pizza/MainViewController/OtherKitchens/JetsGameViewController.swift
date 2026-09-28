import UIKit
import SnapKit

final class JetsGameViewController: UIViewController {

    // MARK: - Models & Types
    struct CutTarget {
        let startPoint: CGPoint // Нормализованные координаты (0.0 ... 1.0)
        let endPoint: CGPoint
    }

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private let currentLevel: Int

    private var requiredAccuracy: Double = 80.0
    private var timeRemaining: Int = 15
    private var totalCutsRequired: Int = 1
    private var currentCutIndex: Int = 0

    private var targets: [CutTarget] = []
    private var userPoints: [CGPoint] = []

    private var timer: Timer?

    // CAShapeLayers для плавного рисования без перерисовок UIView
    private let pizzaCanvasView = UIView()
    private let targetLineLayer = CAShapeLayer()
    private let userCutLayer = CAShapeLayer()

    // MARK: - UI Components
    private let topBarView = UIView()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
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
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.25, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let accuracyBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textColor = UIColor(red: 0.85, green: 0.35, blue: 0.10, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let pizzaContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.82, green: 0.45, blue: 0.20, alpha: 1.0) // Корочка Детройтской пиццы
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor(red: 0.55, green: 0.25, blue: 0.10, alpha: 1.0).cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 12
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        return view
    }()

    private let pizzaInnerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.35, alpha: 1.0) // Сырный слой
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()

    private let toppingsLabel: UILabel = {
        let label = UILabel()
        label.text = "🍕 🧀 🥓 🍕 🧀 🥓\n🧀 🍕 🥓 🧀 🍕 🧀\n🥓 🧀 🍕 🥓 🧀 🍕"
        label.font = .systemFont(ofSize: 28)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.alpha = 0.6
        return label
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
        setupPanGesture()
        configureLevelDifficulty()
        startTimer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Обновляем слои при изменении размера холста
        targetLineLayer.frame = pizzaCanvasView.bounds
        userCutLayer.frame = pizzaCanvasView.bounds
        drawCurrentTargetLine()
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = restaurant.headerBackgroundColor // `#FCD99E` для Jet's Pizza
    }

    private func setupLayout() {
        view.addSubview(topBarView)
        topBarView.addSubview(backButton)
        topBarView.addSubview(levelTitleLabel)

        view.addSubview(timerLabel)
        view.addSubview(instructionCardView)
        instructionCardView.addSubview(instructionLabel)
        instructionCardView.addSubview(accuracyBadgeLabel)

        view.addSubview(pizzaContainerView)
        pizzaContainerView.addSubview(pizzaInnerView)
        pizzaInnerView.addSubview(toppingsLabel)
        pizzaInnerView.addSubview(pizzaCanvasView)

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

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

        instructionCardView.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(72)
        }

        instructionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        accuracyBadgeLabel.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        pizzaContainerView.snp.makeConstraints { make in
            make.top.equalTo(instructionCardView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(pizzaContainerView.snp.width).multipliedBy(1.1) // Прямоугольная Detroit-style форма
        }

        pizzaInnerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        toppingsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        pizzaCanvasView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Настройка слоев рисовки
        targetLineLayer.strokeColor = UIColor.systemRed.cgColor
        targetLineLayer.fillColor = nil
        targetLineLayer.lineWidth = 4
        targetLineLayer.lineDashPattern = [8, 6]

        userCutLayer.strokeColor = UIColor.white.cgColor
        userCutLayer.fillColor = nil
        userCutLayer.lineWidth = 5
        userCutLayer.lineCap = .round

        pizzaCanvasView.layer.addSublayer(targetLineLayer)
        pizzaCanvasView.layer.addSublayer(userCutLayer)

        levelTitleLabel.text = "Jet's Pizza — Level \(currentLevel)"
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pizzaCanvasView.addGestureRecognizer(panGesture)
    }

    // MARK: - Game Difficulty Configuration
    private func configureLevelDifficulty() {
        currentCutIndex = 0

        switch currentLevel {
        case 1:
            requiredAccuracy = 75.0
            timeRemaining = 18
            targets = [CutTarget(startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0))]
        case 2:
            requiredAccuracy = 80.0
            timeRemaining = 16
            targets = [CutTarget(startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))]
        case 3:
            requiredAccuracy = 83.0
            timeRemaining = 15
            targets = [CutTarget(startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0))]
        case 4:
            requiredAccuracy = 86.0
            timeRemaining = 14
            targets = [
                CutTarget(startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0)),
                CutTarget(startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
            ]
        case 5:
            requiredAccuracy = 88.0
            timeRemaining = 12
            targets = [
                CutTarget(startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0)),
                CutTarget(startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0))
            ]
        case 6...10:
            requiredAccuracy = 90.0
            timeRemaining = 10
            targets = [
                CutTarget(startPoint: CGPoint(x: 0.33, y: 0.0), endPoint: CGPoint(x: 0.33, y: 1.0)),
                CutTarget(startPoint: CGPoint(x: 0.66, y: 0.0), endPoint: CGPoint(x: 0.66, y: 1.0))
            ]
        default: // Levels 11 - 100
            requiredAccuracy = 92.0
            timeRemaining = max(7, 12 - (currentLevel / 15))
            targets = [
                CutTarget(startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y: 1.0)),
                CutTarget(startPoint: CGPoint(x: 0.0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5)),
                CutTarget(startPoint: CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint(x: 1.0, y: 1.0))
            ]
        }

        totalCutsRequired = targets.count
        updateInstructionUI()
    }

    private func updateInstructionUI() {
        let cutText = totalCutsRequired > 1 ? "Cut \(currentCutIndex + 1) of \(totalCutsRequired)" : "Single Precise Cut"
        instructionLabel.text = "🔪 Slice along the dashed line!\n\(cutText)"
        accuracyBadgeLabel.text = "Target Accuracy: \(Int(requiredAccuracy))%+"
    }

    // MARK: - Drawing Target Line
    private func drawCurrentTargetLine() {
        guard currentCutIndex < targets.count, pizzaCanvasView.bounds.width > 0 else { return }

        let target = targets[currentCutIndex]
        let width = pizzaCanvasView.bounds.width
        let height = pizzaCanvasView.bounds.height

        let start = CGPoint(x: target.startPoint.x * width, y: target.startPoint.y * height)
        let end = CGPoint(x: target.endPoint.x * width, y: target.endPoint.y * height)

        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        targetLineLayer.path = path.cgPath
    }

    // MARK: - Gesture Handling
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: pizzaCanvasView)

        switch gesture.state {
        case .began:
            userPoints = [point]
            userCutLayer.path = nil

        case .changed:
            userPoints.append(point)
            drawUserCutPath()

        case .ended, .cancelled:
            evaluateUserCut()

        default:
            break
        }
    }

    private func drawUserCutPath() {
        guard userPoints.count > 1 else { return }

        let path = UIBezierPath()
        path.move(to: userPoints.first!)
        for point in userPoints.dropFirst() {
            path.addLine(to: point)
        }
        userCutLayer.path = path.cgPath
    }

    // MARK: - Precision Calculation
    private func evaluateUserCut() {
        guard userPoints.count > 5, currentCutIndex < targets.count else {
            showFeedbackAnimation(success: false, message: "Cut too short! Try again 🔪")
            userCutLayer.path = nil
            return
        }

        let target = targets[currentCutIndex]
        let width = pizzaCanvasView.bounds.width
        let height = pizzaCanvasView.bounds.height

        let lineStart = CGPoint(x: target.startPoint.x * width, y: target.startPoint.y * height)
        let lineEnd = CGPoint(x: target.endPoint.x * width, y: target.endPoint.y * height)

        // Считаем среднее расстояние от каждой точки разреза пользователя до целевого отрезка
        var totalDistance: CGFloat = 0.0
        for pt in userPoints {
            totalDistance += distanceFromPointToSegment(p: pt, a: lineStart, b: lineEnd)
        }

        let avgDistance = totalDistance / CGFloat(userPoints.count)

        // Нормализация точности: 0 px ошибки = 100%, 35 px ошибки = 0%
        let maxAllowedError: CGFloat = 35.0
        let accuracy = max(0.0, min(100.0, Double((1.0 - (avgDistance / maxAllowedError)) * 100.0)))

        let haptic = UIImpactFeedbackGenerator(style: accuracy >= requiredAccuracy ? .medium : .soft)
        haptic.impactOccurred()

        if accuracy >= requiredAccuracy {
            currentCutIndex += 1
            if currentCutIndex >= totalCutsRequired {
                finishGame(success: true, calculatedAccuracy: accuracy)
            } else {
                showFeedbackAnimation(success: true, message: String(format: "Great Cut! %.0f%% Accuracy ✨", accuracy))
                userCutLayer.path = nil
                updateInstructionUI()
                drawCurrentTargetLine()
            }
        } else {
            // Ошибка: штраф по времени и сброс линии
            timeRemaining = max(0, timeRemaining - 2)
            updateTimerLabel()
            showFeedbackAnimation(success: false, message: String(format: "%.0f%% - Not precise enough! (-2s)", accuracy))
            userCutLayer.path = nil
        }
    }

    private func distanceFromPointToSegment(p: CGPoint, a: CGPoint, b: CGPoint) -> CGFloat {
        let l2 = pow(a.x - b.x, 2) + pow(a.y - b.y, 2)
        if l2 == 0 { return hypot(p.x - a.x, p.y - a.y) }

        var t = ((p.x - a.x) * (b.x - a.x) + (p.y - a.y) * (b.y - a.y)) / l2
        t = max(0, min(1, t))

        let projection = CGPoint(x: a.x + t * (b.x - a.x), y: a.y + t * (b.y - a.y))
        return hypot(p.x - projection.x, p.y - projection.y)
    }

    // MARK: - Feedback & Animations
    private func showFeedbackAnimation(success: Bool, message: String) {
        let feedbackLabel = UILabel()
        feedbackLabel.text = message
        feedbackLabel.font = .systemFont(ofSize: 17, weight: .bold)
        feedbackLabel.textColor = success ? UIColor.systemGreen : UIColor.systemRed
        feedbackLabel.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        feedbackLabel.layer.cornerRadius = 12
        feedbackLabel.clipsToBounds = true
        feedbackLabel.textAlignment = .center

        view.addSubview(feedbackLabel)
        feedbackLabel.snp.makeConstraints { make in
            make.center.equalTo(pizzaCanvasView)
            make.height.equalTo(44)
            make.width.equalTo(260)
        }

        feedbackLabel.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        feedbackLabel.alpha = 0

        UIView.animate(withDuration: 0.25, animations: {
            feedbackLabel.transform = .identity
            feedbackLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.6, options: [], animations: {
                feedbackLabel.alpha = 0
                feedbackLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { _ in
                feedbackLabel.removeFromSuperview()
            }
        }
    }

    // MARK: - Timer & Game End
    private func startTimer() {
        updateTimerLabel()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.updateTimerLabel()

            if self.timeRemaining <= 0 {
                self.finishGame(success: false, calculatedAccuracy: 0)
            }
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = "⏱️ 00:\(String(format: "%02d", max(0, timeRemaining)))"
    }

    private func finishGame(success: Bool, calculatedAccuracy: Double) {
        timer?.invalidate()

        if success {
            LevelManager.shared.completeLevel(currentLevel, for: restaurant.id)
            KitchenManager.shared.addCoins(restaurant.baseReward * currentLevel)

            let title = currentLevel <= 5 ? "Crispy Cut Master! ✂️" : "Detroit Square Master! 🍕"
            let alert = UIAlertController(
                title: title,
                message: String(format: "Level %d Cleared with %.0f%% accuracy!\nYou earned %d coins.", currentLevel, calculatedAccuracy, restaurant.baseReward * currentLevel),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Next / Continue", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Time's Up! ⏳",
                message: "The pizza wasn't sliced in time! Give level \(currentLevel) another try.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] _ in
                self?.configureLevelDifficulty()
                self?.userCutLayer.path = nil
                self?.drawCurrentTargetLine()
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
