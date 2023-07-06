import UIKit

final class NewsCell: UITableViewCell {
    static let identifier = String(describing: NewsCell.self)
    let dateHelper = DateHelper.shared
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.semibold, withSize: 20)
        label.textColor = .textColor
        label.numberOfLines = 3
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.regular, withSize: 10)
        label.textColor = .textColor
        label.numberOfLines = 3
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.regular, withSize: 10)
        label.textColor = .textColor
        label.textAlignment = .right
        label.numberOfLines = 3
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .backgroundColor
        contentView.backgroundColor = .contentBgColor
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let margins = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 18
    }
    
    func configure(by news: News) {
        contentView.layoutIfNeeded()
        
        let fittingSize = CGSize(width: contentView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(fittingSize)
        
        frame.size.height = size.height
        
        newsLabel.text = news.title
        
        authorLabel.text = news.creator?.joined(separator: ", ")
        
        
        if let date = dateHelper.dateFormatterIn.date(from: news.pubDate) {
            dateLabel.text = dateHelper.dateFormatterOut.string(from: date)
        }
        
        if let cover = news.image {
            loadCover(from: cover)
        } else {
            newsImageView.isHidden = true
            newsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        }
    }
    
    private func loadCover(from stringUrl: String) {
        guard
            let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        newsImageView.setImage(from: url)
    }
    
    private func addSubViews() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func addConstraints() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            newsImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            newsLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            newsLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor),
            newsLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            newsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            dateLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            authorLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
}
