struct NewsResult: Decodable {
    let results: [News]
}

struct News: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        creator = try container.decode([String]?.self, forKey: .creator)
        content = try container.decode(String.self, forKey: .content)
        pubDate = try container.decode(String.self, forKey: .pubDate)
        image = try container.decode(String?.self, forKey: .image)
    }
    
    let title: String
    let creator: [String]?
    let content: String
    let pubDate: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case creator = "creator"
        case content = "content"
        case pubDate = "pubDate"
        case image = "image_url"
    }
}
