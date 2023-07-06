import UIKit

class NewsViewController: UIViewController {
    private let newsLoadService = NewsLoadService()
    private var news: [News] = []
    
     lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    private lazy var emptyTableLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.appFont(.semibold, withSize: 17)
        label.text = "news.news_vc.error_message".localized
        label.textColor = .textColor
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        
        title = "tabBar.news".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadData()
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(emptyTableLabel)
    }
  
    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyTableLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyTableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTableLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyTableLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func showDetailVC(for news: News) {
        let detailVC = DetailNewsViewController(news: news)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func loadData() {
        UIBlockingProgressHUD.show()
        newsLoadService.getNews(onCompletion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newsResult):
                    self?.news = newsResult.results
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.presentErrorDialog(message: error.localizedDescription)
                    self?.emptyTableLabel.isHidden = false
                }
                UIBlockingProgressHUD.dismiss()
            }
        })
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailVC(for: news[indexPath.row])
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else { return UITableViewCell() }
        cell.configure(by: news[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}

