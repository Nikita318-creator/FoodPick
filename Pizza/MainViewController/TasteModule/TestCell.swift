import UIKit

// MARK: - Test cell
final class TestCell: UICollectionViewCell {

    static let reuseID = "TestCell"
    static let height: CGFloat = 224

    private let imageContainer = UIView()
    private let logoView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let badge = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func build() {
        Theme.applyCardStyle(to: contentView)
        contentView.clipsToBounds = true

        imageContainer.backgroundColor = Theme.background
        logoView.contentMode = .scaleAspectFit
        logoView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = Theme.ink
        titleLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.numberOfLines = 1

        badge.text = "START"
        badge.font = .systemFont(ofSize: 12, weight: .bold)
        badge.textColor = Theme.ink
        badge.backgroundColor = Theme.accent
        badge.textAlignment = .center
        badge.layer.cornerRadius = 11
        badge.clipsToBounds = true

        [imageContainer, logoView, titleLabel, subtitleLabel, badge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(imageContainer)
        imageContainer.addSubview(logoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(badge)

        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: 100),

            logoView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 12),
            logoView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -12),
            logoView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 12),
            logoView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -12),

            titleLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            badge.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            badge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            badge.widthAnchor.constraint(equalToConstant: 60),
            badge.heightAnchor.constraint(equalToConstant: 22),
            badge.topAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: 6)
        ])
    }

    func configure(with topic: QuizTopic) {
        logoView.image = UIImage(named: topic.imageAsset)
        titleLabel.text = topic.title
        subtitleLabel.text = topic.subtitle
    }
}

// MARK: - Section header
final class SectionHeaderView: UICollectionReusableView {

    static let reuseID = "SectionHeaderView"
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = Theme.ink
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String) { label.text = title }
}
