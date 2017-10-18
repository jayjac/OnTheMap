//
//  SessionManager.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 26/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

protocol UdacitySessionDelegate {
    func sessionWasAccepted()
    func sessionReturnedError(_ error: LoginError?)
}

struct UserIdentity {
    let firstName: String?
    let lastName: String?
    let facebookId: String?
}

enum LoginMethod {
    case regular
    case facebook
}


class SessionManager {
    
    private(set) var loginSuccess: LoginSuccess?
    static let `default` = SessionManager()
    private(set) var identity: UserIdentity?
    
    private init() { }
    

    /**
     Logs the user in with the given credentials and login method. It then notifies the delegate when information about the login process comes in
     - Parameters:
        - loginMethod: login method to use
           * .regular: credentials have to be 'username' followed by 'password' in that order
           * .facebook: credentials consist of just the facebook authorisation token obtained thru the facebook login manager
        - delegate: the delegate to notify
        - credentials: the login information as described above
     */
    func login(with loginMethod: LoginMethod, notify delegate: UdacitySessionDelegate, credentials: String...) {
        let data: Data?
        switch loginMethod {
        case .regular:
            let username = credentials[0]
            let password = credentials[1]
            data = NetworkRequestFactory.formatCredentialsIntoJSONData(username: username, password: password)

        case .facebook:
            let token = credentials[0]
            data = NetworkRequestFactory.formatFacebookTokenIntoJSONData(token)
        }
        
        guard let jsonData = data else { return }
        var request = NetworkRequestFactory.udacityServerRequest(with: UdacityAPI.sessionURL, of: .post)
        request.httpBody = jsonData
        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            GUI.removeOverlaySpinner()
            if let error = error as NSError? {
                let loginError = LoginError(status: error.code, message: error.localizedDescription)
                DispatchQueue.main.async {
                    delegate.sessionReturnedError(loginError)
                }
                return
            }
            guard let data = NetworkRequestFactory.skipOverFiveCharacters(of: data),
                let json = NetworkRequestFactory.parseJSON(from: data) else { return }
            
            if let errorMsg = json["error"] as? String {
                let status = json["status"] as? Int
                let loginError = LoginError(status: status ?? 404, message: errorMsg)
                DispatchQueue.main.async {
                    delegate.sessionReturnedError(loginError)
                }
            }
            if let account = json["account"] as? [String: Any], let session = json["session"] as? [String: Any] {
                let id = session["id"] as! String
                let expiration = session["expiration"] as! String
                let key = account["key"] as! String
                let dateFormatter = DateFormatter()
                let date = dateFormatter.date(from: expiration)
                let loginSuccess = LoginSuccess(key: key, sessionId: id, expirationDate: date)
                self.loginSuccess = loginSuccess
                self.retrieveUserInfo()
                DispatchQueue.main.async {
                    delegate.sessionWasAccepted()
                }
            }
        }
        task.resume()

    }

    
    func logout() {
        let loginManager = LoginManager()
        loginManager.logOut()
        
        var request = URLRequest(url: UdacityAPI.sessionURL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = NetworkRequestFactory.urlSessionWithTimeout(10.0).dataTask(with: request) { data, response, error in
            GUI.removeOverlaySpinner()
            self.loginSuccess = nil
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .logOut, object: nil)
            } 
        }
        task.resume()
    }
    
    
    /**
     Retrieves the app user's information from the Udacity server
     */
    func retrieveUserInfo() {
        guard let success = loginSuccess else { return }
        let id = success.key
        let request = URLRequest(url: UdacityAPI.userInformationURL(id: id))

        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            guard let newData = NetworkRequestFactory.skipOverFiveCharacters(of: data),
                let json = NetworkRequestFactory.parseJSON(from: newData),
                let user = json["user"] as? [String: Any] else { return }
            let firstName = user["first_name"] as? String
            let lastName = user["last_name"] as? String
            let facebookId = user["_facebook_id"] as? String
            let myIdentity = UserIdentity(firstName: firstName, lastName: lastName, facebookId: facebookId)
            self.identity = myIdentity
        }
        task.resume()
    }
    
    
}

