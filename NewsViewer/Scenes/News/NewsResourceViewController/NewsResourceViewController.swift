import UIKit
import WebKit

final class NewsResourceViewController: UIViewController {
    private let link: String
    private let webView = WKWebView()
    
    init(link: String) {
        self.link = link
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        addSubViews()
        addConstraints()
        configWebView(with: link)
    }
    
    private func configWebView(with urlString: String) {
        webView.navigationDelegate = self
        UIBlockingProgressHUD.show()
        DispatchQueue.main.async { [weak self] in
            guard let self, let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    private func addSubViews() {
        view.addSubview(webView)
    }
    
    private func addConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension NewsResourceViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIBlockingProgressHUD.dismiss()
    }
}
