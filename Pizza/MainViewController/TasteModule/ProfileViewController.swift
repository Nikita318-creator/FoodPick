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
    private let contentView = UIView()

    private let avatarView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        iv.tintColor = Theme.ink
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Foodie_99"
        l.font = .systemFont(ofSize: 22, weight: .bold)
        l.textColor = Theme.ink
        return l
    }()

    private let rankLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .bold)
        l.textColor = Theme.ink
        l.textAlignment = .center
        l.backgroundColor = Theme.accent.withAlphaComponent(0.3)
        l.layer.cornerRadius = 10
        l.clipsToBounds = true
        return l
    }()

    private let levelTitleLabel = ProfileViewController.makeLabel(size: 15, weight: .bold)
    private let xpLabel = ProfileViewController.makeLabel(size: 12, weight: .medium, color: .systemGray)
    private let levelProgress: UIProgressView = {
        let p = UIProgressView(progressViewStyle: .bar)
        p.progressTintColor = Theme.accent
        p.trackTintColor = Theme.border
        p.layer.cornerRadius = 4
        p.clipsToBounds = true
        return p
    }()

    private let quizzesValue = ProfileViewController.makeLabel(size: 22, weight: .black, align: .center)
    private let accuracyValue = ProfileViewController.makeLabel(size: 32, weight: .black, align: .center)
    private let bestValue = ProfileViewController.makeLabel(size: 22, weight: .black, align: .center)

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
        refresh()
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
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // 1. Hero Card (Profile + Level Info)
        let heroCard = UIView()
        Theme.applyCardStyle(to: heroCard, cornerRadius: 24)
        heroCard.translatesAutoresizingMaskIntoConstraints = false

        let profileHeaderStack = UIStackView(arrangedSubviews: [nameLabel, rankLabel])
        profileHeaderStack.axis = .vertical
        profileHeaderStack.alignment = .leading
        profileHeaderStack.spacing = 6

        let topUserInfoStack = UIStackView(arrangedSubviews: [avatarView, profileHeaderStack])
        topUserInfoStack.axis = .horizontal
        topUserInfoStack.alignment = .center
        topUserInfoStack.spacing = 16

        let levelHeaderStack = UIStackView(arrangedSubviews: [levelTitleLabel, xpLabel])
        levelHeaderStack.axis = .horizontal
        levelHeaderStack.distribution = .equalSpacing

        let heroStack = UIStackView(arrangedSubviews: [topUserInfoStack, levelHeaderStack, levelProgress])
        heroStack.axis = .vertical
        heroStack.spacing = 14
        heroStack.translatesAutoresizingMaskIntoConstraints = false
        heroCard.addSubview(heroStack)

        // 2. Bento Grid Stats
        let mainStatCard = UIView() // Accuracy (Big Left)
        Theme.applyCardStyle(to: mainStatCard, cornerRadius: 20)
        let accuracyStack = statColumn(value: accuracyValue, caption: "Accuracy")
        accuracyStack.translatesAutoresizingMaskIntoConstraints = false
        mainStatCard.addSubview(accuracyStack)

        let quizzesCard = UIView() // Quizzes (Top Right)
        Theme.applyCardStyle(to: quizzesCard, cornerRadius: 20)
        let quizzesStack = statColumn(value: quizzesValue, caption: "Quizzes")
        quizzesStack.translatesAutoresizingMaskIntoConstraints = false
        quizzesCard.addSubview(quizzesStack)

        let bestCard = UIView() // Best (Bottom Right)
        Theme.applyCardStyle(to: bestCard, cornerRadius: 20)
        let bestStack = statColumn(value: bestValue, caption: "Best")
        bestStack.translatesAutoresizingMaskIntoConstraints = false
        bestCard.addSubview(bestStack)

        let rightStatsStack = UIStackView(arrangedSubviews: [quizzesCard, bestCard])
        rightStatsStack.axis = .vertical
        rightStatsStack.distribution = .fillEqually
        rightStatsStack.spacing = 12

        let bentoGridStack = UIStackView(arrangedSubviews: [mainStatCard, rightStatsStack])
        bentoGridStack.axis = .horizontal
        bentoGridStack.distribution = .fillEqually
        bentoGridStack.spacing = 12
        bentoGridStack.translatesAutoresizingMaskIntoConstraints = false

        // 3. Links Card (Grouped Container)
        let linksCard = UIView()
        Theme.applyCardStyle(to: linksCard, cornerRadius: 20)
        linksCard.translatesAutoresizingMaskIntoConstraints = false

        let rateRow = makeRow(icon: "star.fill", title: "Rate Us", action: #selector(rateTapped))
        let privacyRow = makeRow(icon: "hand.raised.fill", title: "Privacy Policy", action: #selector(privacyTapped))
        let termsRow = makeRow(icon: "doc.text.fill", title: "Terms of Use", action: #selector(termsTapped))

        let sep1 = makeSeparator()
        let sep2 = makeSeparator()

        let linksStack = UIStackView(arrangedSubviews: [rateRow, sep1, privacyRow, sep2, termsRow])
        linksStack.axis = .vertical
        linksStack.spacing = 0
        linksStack.translatesAutoresizingMaskIntoConstraints = false
        linksCard.addSubview(linksStack)

        // Adding subviews to main content view
        contentView.addSubview(heroCard)
        contentView.addSubview(bentoGridStack)
        contentView.addSubview(linksCard)

        NSLayoutConstraint.activate([
            // Scroll & Content Guide
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            // Hero Card Constraints
            heroCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            heroCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            heroCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            heroStack.topAnchor.constraint(equalTo: heroCard.topAnchor, constant: 18),
            heroStack.bottomAnchor.constraint(equalTo: heroCard.bottomAnchor, constant: -18),
            heroStack.leadingAnchor.constraint(equalTo: heroCard.leadingAnchor, constant: 18),
            heroStack.trailingAnchor.constraint(equalTo: heroCard.trailingAnchor, constant: -18),

            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            rankLabel.heightAnchor.constraint(equalToConstant: 22),
            levelProgress.heightAnchor.constraint(equalToConstant: 8),

            // Bento Grid Constraints
            bentoGridStack.topAnchor.constraint(equalTo: heroCard.bottomAnchor, constant: 16),
            bentoGridStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bentoGridStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bentoGridStack.heightAnchor.constraint(equalToConstant: 140),

            accuracyStack.centerXAnchor.constraint(equalTo: mainStatCard.centerXAnchor),
            accuracyStack.centerYAnchor.constraint(equalTo: mainStatCard.centerYAnchor),

            quizzesStack.centerXAnchor.constraint(equalTo: quizzesCard.centerXAnchor),
            quizzesStack.centerYAnchor.constraint(equalTo: quizzesCard.centerYAnchor),

            bestStack.centerXAnchor.constraint(equalTo: bestCard.centerXAnchor),
            bestStack.centerYAnchor.constraint(equalTo: bestCard.centerYAnchor),

            // Links Card Constraints
            linksCard.topAnchor.constraint(equalTo: bentoGridStack.bottomAnchor, constant: 16),
            linksCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            linksCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            linksCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            linksStack.topAnchor.constraint(equalTo: linksCard.topAnchor),
            linksStack.bottomAnchor.constraint(equalTo: linksCard.bottomAnchor),
            linksStack.leadingAnchor.constraint(equalTo: linksCard.leadingAnchor),
            linksStack.trailingAnchor.constraint(equalTo: linksCard.trailingAnchor)
        ])
    }

    private func statColumn(value: UILabel, caption: String) -> UIView {
        let captionLabel = ProfileViewController.makeLabel(size: 12, weight: .semibold, color: .systemGray, align: .center)
        captionLabel.text = caption.uppercased()
        let stack = UIStackView(arrangedSubviews: [value, captionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        return stack
    }

    private func makeRow(icon: String, title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(Theme.ink, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 16)
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
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
            iconView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),

            chevron.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 10),
            chevron.heightAnchor.constraint(equalToConstant: 14)
        ])
        return button
    }

    private func makeSeparator() -> UIView {
        let v = UIView()
        v.backgroundColor = Theme.border.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
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
