import Foundation
class NewsLoadService: NewsLoadProtocol {
    private let client = DefaultNetworkClient.shared
    
    func getNews(onCompletion: @escaping (Result<NewsResult, Error>) -> Void) {
        let request = NewsGetRequest()
        
        client.send(request: request, type: NewsResult.self, onResponse: onCompletion)
    }
}
