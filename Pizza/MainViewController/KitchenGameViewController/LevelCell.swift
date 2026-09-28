
import UIKit
import SnapKit

final class LevelCell: UICollectionViewCell {

    static let reuseIdentifier = "LevelCell"

    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 6
        return view
    }()

    private let levelNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .darkText
        label.textAlignment = .center
        return label
    }()

    private let lockImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        iv.image = UIImage(systemName: "lock.fill", withConfiguration: config)
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.backgroundColor = .white
        levelNumberLabel.isHidden = false
        lockImageView.isHidden = true
    }

    // MARK: - Setup
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(levelNumberLabel)
        containerView.addSubview(lockImageView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        levelNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        lockImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - Configuration
    func configure(level: Int, isUnlocked: Bool, themeColor: UIColor) {
        if isUnlocked {
            containerView.backgroundColor = .white
            levelNumberLabel.text = "\(level)"
            levelNumberLabel.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
            levelNumberLabel.isHidden = false
            lockImageView.isHidden = true
            contentView.alpha = 1.0
            isUserInteractionEnabled = true
        } else {
            containerView.backgroundColor = UIColor.systemGray6
            levelNumberLabel.isHidden = true
            lockImageView.isHidden = false
            contentView.alpha = 0.6
            isUserInteractionEnabled = false
        }
    }
}
