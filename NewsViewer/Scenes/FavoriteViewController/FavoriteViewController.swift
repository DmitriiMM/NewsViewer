import UIKit

final class FavoriteViewController: NewsViewController {
    private let newsStore = NewsStore()
    private var favoriteNews: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "tabBar.favorite".localized
        
        newsStore.delegate = self
    }
    
    override func loadData() {
        favoriteNews = newsStore.news
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailVC(for: favoriteNews[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else { return UITableViewCell() }
        cell.configure(by: favoriteNews[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) { }
}

extension FavoriteViewController: NewsStoreDelegate {
    func store(_ store: NewsStore, didUpdate update: NewsStoreUpdate) {
        let favoriteTableView = super.tableView
        favoriteNews = newsStore.news
        favoriteTableView.performBatchUpdates {
            let insertedIndexPaths = update.insertedIndexes.map { IndexPath(row: $0, section: 0) }
            let deletedIndexPaths = update.deletedIndexes.map { IndexPath(row: $0, section: 0) }
            favoriteTableView.insertRows(at: insertedIndexPaths, with: .fade)
            favoriteTableView.deleteRows(at: deletedIndexPaths, with: .fade)
        }
    }
}
