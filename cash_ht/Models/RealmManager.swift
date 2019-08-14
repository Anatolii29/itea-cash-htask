//
//  RealmManager.swift
//  json_test
//
//  Created by Anatolii on 7/15/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let sharedInstance: RealmManager = {
        let instance = RealmManager()
        return instance
    }()
    
    let realm = try! Realm()
    
    func writeObject(object: [NewsArticle]) {
        guard object.count > 0  else {
            return
        }
        var realmArray: [RealmNews] = []
        do {
            try realm.write {
                realm.delete(Array(realm.objects(RealmNews.self)))
            }
        } catch {
            debugPrint("Ooops, error writing Realm")
        }
        for article in object {
            let realmObject = RealmNews()
            realmObject.titleNews = article.title
            realmObject.url = article.url
            realmObject.descriptionNews = article.description
            realmObject.position = article.index
            realmArray.append(realmObject)
        }
        do {
            try realm.write {
                realm.add(realmArray)
            }
        } catch {
            print("Ooops!")
        }
    }
    
    func getData() -> [RealmNews] {
        var arrayRealmObjects: [RealmNews] = []
        arrayRealmObjects = Array(realm.objects(RealmNews.self))
        return arrayRealmObjects
    }
    
    func getUser() -> UserRealm? {
        var currentUserRealm: [UserRealm] = []
        currentUserRealm  = Array(realm.objects(UserRealm.self))
        return currentUserRealm.first
    }
    
    func writeUser(object: User?)  {
        guard let currentObject = object else {
            return
        }
        let realmObject = UserRealm()
        realmObject.name = currentObject.name
        realmObject.token = currentObject.token
        do {
            try realm.write {
                realm.add(realmObject)
            }
        } catch {
            print("Ooops!")
        }
    }
    
    func deleteUserSession() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
