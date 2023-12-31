struct NewsResult: Decodable {
    let results: [News]
    let nextPage: String?
}

struct News: Decodable, Equatable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        link = try container.decode(String.self, forKey: .link)
        creator = try container.decode([String]?.self, forKey: .creator)
        content = try container.decode(String.self, forKey: .content)
        pubDate = try container.decode(String.self, forKey: .pubDate)
        image = try container.decode(String?.self, forKey: .image)
    }
    
    init(title: String, link: String, creator: [String]?, content: String, pubDate: String, image: String?) {
        self.title = title
        self.link = link
        self.creator = creator
        self.content = content
        self.pubDate = pubDate
        self.image = image
    }
    
    let title: String
    let link: String
    let creator: [String]?
    let content: String
    let pubDate: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case creator = "creator"
        case content = "content"
        case pubDate = "pubDate"
        case image = "image_url"
    }
}
