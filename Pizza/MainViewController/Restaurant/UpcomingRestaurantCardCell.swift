import UIKit
import SnapKit

final class UpcomingRestaurantCardCell: UICollectionViewCell {
    static let reuseIdentifier = "UpcomingRestaurantCardCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.00, green: 0.98, blue: 0.92, alpha: 1.0)
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let borderLayer = CAShapeLayer()
    
    private let scooterLabel: UILabel = {
        let label = UILabel()
        label.text = "🛵"
        label.font = .systemFont(ofSize: 40)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "More restaurants\ncoming soon"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "FoodPick is new, and more local favorites are joining. Check back soon."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = containerView.bounds
        borderLayer.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 24).cgPath
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        borderLayer.strokeColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 0.5).cgColor
        borderLayer.lineDashPattern = [6, 6]
        borderLayer.fillColor = nil
        borderLayer.lineWidth = 1.5
        containerView.layer.addSublayer(borderLayer)
        
        containerView.addSubview(scooterLabel)
        scooterLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(scooterLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
