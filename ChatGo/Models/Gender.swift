//
//  Gender.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import Foundation
import SwiftyJSON

class Gender {
    var id: Int = 0
    var name: String = ""
    
    convenience init(_ data: JSON) {
        self.init()
        self.id = data["id"].intValue
        self.name = data["name"].stringValue
    }
}
