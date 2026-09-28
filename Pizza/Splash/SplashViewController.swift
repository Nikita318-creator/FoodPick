import UIKit
import SnapKit
import FirebaseFirestore

final class SplashViewController: UIViewController {

    // MARK: - Constants
    private enum Keys {
        static let savedUrl = "app_saved"
    }

    // MARK: - UI Elements
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "FoodPick")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FoodPick"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemGray
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleRouting()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Задаем явный белый цвет (или .systemBackground, если нужен системный)
        view.backgroundColor = .white

        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(activityIndicator)

        // Иконка по центру со смещением чуть вверх
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.size.equalTo(120)
        }

        // Лейбл под иконкой
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }

        // Лоадер под лейблом
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        activityIndicator.startAnimating()
    }

    // MARK: - Routing Logic
    private func handleRouting() {
        let defaults = UserDefaults.standard

        if let savedValue = defaults.string(forKey: Keys.savedUrl) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                
                if savedValue.isEmpty {
                    self.showMainScreen()
                } else {
                    self.showWebScreen(with: savedValue)
                    self.fetchFirebaseInBackground()
                }
            }
            return
        }

        let dispatchGroup = DispatchGroup()
        var fetchedUrl: String?

        dispatchGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        fetchFirebaseUrl(timeout: 6.0) { url in
            fetchedUrl = url
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }

            if let urlString = fetchedUrl, !urlString.isEmpty {
                defaults.set(urlString, forKey: Keys.savedUrl)
                self.showWebScreen(with: urlString)
            } else {
                defaults.set("", forKey: Keys.savedUrl)
                self.showMainScreen()
            }
        }
    }

    // MARK: - Firebase Fetching
    private func fetchFirebaseUrl(timeout: TimeInterval = 6.0, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        var isCompleted = false

        let safeCompletion: (String?) -> Void = { result in
            guard !isCompleted else { return }
            isCompleted = true
            completion(result)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            safeCompletion(nil)
        }

        db.collection("config").document("app").getDocument(source: .server) { snapshot, error in
            if let error = error {
                print("Firebase Error / No Internet: \(error.localizedDescription)")
                safeCompletion(nil)
                return
            }

            let url = snapshot?.data()?["myPath"] as? String
            safeCompletion(url)
        }
    }

    private func fetchFirebaseInBackground() {
        fetchFirebaseUrl(timeout: 10.0) { url in
            guard let newUrl = url, !newUrl.isEmpty else { return }

            let currentSaved = UserDefaults.standard.string(forKey: Keys.savedUrl)
            if currentSaved != newUrl {
                UserDefaults.standard.set(newUrl, forKey: Keys.savedUrl)
            }
        }
    }

    // MARK: - Navigation
    private func showMainScreen() {
        let mainVC = MainViewController()
        setRootViewController(mainVC)
    }

    private func showWebScreen(with urlString: String) {
        let webVC = BaseVC(urlString: urlString)
        setRootViewController(webVC)
    }

    private func setRootViewController(_ vc: UIViewController) {
        guard let window = view.window else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = vc
        }
    }
}
