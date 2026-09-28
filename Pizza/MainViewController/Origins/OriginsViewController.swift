import UIKit
import SnapKit

final class OriginsViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Restaurant Origins 📖"
        label.font = .systemFont(ofSize: 28, weight: .black)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover secret recipes & comic origin stories"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(OriginCardCell.self, forCellReuseIdentifier: OriginCardCell.reuseIdentifier)
        return tv
    }()

    private var origins: [RestaurantOrigin] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.98, green: 0.97, blue: 0.95, alpha: 1.0)
        setupLayout()
        origins = OriginDataProvider.getOrigins()
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(tableView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension OriginsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return origins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OriginCardCell.reuseIdentifier, for: indexPath) as? OriginCardCell else {
            return UITableViewCell()
        }
        cell.configure(with: origins[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOrigin = origins[indexPath.row]
        let storyVC = OriginStoryViewController(origin: selectedOrigin)
        storyVC.modalPresentationStyle = .fullScreen
        present(storyVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

// MARK: - OriginCardCell
final class OriginCardCell: UITableViewCell {
    static let reuseIdentifier = "OriginCardCell"

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let taglineLabel = UILabel()
    private let badgeView = UIView()
    private let badgeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)

        taglineLabel.font = .systemFont(ofSize: 13, weight: .medium)
        taglineLabel.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 0.7)

        badgeView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        badgeView.layer.cornerRadius = 12

        badgeLabel.text = "READ STORY ➔"
        badgeLabel.font = .systemFont(ofSize: 11, weight: .black)
        badgeLabel.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(taglineLabel)
        containerView.addSubview(badgeView)
        badgeView.addSubview(badgeLabel)

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        taglineLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
        }

        badgeView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
        }

        badgeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with origin: RestaurantOrigin) {
        containerView.backgroundColor = origin.themeColor
        titleLabel.text = origin.restaurantName
        taglineLabel.text = origin.tagline
    }
}
