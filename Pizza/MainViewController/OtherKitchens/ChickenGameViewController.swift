import UIKit
import SnapKit

final class ChickenGameViewController: UIViewController {

    private let restaurant: RestaurantModel
    private let level: Int

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()

    init(restaurant: RestaurantModel, level: Int) {
        self.restaurant = restaurant
        self.level = level
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(36)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        titleLabel.text = "🔥 Hot Chicken Game\n\(restaurant.name)\nLevel \(level)"
    }

    @objc private func handleBack() {
        dismiss(animated: true)
    }
}
