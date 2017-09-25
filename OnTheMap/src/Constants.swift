//
//  Constants.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 22/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation

/**
 Udacity API constants
 */
struct UdacityAPI {
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let xAppIDHeader = "X-Parse-Application-Id"
    static let xRestAPIHeader = "X-Parse-REST-API-Key"
    static let endPoint = URL(string: "https://parse.udacity.com/parse")!
    static let sessionURL = URL(string: "https://www.udacity.com/api/session")!
    static let studentLocationURL = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
}
