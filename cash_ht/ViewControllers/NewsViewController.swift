//
//  NewsViewController.swift
//  cash_ht
//
//  Created by Anatolii on 7/28/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import UIKit
import ObjectMapper

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var urlPaginationNewsString = "https://newsapi.org/v2/everything"
    var newsList: [NewsArticle] = []
    var searchModel = AlamoFireURLRequest()
    var cashManager = RealmManager.sharedInstance
    var currentUser: User?
    var delegate: AlamoFireURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let xib = UINib(nibName: "NewsListCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "NewsListCell")
        
        performURLReq()
    }
    
    @IBAction func backButtonPresse(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func update(user: User?) {
        currentUser = user
    }
    
    func checkCash() {
        let array = cashManager.getData()
        for element in array {
            print(element.position ?? "")
            print(element.titleNews ?? "")
            print("------------------")
        }
    }
    
    func updateInfoInTableView(newsArray: [NewsArticle]) {
        newsList.append(contentsOf: newsArray)
        if Reachability.isConnectedToNetwork() {
            fillIndexes()
            writeToCash(object: newsList)
        }
        tableView.reloadData()
    }
    
    func fillIndexes() {
        var count = 1
        for element in newsList {
            element.index = String(count)
            count = count + 1
        }
    }
    
    func writeToCash(object: [NewsArticle]) {
        self.cashManager.writeObject(object: object)
    }
    
    func performURLReq() {
        if Reachability.isConnectedToNetwork() {
            searchModel.pageNumber = searchModel.pageNumber + 1
            if let user = currentUser {
                searchModel.searchKey = user.searchKey
            }
            searchModel.getDataWithParametersCompletion(completion: {(DBNewsList) in
                self.updateInfoInTableView(newsArray: DBNewsList)
            })
        }
        else {
            let newsArrayFromCash =  cashManager.getData()
            var currentNewsArray: [NewsArticle] = []
            for realmNews in newsArrayFromCash {
                let article = NewsArticle()
                article.title = realmNews.titleNews
                article.description = realmNews.descriptionNews
                article.url = realmNews.url
                article.index = realmNews.position
                currentNewsArray.append(article)
            }
            if currentNewsArray.count > 0 {
                newsList.removeAll()
                updateInfoInTableView(newsArray: currentNewsArray)
            }
        }
    }
    
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell") as! NewsListCell
        cell.update(news: newsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currInd = indexPath.row + 1
        let count = newsList.count
        if currInd == count {
            if Reachability.isConnectedToNetwork() {
                performURLReq()
            }
        }
    }
    
}
