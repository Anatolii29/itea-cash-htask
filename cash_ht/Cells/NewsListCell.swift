//
//  NewsListCell.swift
//  cash_ht
//
//  Created by Anatolii on 7/30/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import Foundation
import UIKit

class NewsListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resourseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    var currentNews: NewsArticle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(news: NewsArticle?) {
        currentNews = news
        titleLabel.text = currentNews?.title ?? ""
        resourseLabel.text = currentNews?.url ?? ""
        descriptionLabel.text = currentNews?.description ?? ""
    }
    
}
