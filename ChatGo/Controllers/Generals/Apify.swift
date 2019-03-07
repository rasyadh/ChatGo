//
//  Apify.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//


import Alamofire
import Kingfisher
import SwiftyJSON

enum RequestCode {
    case authLogin,
    authRegister,
    refreshToken,
    
    getUser
}

class Apify: NSObject {
    static let shared = Apify()
    var prevOperationData: [String: Any]?
    
    let API_BASE_URL = "https://api.chatapon.com/api"
    
    let API_AUTH_LOGIN = "/login"
    let API_AUTH_REGISTER = "/register"
    let API_REFRESH_TOKEN = ""
    
    let API_USER_PROFILE = "/profile"
    
    // MARK: - Basic functions
    func getHeaders(withAuthorization: Bool, withXApiKey: Bool, accept: String? = nil) -> [String: String] {
        var headers = [String: String]()
        
        // Assign accept properties
        if accept == nil { headers["Accept"] = "application/json" }
        else { headers["Accept"] = accept }
        
        // Assign x-api-key properties
        if withXApiKey { headers["x-api-key"] = "wip0MfUaLW2dx4hyILbvO6oqmITVMpqIhvEg4pko0mY=" }
        
        // Asign authorization properties
        if withAuthorization {
            if let token = UserDefaults.standard.string(forKey: Preferences.tokenLogin) {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        
        return headers
    }
    
    // set request data for fail save
    func setRequestData(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, code: RequestCode) -> [String: Any] {
        // Save request data in case if request is failed due to expired token
        var requestData = [
            "url": url,
            "method": method,
            "code": code
            ] as [String: Any]
        
        if parameters != nil { requestData["parameters"] = parameters }
        if headers != nil { requestData["headers"] = headers }
        
        return requestData
    }
    
    // async request
    func request(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, code: RequestCode) {
        let requestData = setRequestData(url, method: method, parameters: parameters, headers: headers, code: code)
        
        // Perform request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                
                print(response)
                
                switch response.result {
                case .success:
                    print("[ Success ] Request Code: \(code)")
                    print("[ Success ] Status Code: \(response.response!.statusCode)")
                    
                    // URL parsing or pre-delivery functions goes here
                    let responseJSON = try! JSON(data: response.data!)
                    var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                    
                    if !responseJSON["meta"].isEmpty {
                        addData!["meta"] = responseJSON["meta"]
                    }
                    
                    self.consolidation(code, success: true, additionalData: addData)
                case .failure:
                    // Request error parsing
                    print("[ Failed ] Request Code : \(code)")
                    print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription)!)
                    print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.result.value as Any)
                    
                    let statusCode = response.response?.statusCode
                    print("[ Failed ] Status Code: \(String(describing: statusCode))")
                    
                    if let json = JSON(rawValue: response.data as Any) {
                        if statusCode == 401 && code == .getUser {
                            self.prevOperationData = requestData
                            self.refreshToken()
                            return
                        }
                        else {
                            print("[ ERROR ] Error JSON : \(json)")
                            self.consolidation(code, success: false, additionalData: ["json": json])
                            return
                        }
                    }
                    else {
                        if statusCode == 401 {
                            self.prevOperationData = requestData
                            self.refreshToken()
                            return
                        }
                        else {
                            self.consolidation(code, success: false)
                            return
                        }
                    }
                }
        }
    }
    
    // sync request
    func requestSync(_ url: String, method: HTTPMethod, parameters: [String: String]?, headers: [String: String]?, completion: @escaping(_ data: JSON) -> Void) {
        // Perform Request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                // URL parsing or pre-delivery functions goes here
                print("[ SUCCESS ] : Request Synchronous")
                print("[ Success ] Status Code: \(response.response!.statusCode)")
                let responseJSON = try! JSON(data: response.data!)
                completion(responseJSON["data"])
            case .failure:
                // Request error parsing
                print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                print("[ ERROR ] : Result : %@", response.result.value as Any)
                completion(["success": false])
            }
        }
    }
    
    // multipart request
    func uploadRequest(_ url: String, method: HTTPMethod, parameters: [String: String]?, imageParameters: [String: Any]?, headers: [String: String]?, code: RequestCode) {
        // perform multipart request
        upload(multipartFormData: { multipartFormData in
            if let imageParameters = imageParameters {
                guard let imageParam = imageParameters["image"] else { return }
                guard let imageName = imageParameters["name"] else { return }
                guard let imageFieldName = imageParameters["field_name"] else { return }
                
                if let imageData = (imageParam as! UIImage).jpegData(compressionQuality: 0.7) {
                    let imageName = "\(String(describing: imageName)).jpg"
                    multipartFormData.append(imageData, withName: imageFieldName as! String, fileName: imageName, mimeType: "image/jpeg")
                }
            }
            
            if let parameters = parameters {
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: url, method: method, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    print(response)
                    
                    switch response.result {
                    case .success:
                        print("[ SUCCESS ] Request Code : \(code)")
                        
                        // URL parsing or pre-delivery functions goes here
                        let responseJSON = try! JSON(data: response.data!)
                        var addData: [String: Any]? = response.data == nil ? nil : ["json": responseJSON["data"]]
                        
                        if !responseJSON["meta"].isEmpty {
                            addData!["meta"] = responseJSON["meta"]
                        }
                        
                        self.consolidation(code, success: true, additionalData: addData)
                    case .failure:
                        print("[ Failed ] Request Code : \(code)")
                        print("[ Error ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription)!)
                        print("[ ERROR ] : URL : " + (response.request!.url!.absoluteString))
                        print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                        print("[ ERROR ] : Result : %@", response.result.value as Any)
                        
                        // Request Error Handling here
                        if let json = JSON.init(rawValue: response.data as Any) {
                            print("[ ERROR ] Error JSON : \(json)")
                            self.consolidation(code, success: false, additionalData: ["json" : json])
                        }else {
                            self.consolidation(code, success: false)
                        }
                    }
                }
            case .failure(let encodingError):
                print("[ Error ] create request or preorder error : \(encodingError)")
                self.consolidation(code, success: false)
            }
        })
    }
    
    func consolidation(_ requestCode: RequestCode, success: Bool, additionalData: [String: Any]? = nil) {
        var dict = [String: Any]()
        dict["success"] = success
        
        if additionalData != nil {
            for (key, value) in additionalData! {
                dict[key] = value
            }
            
            if !success && dict["json"] != nil {
                if let json = dict["json"] as? JSON {
                    if let error = json["error"].string {
                        dict["error"] = error
                    }
                    
                    if let message = json["message"].string {
                        dict["message"] = message
                    }
                }
            }
        }
        
        switch requestCode {
        // Authentication
        case .authLogin:
            if success { Storify.shared.handleSuccessfullLogin(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.authLogin, sender: self, userInfo: dict) }
        case .authRegister:
            if success { Storify.shared.handleSuccessfullRegister(dict["json"] as! JSON, dict["meta"] as! JSON) }
            else { Notify.post(name: NotifName.authRegister, sender: self, userInfo: dict) }
        case .refreshToken:
            if success {
                print("[ Info ] Token refreshed. Resuming previous operation.")
                Storify.shared.handleRefreshToken(dict["json"] as! JSON)
                
                if prevOperationData != nil {
                    reRequestData(data: prevOperationData)
                }
                
                Notify.post(name: NotifName.refreshToken, sender: self, userInfo: ["success": true])
            }
            else {
                print("[ Info ] Token refresh failed. need to relogin")
                
                let pref = UserDefaults.standard
                pref.set(false, forKey: Preferences.isLoggedIn)
                pref.removeObject(forKey: Preferences.tokenLogin)
                pref.removeObject(forKey: Preferences.userData)
                pref.synchronize()
                Storify.shared.user = nil
                let managerView = ManagerViewController()
                managerView.showLoginScreen(isFromLogout: true)
                
                Notify.post(name: NotifName.refreshToken, sender: self, userInfo: dict)
            }
            
        // User
        case .getUser:
            if success { Storify.shared.storeUser(dict["json"] as! JSON) }
            else { Notify.post(name: NotifName.getUser, sender: self, userInfo: dict) }
        }
    }
    
    func reRequestData(data: [String: Any]?) {
        var requestHeaders = [String: String]()
        if let headers = data!["headers"] as? [String: String] {
            requestHeaders = headers
            for (key, value) in getHeaders(withAuthorization: true, withXApiKey: false) {
                requestHeaders[key] = value
            }
        }
        
        request(
            data!["url"] as! String,
            method: data!["method"] as! HTTPMethod,
            parameters: data!["parameters"] as? [String: String],
            headers: requestHeaders,
            code: data!["code"] as! RequestCode)
    }
    
    func refreshToken() {
        let URL = API_BASE_URL + API_REFRESH_TOKEN
        
        var headers = [String: String]()
        // Assign accept properties
        headers["Accept"] = "application/json"
        // Asign authorization properties
        if let token = UserDefaults.standard.string(forKey: Preferences.tokenRefresh) {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        request(
            URL,
            method: .post,
            parameters: nil,
            headers: headers,
            code: .refreshToken)
    }
}
