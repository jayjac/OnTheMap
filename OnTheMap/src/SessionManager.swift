//
//  SessionManager.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 26/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation


protocol UdacitySessionDelegate {
    func sessionWasAccepted()
    func sessionReturnedError(_ error: LoginError?)
}


class SessionManager {
    
    private(set) var loginSuccess: LoginSuccess?
    static let `default` = SessionManager()
    
    private init() { }
    


    
    func login(with username: String, password: String, notify delegate: UdacitySessionDelegate) {
        let request = NSMutableURLRequest(url: UdacityAPI.sessionURL)
        NetworkRequestFactory.setupJSONRequest(request, ofType: .post)
        let credentials = ["username": username, "password": password]
        let formattedCredentials = ["udacity": credentials]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: formattedCredentials, options: []) else { return }
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error as NSError? {
                let loginError = LoginError(status: error.code, message: error.localizedDescription)
                DispatchQueue.main.async {
                    delegate.sessionReturnedError(loginError)
                }
                return
            }
            guard let data = NetworkRequestFactory.skipOverFiveCharacters(of: data) else { return }
            guard let obj = try? JSONSerialization.jsonObject(with: data, options: []), let json = obj as? [String: Any] else { return }
            
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
                DispatchQueue.main.async {
                    delegate.sessionWasAccepted()
                }
            }
        }
        task.resume()
    }
    
    
    func logout() {
        let request = NSMutableURLRequest(url: UdacityAPI.sessionURL)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            self.loginSuccess = nil
            //let range = Range(5..<data!.count)
            //let newData = data?.subdata(in: range) /* subset response data! */
            //print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    
}

