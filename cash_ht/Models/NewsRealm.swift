//
//  NewsRealm.swift
//  cash_ht
//
//  Created by Anatolii on 7/30/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//
import UIKit
import RealmSwift

class RealmNews: Object {
    @objc dynamic var descriptionNews: String?
    @objc dynamic var url: String?
    @objc dynamic var titleNews: String?
    @objc dynamic var position: String?
    @objc dynamic var token: String?
}

