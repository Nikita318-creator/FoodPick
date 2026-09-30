import UIKit
import SafariServices
import StoreKit

final class ProfileViewController: UIViewController {

    private enum Links {
        static let privacy = URL(string: "https://sites.google.com/view/ppfoodpicresort")!
        static let terms = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    }

    // MARK: UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let avatarView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        iv.tintColor = Theme.ink
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Foodie_99"           // моковый профиль
        l.font = .systemFont(ofSize: 28, weight: .black)
        l.textColor = Theme.ink
        l.textAlignment = .center
        return l
    }()

    private let rankLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textColor = Theme.ink
        l.textAlignment = .center
        l.backgroundColor = Theme.accent.withAlphaComponent(0.3)
        l.layer.cornerRadius = 14
        l.clipsToBounds = true
        return l
    }()

    private let levelTitleLabel = ProfileViewController.makeLabel(size: 18, weight: .bold)
    private let xpLabel = ProfileViewController.makeLabel(size: 13, weight: .medium, color: .systemGray)
    private let levelProgress: UIProgressView = {
        let p = UIProgressView(progressViewStyle: .bar)
        p.progressTintColor = Theme.accent
        p.trackTintColor = Theme.border
        p.layer.cornerRadius = 5
        p.clipsToBounds = true
        return p
    }()

    private let quizzesValue = ProfileViewController.makeLabel(size: 24, weight: .black, align: .center)
    private let accuracyValue = ProfileViewController.makeLabel(size: 24, weight: .black, align: .center)
    private let bestValue = ProfileViewController.makeLabel(size: 24, weight: .black, align: .center)

    private static func makeLabel(size: CGFloat, weight: UIFont.Weight,
                                  color: UIColor = Theme.ink, align: NSTextAlignment = .left) -> UILabel {
        let l = UILabel()
        l.font = .systemFont(ofSize: size, weight: weight)
        l.textColor = color
        l.textAlignment = align
        return l
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        navigationItem.title = "Profile"
        setupLayout()
        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()   // обновляем прогресс после прохождения тестов
    }

    private func refresh() {
        let store = ResultsStore.shared
        let progress = store.progress

        rankLabel.text = "  🏆 \(progress.rankTitle)  "
        levelTitleLabel.text = "Level \(progress.level)"
        xpLabel.text = "\(progress.xpIntoLevel) / \(UserProgress.xpPerLevel) XP  •  \(progress.xpToNext) XP to next level"
        levelProgress.setProgress(progress.progress, animated: true)

        quizzesValue.text = "\(store.quizzesCompleted)"
        accuracyValue.text = "\(store.accuracyPercent)%"
        bestValue.text = "\(store.bestPercent)%"
    }

    // MARK: Layout
    private func setupLayout() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 8, left: 20, bottom: 32, right: 20)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        // Header
        let rankWrapper = UIStackView(arrangedSubviews: [rankLabel])
        rankWrapper.alignment = .center
        rankWrapper.axis = .vertical

        contentStack.addArrangedSubview(avatarView)
        contentStack.addArrangedSubview(nameLabel)
        contentStack.addArrangedSubview(rankWrapper)
        contentStack.setCustomSpacing(8, after: nameLabel)
        contentStack.setCustomSpacing(24, after: rankWrapper)

        // Level card
        let levelCard = UIView()
        Theme.applyCardStyle(to: levelCard, cornerRadius: 24)
        let levelStack = UIStackView(arrangedSubviews: [levelTitleLabel, levelProgress, xpLabel])
        levelStack.axis = .vertical
        levelStack.spacing = 10
        levelStack.translatesAutoresizingMaskIntoConstraints = false
        levelCard.addSubview(levelStack)
        contentStack.addArrangedSubview(levelCard)

        // Stats card
        let statsCard = UIView()
        Theme.applyCardStyle(to: statsCard, cornerRadius: 24)
        let statsStack = UIStackView(arrangedSubviews: [
            statColumn(value: quizzesValue, caption: "Quizzes"),
            statColumn(value: accuracyValue, caption: "Accuracy"),
            statColumn(value: bestValue, caption: "Best")
        ])
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsCard.addSubview(statsStack)
        contentStack.addArrangedSubview(statsCard)
        contentStack.setCustomSpacing(24, after: statsCard)

        // Links
        contentStack.addArrangedSubview(makeRow(icon: "star.fill", title: "Rate Us", action: #selector(rateTapped)))
        contentStack.addArrangedSubview(makeRow(icon: "hand.raised.fill", title: "Privacy Policy", action: #selector(privacyTapped)))
        contentStack.addArrangedSubview(makeRow(icon: "doc.text.fill", title: "Terms of Use", action: #selector(termsTapped)))

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            avatarView.heightAnchor.constraint(equalToConstant: 100),
            rankLabel.heightAnchor.constraint(equalToConstant: 28),
            levelProgress.heightAnchor.constraint(equalToConstant: 10),

            levelStack.topAnchor.constraint(equalTo: levelCard.topAnchor, constant: 20),
            levelStack.bottomAnchor.constraint(equalTo: levelCard.bottomAnchor, constant: -20),
            levelStack.leadingAnchor.constraint(equalTo: levelCard.leadingAnchor, constant: 20),
            levelStack.trailingAnchor.constraint(equalTo: levelCard.trailingAnchor, constant: -20),

            statsStack.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 20),
            statsStack.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -20),
            statsStack.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor),
            statsStack.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor)
        ])
    }

    private func statColumn(value: UILabel, caption: String) -> UIView {
        let captionLabel = ProfileViewController.makeLabel(size: 13, weight: .medium, color: .systemGray, align: .center)
        captionLabel.text = caption
        let stack = UIStackView(arrangedSubviews: [value, captionLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }

    private func makeRow(icon: String, title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        Theme.applyCardStyle(to: button, cornerRadius: 20)
        button.setTitle(title, for: .normal)
        button.setTitleColor(Theme.ink, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 20)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = Theme.ink
        iconView.contentMode = .scaleAspectFit
        iconView.isUserInteractionEnabled = false
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .systemGray3
        chevron.contentMode = .scaleAspectFit
        chevron.isUserInteractionEnabled = false
        chevron.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(iconView)
        button.addSubview(chevron)
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),

            chevron.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20),
            chevron.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 12),
            chevron.heightAnchor.constraint(equalToConstant: 16)
        ])
        return button
    }

    // MARK: Actions
    @objc private func rateTapped() {
        if #available(iOS 14.0, *) {
            if let scene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }

    @objc private func privacyTapped() { open(Links.privacy) }
    @objc private func termsTapped() { open(Links.terms) }

    private func open(_ url: URL) {
        let safari = SFSafariViewController(url: url)
        safari.preferredControlTintColor = Theme.ink
        present(safari, animated: true)
    }
}
