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
    private(set) var studentLocations = [StudentLocation]()
    
    private init() {}
    
    static let `default` = LocationManager()
    
    // Retrieve every student's location from the Udacity server
    func retrieveStudentLocations() {
        if let date = lastRefresh, date.timeIntervalSinceNow > -60 {
            print("not refreshing again cause laast refresh was less than a minute ago")
            return
        }
        //print("refreshing")
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
                return
            }
            guard let data = data, let jsonAny = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonObject = jsonAny as? [String: Any], let results = jsonObject["results"] as? [[String: Any]] else { return }
            
            var locations = [StudentLocation]()
            for result in results {
                /*print(result)
                print("-----------")*/
                guard let latitude = result["latitude"] as? Double, let longitude = result["longitude"] as? Double else { continue }
                let id = result["objectId"] as! String
                let uniqueKey = result["uniqueKey"] as? String
                let firstName = result["firstName"] as? String
                let lastName = result["lastName"] as? String
                let mapString = result["mapString"] as? String
                let mediaURL: String = result["mediaURL"] as? String ?? ""
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let updatedAt = result["updatedAt"] as? String
                let date = DateFormatter().date(from: updatedAt ?? "")
                let location = StudentLocation(objectId: id, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: URL(string: mediaURL), coordinate: coordinate, updatedAt: date)
                locations.append(location)
                self.studentLocations = locations
            }
            
            // Interesting fact : annotations are not added immediately if addAnnotations method not called from main thread
            DispatchQueue.main.async {
               NotificationCenter.default.post(name: .studentLocationsWereLoaded, object: nil)
            }
            
            
        }
        task.resume()
    }
    
    
}
