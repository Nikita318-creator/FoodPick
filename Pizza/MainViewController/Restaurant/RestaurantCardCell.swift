import UIKit
import SnapKit

final class RestaurantCardCell: UICollectionViewCell {
    static let reuseIdentifier = "RestaurantCardCell"
    
    var onOrderTap: (() -> Void)?
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let statusBadge: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let statusDot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.20, green: 0.68, blue: 0.40, alpha: 1.0)
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Open now"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return label
    }()
    
    private let logoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }()
    
    private let promoBadgeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.00, green: 0.78, blue: 0.23, alpha: 1.0)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let promoBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Order now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(handleOrderTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(cardContainer)
        cardContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardContainer.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        headerView.addSubview(logoContainer)
        logoContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(70)
        }
        
        logoContainer.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        // Ставим поверх логотипа
        headerView.addSubview(statusBadge)
        statusBadge.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
        
        statusBadge.addSubview(statusDot)
        statusDot.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(8)
        }
        
        statusBadge.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusDot.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        cardContainer.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        cardContainer.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        cardContainer.addSubview(promoBadgeContainer)
        promoBadgeContainer.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        promoBadgeContainer.addSubview(promoBadgeLabel)
        promoBadgeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        cardContainer.addSubview(orderButton)
        orderButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        cardContainer.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(promoBadgeContainer.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(orderButton.snp.top).offset(-12)
        }
    }
    
    func configure(with model: RestaurantModel) {
        headerView.backgroundColor = model.headerBackgroundColor
        logoImageView.image = UIImage(named: model.logoImageName)
        titleLabel.text = model.name
        categoryLabel.text = model.category
        descriptionLabel.text = model.descriptionText
        
        if let promo = model.badgeText, !promo.isEmpty {
            promoBadgeContainer.isHidden = false
            promoBadgeLabel.text = promo
            
            descriptionLabel.snp.remakeConstraints { make in
                make.top.equalTo(promoBadgeContainer.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.lessThanOrEqualTo(orderButton.snp.top).offset(-12)
            }
        } else {
            promoBadgeContainer.isHidden = true
            
            descriptionLabel.snp.remakeConstraints { make in
                make.top.equalTo(categoryLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
                make.bottom.lessThanOrEqualTo(orderButton.snp.top).offset(-12)
            }
        }
    }
    
    @objc private func handleOrderTap() {
        onOrderTap?()
    }
}
