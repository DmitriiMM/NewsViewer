import UIKit
import WebKit

final class NewsResourceWebViewController: UIViewController {
    private let link: String
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var webView = WKWebView()
    private lazy var progressView = UIProgressView()
    
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
        navigationItem.largeTitleDisplayMode = .never
        
        observeProgress()
        addSubViews()
        addConstraints()
        configWebView(with: link)
    }
    
    private func observeProgress() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             }
        )
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func configWebView(with urlString: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self, let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    private func addSubViews() {
        view.addSubview(webView)
        view.addSubview(progressView)
    }
    
    private func addConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 3),
        ])
    }
}
