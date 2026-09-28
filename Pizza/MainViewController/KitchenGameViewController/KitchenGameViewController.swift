import UIKit
import SnapKit

final class KitchenGameViewController: UIViewController {

    // MARK: - Properties
    private let restaurant: RestaurantModel
    private var requiredIngredients: [String] = []
    private var currentIngredientIndex = 0
    private var timeRemaining: Int = 15
    private var timer: Timer?

    // MARK: - UI Components
    private let cardContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 28
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }()

    private let headerBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()

    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.progressTintColor = UIColor(red: 0.20, green: 0.68, blue: 0.40, alpha: 1.0)
        progress.trackTintColor = UIColor.systemGray5
        progress.layer.cornerRadius = 4
        progress.clipsToBounds = true
        return progress
    }()

    private let recipeCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0)
        view.layer.cornerRadius = 16
        return view
    }()

    private let recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "INCOMING ORDER"
        label.font = .systemFont(ofSize: 12, weight: .black)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()

    private let recipeTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let ingredientsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemGray3
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLayout()
        generateNewOrder()
        startTimer()
    }

    // MARK: - Setup
    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    private func setupLayout() {
        view.addSubview(cardContainerView)
        cardContainerView.addSubview(headerBackgroundView)
        cardContainerView.addSubview(closeButton)
        cardContainerView.addSubview(titleLabel)
        cardContainerView.addSubview(timerLabel)
        cardContainerView.addSubview(progressBar)
        cardContainerView.addSubview(recipeCardView)
        
        recipeCardView.addSubview(recipeTitleLabel)
        recipeCardView.addSubview(recipeTextLabel)
        
        cardContainerView.addSubview(ingredientsStackView)

        cardContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }

        headerBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(60)
        }

        headerBackgroundView.backgroundColor = restaurant.headerBackgroundColor

        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.size.equalTo(28)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(headerBackgroundView)
        }

        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(headerBackgroundView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(8)
        }

        recipeCardView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(90)
        }

        recipeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
        }

        recipeTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }

        ingredientsStackView.snp.makeConstraints { make in
            make.top.equalTo(recipeCardView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().inset(24)
        }

        titleLabel.text = restaurant.name
    }

    // MARK: - Game Logic
    private func generateNewOrder() {
        let availableIngredients = ["🍕 Dough", "🧀 Cheese", "🥩 Sauce", "🍗 Wings", "🔥 Spice"]
        requiredIngredients = Array(availableIngredients.shuffled().prefix(3))
        currentIngredientIndex = 0

        recipeTextLabel.text = requiredIngredients.joined(separator: " + ")
        progressBar.setProgress(0, animated: false)

        setupIngredientButtons(allOptions: availableIngredients.shuffled())
    }

    private func setupIngredientButtons(allOptions: [String]) {
        ingredientsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for item in allOptions.prefix(3) {
            let button = UIButton(type: .system)
            button.setTitle(item, for: .normal)
            button.setTitleColor(UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
            button.backgroundColor = UIColor(red: 1.00, green: 0.78, blue: 0.23, alpha: 0.4)
            button.layer.cornerRadius = 14
            button.addTarget(self, action: #selector(handleIngredientTap(_:)), for: .touchUpInside)
            ingredientsStackView.addArrangedSubview(button)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.timerLabel.text = "⏱️ 00:\(String(format: "%02d", self.timeRemaining))"

            if self.timeRemaining <= 0 {
                self.finishGame(success: false)
            }
        }
    }

    @objc private func handleIngredientTap(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()

        if requiredIngredients.contains(title) {
            sender.isEnabled = false
            sender.alpha = 0.4
            currentIngredientIndex += 1

            let progress = Float(currentIngredientIndex) / Float(requiredIngredients.count)
            progressBar.setProgress(progress, animated: true)

            if currentIngredientIndex >= requiredIngredients.count {
                finishGame(success: true)
            }
        }
    }

    private func finishGame(success: Bool) {
        timer?.invalidate()

        if success {
            KitchenManager.shared.addCoins(restaurant.baseReward)
            let successFeedback = UINotificationFeedbackGenerator()
            successFeedback.notificationOccurred(.success)

            let alert = UIAlertController(title: "Order Completed! 🎉", message: "You earned +\(restaurant.baseReward) Coins!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }))
            present(alert, animated: true)
        } else {
            let errorFeedback = UINotificationFeedbackGenerator()
            errorFeedback.notificationOccurred(.error)

            let alert = UIAlertController(title: "Time's Up! ⏳", message: "The customer left. Try again next time!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { [weak self] _ in
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
