import UIKit

final class QuizViewController: UIViewController {

    private let viewModel: QuizViewModel
    private var answered = false

    // MARK: UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let counterLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = .systemGray
        l.textAlignment = .center
        return l
    }()

    private let progressView: UIProgressView = {
        let p = UIProgressView(progressViewStyle: .bar)
        p.progressTintColor = Theme.accent
        p.trackTintColor = Theme.border
        p.layer.cornerRadius = 4
        p.clipsToBounds = true
        return p
    }()

    private let logoView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()

    private let questionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.textColor = Theme.ink
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    private let optionsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 12
        return s
    }()

    private let feedbackLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 17, weight: .bold)
        l.textColor = Theme.ink
        l.numberOfLines = 0
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    private let nextButton: UIButton = {
        let b = UIButton(type: .custom)
        b.backgroundColor = Theme.ink
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        b.layer.cornerRadius = 28
        b.isHidden = true
        return b
    }()

    // MARK: Init
    init(topic: QuizTopic) {
        viewModel = QuizViewModel(topic: topic)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        navigationItem.title = viewModel.topic.title
        navigationItem.largeTitleDisplayMode = .never
        logoView.image = UIImage(named: viewModel.topic.imageAsset)
        setupLayout()
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        loadQuestion()
    }

    private func setupLayout() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 32, right: 20)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        [counterLabel, progressView, logoView, questionLabel, optionsStack, feedbackLabel, nextButton]
            .forEach { contentStack.addArrangedSubview($0) }
        contentStack.setCustomSpacing(24, after: progressView)
        contentStack.setCustomSpacing(28, after: questionLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            progressView.heightAnchor.constraint(equalToConstant: 8),
            logoView.heightAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    // MARK: Question flow
    private func loadQuestion() {
        answered = false
        let q = viewModel.current

        counterLabel.text = "Question \(viewModel.currentIndex + 1) of \(viewModel.total)"
        progressView.setProgress(Float(viewModel.currentIndex) / Float(viewModel.total), animated: true)
        questionLabel.text = q.text
        feedbackLabel.isHidden = true
        nextButton.isHidden = true

        optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, option) in q.options.enumerated() {
            let btn = UIButton(type: .custom)
            btn.setTitle(option, for: .normal)
            btn.setTitleColor(Theme.ink, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            btn.titleLabel?.numberOfLines = 0
            btn.titleLabel?.textAlignment = .center
            btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            btn.backgroundColor = .white
            btn.layer.cornerRadius = 24
            btn.layer.borderWidth = 1.5
            btn.layer.borderColor = Theme.ink.cgColor
            btn.tag = index
            btn.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
            btn.addTarget(self, action: #selector(answerTapped(_:)), for: .touchUpInside)
            optionsStack.addArrangedSubview(btn)
        }

        scrollView.setContentOffset(.zero, animated: false)
    }

    @objc private func answerTapped(_ sender: UIButton) {
        guard !answered else { return }
        answered = true

        let isCorrect = viewModel.submit(answer: sender.tag)
        let correctIndex = viewModel.current.correctAnswerIndex
        let buttons = optionsStack.arrangedSubviews.compactMap { $0 as? UIButton }
        buttons.forEach { $0.isUserInteractionEnabled = false }

        buttons[correctIndex].backgroundColor = Theme.correct
        if !isCorrect { sender.backgroundColor = Theme.wrong }

        if isCorrect {
            feedbackLabel.text = "✅ Correct!"
        } else {
            feedbackLabel.text = "❌ Wrong! Correct answer: \(viewModel.current.options[correctIndex])"
        }

        nextButton.setTitle(viewModel.isLast ? "Finish" : "Next Question", for: .normal)
        feedbackLabel.isHidden = false
        nextButton.isHidden = false

        UINotificationFeedbackGenerator().notificationOccurred(isCorrect ? .success : .error)
    }

    @objc private func nextTapped() {
        if viewModel.isLast {
            finishQuiz()
        } else {
            viewModel.advance()
            loadQuestion()
        }
    }

    private func finishQuiz() {
        let result = viewModel.finishAndSave()   // <- сохраняет в UserDefaults
        guard let nav = navigationController else { return }

        let resultVC = QuizResultViewController(topic: viewModel.topic, result: result)
        resultVC.hidesBottomBarWhenPushed = true
        var stack = nav.viewControllers
        stack.removeLast()
        stack.append(resultVC)
        nav.setViewControllers(stack, animated: true)
    }
}
