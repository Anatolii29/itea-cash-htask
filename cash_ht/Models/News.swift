
import UIKit
import Alamofire
import ObjectMapper

class News: Mappable {
    
    var status: String?
    var totalResults: Int?
    var articles: [NewsArticle] = []
    
    required init?(map: Map) {
        do {
            self.status = try map.value("status")
        }
        catch {
            print("No status present!")
        }
    }
    
    func mapping(map: Map) {
        totalResults  <- map["totalResults"]
        articles      <- map["articles"]
    }
    
}

class NewsArticle: Mappable {
    
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var sourceId: Int?
    var sourceName: String?
    var index: String?
    
    required init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        author        <-  map["author"]
        title         <-  map["title"]
        description   <-  map["description"]
        url           <-  map["url"]
        sourceId      <-  map["source.id"]
        sourceName    <-  map["source.name"]
    }
    
}

