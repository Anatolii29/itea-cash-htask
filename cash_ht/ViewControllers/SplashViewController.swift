//
//  SplashViewController.swift
//  cash_ht
//
//  Created by Anatolii on 8/7/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import RealmSwift

class SplashViewController: UIViewController {
    
    var cashManager = RealmManager.sharedInstance
    var userArray: [User] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        guard Reachability.isConnectedToNetwork() else {
            self.presentWarningOneAction(message: "Sorry. No internet connection!")
            return
        }
        ref = Database.database().reference()
        getUserfromDB()
    }
    
    func isDBconnectionDone() {
        DispatchQueue.main.async {
            self.isUserLoggedIn()
        }
    }
    
    func isUserLoggedIn() {
        
        if let currentUser = checkIsUserLoggedIn() {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            vc.update(user: currentUser)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.update(userArrayFromDB: userArray)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkIsUserLoggedIn() -> User? {
        if let token = getUserTokenFromCash() {
            if let currentUser = userArray.filter({$0.token == token}).first {
                return currentUser
            }
        }
        return nil
    }
    
    func getUserTokenFromCash() -> String? {
        return cashManager.getUser()?.token
    }
    
    func getUserfromDB() {
        self.ref.child("userList").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: Any] {
                for userValue in value {
                    if let dbUser = userValue.value as? [String: Any] {
                        let currentUser = User()
                        if let name = dbUser["name"] as? String {
                            currentUser.name = name
                        }
                        if let surname = dbUser["surname"] as? String {
                            currentUser.surname = surname
                        }
                        if let password = dbUser["password"] as? String {
                            currentUser.password = password
                        }
                        if let login = dbUser["login"] as? String {
                            currentUser.login = login
                        }
                        if let email = dbUser["email"] as? String {
                            currentUser.email = email
                        }
                        if let telephone = dbUser["telephone"] as? String {
                            currentUser.telephone = telephone
                        }
                        if let city = dbUser["city"] as? String {
                            currentUser.city = city
                        }
                        if let photo = dbUser["photo"] as? String {
                            currentUser.photo = photo
                        }
                        if let address = dbUser["address"] as? String {
                            currentUser.adress = address
                        }
                        if let age = dbUser["age"] as? Int {
                            currentUser.age = age
                        }
                        if let latitude = dbUser["latitude"] as? Double {
                            currentUser.latitude = latitude
                        }
                        if let longitude = dbUser["longitude"] as? Double {
                            currentUser.longitude = longitude
                        }
                        if let token = dbUser["token"] as? String {
                            currentUser.token = token
                        }
                        if let searchKey = dbUser["searchKey"] as? String {
                            currentUser.searchKey = searchKey
                        }
                        self.userArray.append(currentUser)
                    }
                }
                self.isDBconnectionDone()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}
