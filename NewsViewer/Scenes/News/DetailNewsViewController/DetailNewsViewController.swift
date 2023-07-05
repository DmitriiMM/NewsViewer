import UIKit

final class DetailNewsViewController: UIViewController {
    private let news: News
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
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
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(addToFavoriteButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = addToFavoriteButton
    }
    
    @objc private func addToFavoriteButtonTapped() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
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
            newsDescription.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

