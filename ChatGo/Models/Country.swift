//
//  Country.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import Foundation
import SwiftyJSON

class Country {
    var id: Int = 0
    var code: String = ""
    var name: String = ""
    var currency: String = ""
    
    convenience init(_ data: JSON) {
        self.init()
        self.id = data["id"].intValue
        self.code = data["code"].stringValue
        self.name = data["name"].stringValue
        self.currency = data["currency"].stringValue
    }
}
