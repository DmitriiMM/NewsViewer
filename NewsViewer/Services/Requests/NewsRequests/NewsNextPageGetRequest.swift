import Foundation

struct NewsNextPageGetRequest: NetworkRequest {
    let nextPage: String
    var endpoint: URL? {
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path),
           let apiKey = keys["API_KEY"] as? String {
            return URL(string: "https://newsdata.io/api/1/news?apikey=\(apiKey)&page=\(nextPage)")
        } else {
            return nil
        }
    }
}
