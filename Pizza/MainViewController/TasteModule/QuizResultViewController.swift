import UIKit

final class QuizResultViewController: UIViewController {

    private let topic: QuizTopic
    private let result: QuizResult

    init(topic: QuizTopic, result: QuizResult) {
        self.topic = topic
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        navigationItem.title = "Result"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        setupLayout()
    }

    private var emoji: String {
        switch result.percent {
        case 90...: return "🏆"
        case 70..<90: return "🔥"
        case 50..<70: return "👍"
        default: return "🍕"
        }
    }

    private var message: String {
        switch result.percent {
        case 90...: return "Outstanding! You're a true foodie."
        case 70..<90: return "Great job! Your taste buds know things."
        case 50..<70: return "Not bad! A little more practice."
        default: return "Keep tasting, you'll get there!"
        }
    }

    private func makeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor = Theme.ink) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: size, weight: weight)
        l.textColor = color
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }

    private func makeButton(title: String, filled: Bool, action: Selector) -> UIButton {
        let b = UIButton(type: .custom)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        b.layer.cornerRadius = 28
        b.layer.borderWidth = 1.5
        b.layer.borderColor = Theme.ink.cgColor
        b.backgroundColor = filled ? Theme.accent : .white
        b.setTitleColor(Theme.ink, for: .normal)
        b.heightAnchor.constraint(equalToConstant: 56).isActive = true
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }

    private func setupLayout() {
        let card = UIView()
        Theme.applyCardStyle(to: card, cornerRadius: 24)

        let cardStack = UIStackView(arrangedSubviews: [
            makeLabel(emoji, size: 64, weight: .regular),
            makeLabel("\(result.correct) / \(result.total)", size: 44, weight: .black),
            makeLabel("\(result.percent)% correct", size: 18, weight: .semibold, color: .systemGray),
            makeLabel(message, size: 16, weight: .medium),
            makeLabel("+\(result.correct * 10) XP", size: 16, weight: .bold)
        ])
        cardStack.axis = .vertical
        cardStack.spacing = 10
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(cardStack)

        let playAgain = makeButton(title: "Play Again", filled: true, action: #selector(playAgainTapped))
        let backButton = makeButton(title: "Back to Tests", filled: false, action: #selector(backTapped))

        let main = UIStackView(arrangedSubviews: [card, playAgain, backButton])
        main.axis = .vertical
        main.spacing = 16
        main.setCustomSpacing(32, after: card)
        main.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(main)

        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 28),
            cardStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -28),
            cardStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            cardStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),

            main.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            main.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            main.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func playAgainTapped() {
        guard let nav = navigationController else { return }
        let quiz = QuizViewController(topic: topic)
        quiz.hidesBottomBarWhenPushed = true
        var stack = nav.viewControllers
        stack.removeLast()
        stack.append(quiz)
        nav.setViewControllers(stack, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
