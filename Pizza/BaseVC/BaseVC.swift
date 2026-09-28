import UIKit
import WebKit
import SnapKit

final class BaseVC: UIViewController, WKNavigationDelegate, WKUIDelegate {

    private let urlString: String

    private lazy var mainView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true

        let wv = WKWebView(frame: .zero, configuration: configuration)
        wv.navigationDelegate = self
        wv.uiDelegate = self
        wv.backgroundColor = .black
        wv.scrollView.backgroundColor = .black
        wv.isOpaque = false
        wv.allowsBackForwardNavigationGestures = true
        return wv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(red: 0.88, green: 0.72, blue: 0.20, alpha: 1.0)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")//Thread 1: Fatal error: init(coder:) has not been implemented
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupSubviews()
        setupConstraints()
        loadContent()
    }

    private func setupSubviews() {
        view.addSubview(mainView)
        view.addSubview(activityIndicator)
    }

    private func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func loadContent() {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        mainView.load(request)
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1.0
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoader()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()
    }

    private func hideLoader() {
        UIView.animate(withDuration: 0.25) {
            self.activityIndicator.alpha = 0.0
        } completion: { _ in
            self.activityIndicator.stopAnimating()
        }
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        let scheme = url.scheme?.lowercased() ?? ""

        // Обработка стандартных внешних приложений (звонки, почта, мессенджеры)
        if scheme != "http" && scheme != "https" && scheme != "about" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

    // Поддержка открывания ссылок в target="_blank"
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
