//
//  Constants.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 22/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

/**
 Udacity API constants
 */
struct UdacityAPI {
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let facebookAPIid = "365362206864879"
    static let xAppIDHeader = "X-Parse-Application-Id"
    static let xRestAPIHeader = "X-Parse-REST-API-Key"
    static let endPoint = URL(string: "https://parse.udacity.com/parse")!
    static let sessionURL = URL(string: "https://www.udacity.com/api/session")!
    static let studentLocationURL = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
    static let udacitySignupURL = URL(string: "https://www.udacity.com/account/auth#!/signup")!
    
    static func facebookProfilePictureURL(for facebookId: String, with size: CGSize = CGSize(width: 50, height: 50)) -> URL {
        let width = size.width
        let height = size.height
        let url = URL(string: "https://graph.facebook.com/v2.10/\(facebookId)/picture?height=\(width)&width=\(height)")
        return url!
    }
    
    static func userInformationURL(id: String) -> URL {
        let url = URL(string: "https://www.udacity.com/api/users/\(id)")!
        return url
    }
}


extension Notification.Name {
    static let loadingURLErrorNotification = Notification.Name("loadingURL")
    static let studentLocationsWereLoaded = Notification.Name("studentLocationsLoaded")
    static let studentLocationsLoadingFailed = Notification.Name("studentLocationsLoadingFailed")
    
    static let logOut = Notification.Name("logOut")
    
    static let addingLocationSuccess = Notification.Name("addingLocationSuccess")
    static let addingLocationFailed = Notification.Name("addingLocationFailed")
    
    static let loadingMyLocationsSuccess = Notification.Name("loadingMyLocationsSuccess")
    static let loadingMyLocationsFailed = Notification.Name("loadingMyLocationsFailed")
    
    static let removedMyLocation = Notification.Name("removedMyLocation")
}
