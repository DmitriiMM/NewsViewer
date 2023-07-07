protocol NewsLoadProtocol {
    func getNews(onCompletion: @escaping (Result<NewsResult, Error>) -> Void)
    func getNews(for nextPage: String, onCompletion: @escaping (Result<NewsResult, Error>) -> Void)
}
