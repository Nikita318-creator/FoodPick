import UIKit
import SnapKit

final class OriginStoryViewController: UIViewController {

    private let origin: RestaurantOrigin
    private var currentIndex: Int = 0

    // MARK: - UI Components
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .heavy)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .left
        return label
    }()

    private let slideTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .center
        return label
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let storyCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()

    private let storyTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let menuHighlightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .black)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.12, green: 0.10, blue: 0.16, alpha: 1.0)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(origin: RestaurantOrigin) {
        self.origin = origin
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        showSlide(at: 0)
    }

    private func setupLayout() {
        view.backgroundColor = origin.themeColor

        view.addSubview(progressLabel)
        view.addSubview(closeButton)
        view.addSubview(slideTitleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(iconImageView)
        view.addSubview(storyCardView)

        storyCardView.addSubview(storyTextLabel)
        storyCardView.addSubview(menuHighlightLabel)

        view.addSubview(nextButton)

        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(36)
        }

        slideTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(slideTitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }

        storyCardView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        storyTextLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }

        menuHighlightLabel.snp.makeConstraints { make in
            make.top.equalTo(storyTextLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(54)
        }
    }

    private func showSlide(at index: Int) {
        guard index < origin.slides.count else {
            dismiss(animated: true)
            return
        }

        currentIndex = index
        let slide = origin.slides[index]

        progressLabel.text = "SLIDE \(index + 1) OF \(origin.slides.count)"
        slideTitleLabel.text = slide.title
        subtitleLabel.text = slide.subtitle
        iconImageView.image = UIImage(systemName: slide.imageName)
        storyTextLabel.text = slide.storyText
        menuHighlightLabel.text = slide.menuHighlight

        // Если это финальный слайд — ставим надпись "FINISH"
        if index == origin.slides.count - 1 {
            nextButton.setTitle("FINISH", for: .normal)
        } else {
            nextButton.setTitle("NEXT ➔", for: .normal)
        }
    }

    @objc private func handleNext() {
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()

        if currentIndex >= origin.slides.count - 1 {
            dismiss(animated: true)
        } else {
            showSlide(at: currentIndex + 1)
        }
    }

    @objc private func handleClose() {
        dismiss(animated: true)
    }
}
