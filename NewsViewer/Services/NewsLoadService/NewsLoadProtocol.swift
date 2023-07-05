protocol NewsLoadProtocol {
    func getNews(onCompletion: @escaping (Result<NewsResult, Error>) -> Void)
}
