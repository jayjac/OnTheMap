//
//  NetworkHandler.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 30/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import CoreLocation




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
    

    
}
