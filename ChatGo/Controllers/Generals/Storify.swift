//
//  Storify.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import SwiftyJSON

struct Preferences {
    static let isFirstLaunch = "is_first_launch"
    static let isLoggedIn = "is_logged_in"
    static let tokenLogin = "token_login"
    static let tokenRefresh = "token_refresh"
    static let userData = "user_data"
}

class Storify: NSObject {
    static let shared = Storify()
    
    var page = [String: JSON]()
    
    // User
    var user: User!
    
    // MARK: Authentications
    func handleSuccessfullLogin(_ data: JSON, _ meta: JSON) {
        setUserDefaultInformation(meta)
        storeUserData(data)
        Notify.post(name: NotifName.authLogin, sender: self, userInfo: ["success": true])
    }
    
    func handleSuccessfullRegister(_ data: JSON, _ meta: JSON) {
        setUserDefaultInformation(meta)
        storeUserData(data)
        Notify.post(name: NotifName.authRegister, sender: self, userInfo: ["success": true])
    }
    
    func handleRefreshToken(_ data: JSON) {
        setUserDefaultInformation(data)
    }
    
    private func setUserDefaultInformation(_ meta: JSON) {
        let token = meta["token"].stringValue
        let pref = UserDefaults.standard
        pref.set(true, forKey: Preferences.isLoggedIn)
        pref.set(token, forKey: Preferences.tokenLogin)
        pref.synchronize()
    }
    
    private func storeUserData(_ data: JSON) {
        user = User(data)
        let pref = UserDefaults.standard
        pref.set(["id": user.id, "username": user.username, "name": user.name], forKey: Preferences.userData)
        pref.synchronize()
    }
    
    // MARK: - User
    func storeUser(_ data: JSON) {
        user = User(data)
        Notify.post(name: NotifName.getUser, sender: self, userInfo: ["success": true])
    }
}
