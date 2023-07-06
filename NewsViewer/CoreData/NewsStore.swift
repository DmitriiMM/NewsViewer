import UIKit
import CoreData

enum NewsStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidLink
    case decodingErrorInvalidCreator
    case decodingErrorInvalidContent
    case decodingErrorInvalidPubDate
    case decodingErrorInvalidImage
}

struct NewsStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
}

protocol NewsStoreDelegate: AnyObject {
    func store(_ store: NewsStore, didUpdate update: NewsStoreUpdate)
}

final class NewsStore: NSObject {
    private let context: NSManagedObjectContext
    weak var delegate: NewsStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<NewsCoreData> = {
        let fetchRequest = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \NewsCoreData.pubDate, ascending: false)
        ]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    var news: [News] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let news = try? objects.map({ try self.fetchNews(from: $0) })
        else { return [] }
        return news
    }
    
    func addNews(_ news: News) throws {
        let addingNews = NewsCoreData(context: context)
        addingNews.title = news.title
        addingNews.link = news.link
        addingNews.creator = news.creator?.joined(separator: ", ")
        addingNews.content = news.content
        addingNews.pubDate = news.pubDate
        addingNews.image = news.image
        
        try context.save()
    }
    
    func delete(news: News) throws {
        let request = NSFetchRequest<NewsCoreData>(entityName: "NewsCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(NewsCoreData.title),
            news.title
        )
        let news = try context.fetch(request)
        news.forEach { news in
            context.delete(news)
        }
        
        try context.save()
    }
    
    private func fetchNews(from newsCoreData: NewsCoreData) throws -> News {
        guard let title = newsCoreData.title else {
            throw NewsStoreError.decodingErrorInvalidTitle
        }
        
        guard let link = newsCoreData.link else {
            throw NewsStoreError.decodingErrorInvalidLink
        }
        
        let creatorString = newsCoreData.creator
        let creator: [String]? = [creatorString].compactMap { $0 }
        
        guard let content = newsCoreData.content else {
            throw NewsStoreError.decodingErrorInvalidContent
        }
        
        guard let pubDate = newsCoreData.pubDate else {
            throw NewsStoreError.decodingErrorInvalidPubDate
        }
        
        let image = newsCoreData.image
        
        return News(
            title: title,
            link: link,
            creator: creator,
            content: content,
            pubDate: pubDate,
            image: image
        )
    }
}

extension NewsStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: NewsStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.row)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.row)
            }
        default:
            break
        }
    }
}
