//
//  User.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var id: Int = 0
    var avatar: String = ""
    var name: String = ""
    var username: String = ""
    var email: String = ""
    var phone: String = ""
    var gender = Gender()
    var birth_at: Date!
    var country = Country()
    var activated_at: Date!
    var created_at: Date!
    var updated_at: Date!
    var deleted_at: Date!
    
    convenience init(_ data: JSON) {
        self.init()
        self.id = data["id"].intValue
        self.avatar = data["avatar"].stringValue
        self.name = data["name"].stringValue
        self.username = data["username"].stringValue
        self.email = data["email"].stringValue
        self.phone = data["phone"].stringValue
        self.gender = Gender(data["gender"])
        self.birth_at = data["birth_at"].stringValue.toDate(format: "yyyy-MM-dd") ?? nil
        self.country = Country(data["country"])
        self.activated_at = data["activated_at"].stringValue.toDate(format: "yyyy-MM-dd HH:mm:ss") ?? nil
        self.created_at = data["created_at"].stringValue.toDate(format: "yyyy-MM-dd HH:mm:ss") ?? nil
        self.updated_at = data["updated_at"].stringValue.toDate(format: "yyyy-MM-dd HH:mm:ss") ?? nil
        self.deleted_at = data["deleted_at"].stringValue.toDate(format: "yyyy-MM-dd HH:mm:ss") ?? nil
    }
}
