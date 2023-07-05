import Foundation

struct NewsGetRequest: NetworkRequest {
    var endpoint: URL? {
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
           let keys = NSDictionary(contentsOfFile: path),
           let apiKey = keys["API_KEY"] as? String {
            return URL(string: "https://newsdata.io/api/1/news?apikey=\(apiKey)")
        } else {
            return nil
        }
    }
}
