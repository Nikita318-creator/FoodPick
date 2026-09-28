import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        contentView.addSubview(titleLabel)
        containerView.addSubview(iconLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(56)
        }
        
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(category: RestaurantCategory, isSelectedCategory: Bool) {
        iconLabel.text = category.icon
        titleLabel.text = category.rawValue
        
        if isSelectedCategory {
            containerView.backgroundColor = UIColor(red: 1.00, green: 0.78, blue: 0.23, alpha: 1.0)
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0).cgColor
        } else {
            containerView.backgroundColor = UIColor(red: 0.95, green: 0.94, blue: 0.90, alpha: 1.0)
            containerView.layer.borderWidth = 0
        }
    }
}
