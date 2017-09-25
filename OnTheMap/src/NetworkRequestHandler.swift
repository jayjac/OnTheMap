//
//  NetworkHandler.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 30/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation

protocol UdacitySessionDelegate {
    func sessionWasAccepted(_ loginSuccess: LoginSuccess)
    func sessionReturnedError(_ error: LoginError?)
}


enum HTTPMethod: String {
    case get
    case post
    case delete
    case put
    case update
}

class NetworkRequestHandler {
    
    static let shared = NetworkRequestHandler()
    
    //private var sessionId: String?
    
    private init() {}

    
    func requestSession(for username: String, with password: String, notify delegate: UdacitySessionDelegate) {
        let request = NSMutableURLRequest(url: UdacityAPI.sessionURL)
        setupRequest(request, ofType: .post)
        let credentials = ["udacity": ["username": username, "password": password]]
        guard JSONSerialization.isValidJSONObject(credentials), let jsonData = try? JSONSerialization.data(withJSONObject: credentials, options: []) else { return }
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error as NSError? {
                let loginError = LoginError(status: error.code, message: error.localizedDescription)
                DispatchQueue.main.async {
                    delegate.sessionReturnedError(loginError)
                }
                return
            }
            guard let data = data else { return }
            let newData = self.skipOverFiveCharacters(of: data)
            
            guard let obj = try? JSONSerialization.jsonObject(with: newData, options: []), let json = obj as? [String: Any] else { return }
            
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
                DispatchQueue.main.async {
                    delegate.sessionWasAccepted(loginSuccess)
                }
            }
        }
        task.resume()
    }
    
    
    func getStudentLocations() {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue(UdacityAPI.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityAPI.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    private func skipOverFiveCharacters(of data: Data) -> Data {
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range)
        return newData
    }
    
    private func setupRequest(_ request: NSMutableURLRequest, ofType method: HTTPMethod = .get) {
        request.httpMethod = method.rawValue.uppercased()
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
}
