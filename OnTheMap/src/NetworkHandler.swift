//
//  NetworkHandler.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 30/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation

protocol UdacitySessionDelegate {
    func sessionWasAccepted(_ response: String)
    func sessionReturnedError(_ error: Error)
}

class NetworkHandler {
    
    static let shared = NetworkHandler()
    
    private init() {
    }

    
    func requestSession(for username: String, with password: String, notify delegate: UdacitySessionDelegate) {
        let request = NSMutableURLRequest(url: UdacityAPI.sessionURL)
        setupRequest(request, ofType: "POST")
        let credentials = ["udacity": ["username": username, "password": password]]
        guard JSONSerialization.isValidJSONObject(credentials), let jsonData = try? JSONSerialization.data(withJSONObject: credentials, options: []) else { return }
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                delegate.sessionReturnedError(error)
                return
            }
            guard let data = data else { return }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            let responseMsg = String(data: newData, encoding: .utf8)!
            delegate.sessionWasAccepted(responseMsg)
        }
        task.resume()
    }
    
    private func setupRequest(_ request: NSMutableURLRequest, ofType method: String = "GET") {
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
}
