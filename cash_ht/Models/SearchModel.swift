import Foundation

class SearchModel {
    var pageNumber: Int = 0
    var pageSize: Int = 5
    var maxPageSize: Int = 100
    var apiKey: String = "4ea21ee288f24ae880ef13ebda15edbd"
    var searchKey: String = "Apple"
    var dataFrom: Date = setFromDate()
    var dataTo: Date = setToDate()
    
    private static func setFromDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2019-07-15") ?? Date()
    }
    
    private static func setToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2019-08-01") ?? Date()
    }
    
    func returnDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}
