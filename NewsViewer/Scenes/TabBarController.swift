import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newsViewController = NewsViewController()
        let newsNavigationController = UINavigationController(rootViewController: newsViewController)
        newsNavigationController.tabBarItem = UITabBarItem(
            title: "tabBar.news".localized,
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
        let favoriteViewController = FavoriteViewController()
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        favoriteNavigationController.tabBarItem = UITabBarItem(
            title: "tabBar.favorite".localized,
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        
        self.viewControllers = [newsNavigationController, favoriteNavigationController]
    }
}

