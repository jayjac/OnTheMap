//
//  NetworkHandler.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 30/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import CoreLocation
import FacebookCore



enum HTTPMethod: String {
    case get
    case post
    case delete
    case put
    case update
}

/**
 * This class formats requests and responses to / from the Udacity REST-API server
 */
class NetworkRequestFactory {
    
    static let shared = NetworkRequestFactory()

    
    private init() {}
    
    static func setupJSONRequest(_ request: NSMutableURLRequest, ofType method: HTTPMethod = .get) {
        request.httpMethod = method.rawValue.uppercased()
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    
    static func skipOverFiveCharacters(of data: Data?) -> Data? {
        guard let data = data else { return nil }
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range)
        return newData
    }
    
    static func last100StudentLocationsURL() -> URL {
        var urlComponents = URLComponents(url: UdacityAPI.studentLocationURL, resolvingAgainstBaseURL: false)!
        let orderQueryItem = URLQueryItem(name: "order", value: "-updatedAt")
        let limitQueryItem = URLQueryItem(name: "limit", value: "100")
        urlComponents.queryItems = [orderQueryItem, limitQueryItem]
        let url = urlComponents.url!
        return url
    }
    
    static func myLocationsURL() -> URL? {
        guard let uniqueKey = SessionManager.default.loginSuccess?.key else { return nil }
        let condition = ["uniqueKey": uniqueKey]

        guard let data = try? JSONSerialization.data(withJSONObject: condition, options: []), let json = String(data: data, encoding: String.Encoding.utf8) else { return nil }
        
        var urlComponents = URLComponents(url: UdacityAPI.studentLocationURL, resolvingAgainstBaseURL: false)!
        let orderQueryItem = URLQueryItem(name: "order", value: "-updatedAt")
        
        let meQueryItem = URLQueryItem(name: "where", value: json)
        urlComponents.queryItems = [orderQueryItem, meQueryItem]
        let url = urlComponents.url
        return url
    }
    
    static func retrieveJSONResponse(from data: Data?, with attributeName: String) -> [[String: Any]]? {
        guard let data = data, let jsonAny = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonObject = jsonAny as? [String: Any], let results = jsonObject[attributeName] as? [[String: Any]] else { return nil }
        return results
    }
    
    static func parseJSON(from data: Data) -> [String: Any]? {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []), let json = obj as? [String: Any] else
        {
            return nil
        }
        return json
    }
    
    static func formatCredentialsIntoJSONData(username: String, password: String) -> Data? {
        let credentials = ["username": username, "password": password]
        let formattedCredentials = ["udacity": credentials]
        let jsonData = try? JSONSerialization.data(withJSONObject: formattedCredentials, options: [])
        return jsonData
    }
    
    static func formatFacebookTokenIntoJSONData(_ token: String) -> Data? {
        let credentials = ["access_token": token]
        let formattedCredentials = ["facebook_mobile": credentials]
        let jsonData = try? JSONSerialization.data(withJSONObject: formattedCredentials, options: [])
        return jsonData
    }
    
    static func urlSessionWithTimeout(_ timeout: TimeInterval = 8.0) -> URLSession {
        let urlSessionConfig = URLSessionConfiguration.default
        urlSessionConfig.timeoutIntervalForRequest = timeout
        let urlSession = URLSession(configuration: urlSessionConfig)
        return urlSession
    }
    

    
}
