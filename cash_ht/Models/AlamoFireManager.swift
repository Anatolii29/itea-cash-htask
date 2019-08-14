//
//  AlamoFireManager.swift
//  cash_ht
//
//  Created by Anatolii on 8/10/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol AlamoFireURLRequestDelegate {
    func updateInfoInTableView()
}

class AlamoFireURLRequest {
    
    var pageNumber: Int = 0
    var pageSize: Int = 10
    var maxPageSize: Int = 100
    var apiKey: String = "d51980b4fc434993b47141d1db23b2a4"
    var searchKey: String = "Apple"
    var dataFrom: Date = setFromDate()
    var dataTo: Date = setToDate()
    var url: String = "https://newsapi.org/v2/everything"
    var delegate: NewsViewController?
    
    
    private static func setFromDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2019-07-30") ?? Date()
    }
    
    private static func setToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2019-08-08") ?? Date()
    }
    
    func returnDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func getDataWithParameters(vc: UIViewController) {
        var parameters: [String: Any] = [:]
        parameters["q"] = searchKey
        parameters["apiKey"] = apiKey
        parameters["from"] = dataFrom
        parameters["to"] = dataTo
        parameters["pageSize"] = pageSize
        parameters["page"] = pageNumber
        
        if let currnetvc = vc as? NewsViewController {
            delegate = currnetvc
        }
        
        var news: News?
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            news = Mapper<News>().map(JSONObject: response.result.value)
            self.delegate?.updateInfoInTableView(newsArray: news?.articles ?? [])
        }
    }
    
    func getDataWithParametersCompletion(completion: @escaping ([NewsArticle]) -> ()) {
        var parameters: [String: Any] = [:]
        parameters["q"] = searchKey
        parameters["apiKey"] = apiKey
        parameters["from"] = dataFrom
        parameters["to"] = dataTo
        parameters["pageSize"] = pageSize
        parameters["page"] = pageNumber
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let news = Mapper<News>().map(JSONObject: response.result.value)
            completion(news?.articles ?? [])
        }
    }
    
}
