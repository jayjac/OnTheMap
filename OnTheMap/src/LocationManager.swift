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
    
    //private var studentLocations: [StudentLocation]?
    
    private init() {}
    
    static let `default` = LocationManager()
    
    // Retrieve every student's location from the Udacity server
    func retrieveStudentLocations(andNotify delegate: StudentLocationDelegate) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
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
            }
            
            // Interesting fact : annotations are not added immediately if addAnnotations method not called from main thread
            DispatchQueue.main.async {
                delegate.studentLocation(didRetrieveLocations: locations)
            }
            
            
        }
        task.resume()
    }
    
    
}
