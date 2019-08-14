//
//  UserRealm.swift
//  cash_ht
//
//  Created by Anatolii on 8/7/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import UIKit
import RealmSwift

class UserRealm: Object {
    @objc dynamic var name: String?
    @objc dynamic var token: String?
}
