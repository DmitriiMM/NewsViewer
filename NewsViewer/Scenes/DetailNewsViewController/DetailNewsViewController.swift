import UIKit

final class DetailNewsViewController: UIViewController {
    private let news: News
    private let newsStore = NewsStore()
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var newsAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.medium, withSize: 14)
        label.textColor = .textColor
        
        return label
    }()
    
    private lazy var newsSourceLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.appFont(.regular, withSize: 14)
        button.addTarget(self, action: #selector(newsSourceLinkButtonTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private lazy var newsDescription: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.contentInsetAdjustmentBehavior = .never
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UIFont.appFont(.regular, withSize: 14)
        textView.textAlignment = .left
        textView.textColor = .textColor
        textView.backgroundColor = .contentBgColor
        textView.textContainerInset.bottom = 30
        
        return textView
    }()
    
    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .contentBgColor
        
        setupRightBarButton()
        addSubViews()
        addConstraints()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func config() {
        newsDescription.text = news.content
        newsAuthorLabel.text = news.creator?.joined(separator: ", ")
        newsSourceLinkButton.setTitle(news.link, for: .normal)
        
        if let imageUrl = news.image {
            loadCover(from: imageUrl)
        } else {
            newsImageView.isHidden = true
            newsAuthorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
    }
    
    private func loadCover(from stringUrl: String?) {
        guard
            let encodedStringUrl = stringUrl?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        
        newsImageView.setImage(from: url)
    }
    
    @objc private func newsSourceLinkButtonTapped() {
        let newsResourceVC = NewsResourceViewController(link: news.link)
        navigationController?.pushViewController(newsResourceVC, animated: true)
    }
    
    private func setupRightBarButton() {
        let addToFavoriteButton = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: self,
            action: #selector(addToFavoriteButtonTapped)
        )
        
        let favoriteNews = newsStore.news
        DispatchQueue.main.async {
            if !favoriteNews.contains(where: { $0.title == self.news.title }) {
                let image = UIImage(systemName: "bookmark")
                addToFavoriteButton.image = image
            } else {
                let image = UIImage(systemName: "bookmark.fill")
                addToFavoriteButton.image = image
            }
        }
        
        navigationItem.rightBarButtonItem = addToFavoriteButton
    }
    
    @objc private func addToFavoriteButtonTapped() {
        if !newsStore.news.contains(where: { $0 == news }) {
            addToFavorite(news)
        } else {
            deleteFromFavorite(news)
        }
    }
    
    private func addToFavorite(_ news: News) {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
        do {
            try newsStore.addNews(news)
        } catch {
            presentErrorDialog(message: "news.detail_vc.fail_add_news".localized + error.localizedDescription)
        }
    }
    
    private func deleteFromFavorite(_ news: News) {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark")
        do {
            try newsStore.delete(news: news)
        } catch {
            presentErrorDialog(message: "news.detail_vc.fail_delete_news".localized + error.localizedDescription)
        }
    }
    
    private func addSubViews() {
        view.addSubview(newsImageView)
        view.addSubview(newsAuthorLabel)
        view.addSubview(newsSourceLinkButton)
        view.addSubview(newsDescription)
    }
    
    private func addConstraints() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        newsSourceLinkButton.translatesAutoresizingMaskIntoConstraints = false
        newsDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 4),
            
            newsAuthorLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 12),
            newsAuthorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            newsAuthorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            newsSourceLinkButton.topAnchor.constraint(equalTo: newsAuthorLabel.bottomAnchor, constant: 2),
            newsSourceLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            newsSourceLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            newsDescription.topAnchor.constraint(equalTo: newsSourceLinkButton.bottomAnchor, constant: 2),
            newsDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            newsDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            newsDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

