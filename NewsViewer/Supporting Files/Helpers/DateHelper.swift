import Foundation

class DateHelper {
    static let shared = DateHelper()
    
    let dateFormatterIn: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter
    }()
    
    let dateFormatterOut: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter
    }()
}

