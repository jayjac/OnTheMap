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

class NetworkRequestFactory {
    
    static let shared = NetworkRequestFactory()
    private(set) var studentLocations: [StudentLocation]?

    
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
    

    
}
