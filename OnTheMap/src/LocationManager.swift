//
//  LocationManager.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 30/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    private var lastRefresh: Date?
    private(set) var studentLocationAnnotations = [StudentLocationAnnotation]()
    
    private init() {}
    
    static let `default` = LocationManager()
    
    // Retrieve every student's location from the Udacity server
    func retrieveStudentLocations() {
        if let date = lastRefresh, date.timeIntervalSinceNow > -60 {
            print("not refreshing again cause laast refresh was less than a minute ago")
            return
        }
        lastRefresh = Date()
        var urlComponents = URLComponents(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        let orderQueryItem = URLQueryItem(name: "order", value: "-updatedAt")
        let limitQueryItem = URLQueryItem(name: "limit", value: "100")
        urlComponents.queryItems = [orderQueryItem, limitQueryItem]
        let url = urlComponents.url!
        let request = NSMutableURLRequest(url: url)
        request.addValue(UdacityAPI.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityAPI.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                NotificationCenter.default.post(name: .studentLocationsLoadingFailed, object: nil)
                return
            }
            guard let results = NetworkRequestFactory.retrieveJSONResponse(from: data, with: "results") else { return }
            var studentLocationAnnotations = [StudentLocationAnnotation]()
            for result in results {
                guard let studentInformation = StudentInformation(attributes: result) else { continue }
                let annotation = StudentLocationAnnotation(studentInformation: studentInformation)
                studentLocationAnnotations.append(annotation)
            }
            self.studentLocationAnnotations = studentLocationAnnotations
            
            // Interesting fact : annotations are not added immediately if addAnnotations method not called from main thread
            DispatchQueue.main.async {
               NotificationCenter.default.post(name: .studentLocationsWereLoaded, object: nil)
            }
            
            
        }
        task.resume()
    }
    
    
}
