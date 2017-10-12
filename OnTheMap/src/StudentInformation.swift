//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 10/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


/*protocol StudentLocationDelegate {
    func studentLocation(didRetrieveLocations locations: [StudentLocation])
    func studentLocation(failedToRetrieveLocations error: NSError)
}*/


struct StudentInformation {
    
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let coordinate: CLLocationCoordinate2D
    let updatedAt: Date?
    
    init?(attributes: [String: Any]) {
        guard let latitude = attributes["latitude"] as? Double,
            let longitude = attributes["longitude"] as? Double else {
            return nil
        }
        self.objectId = attributes["objectId"] as? String
        self.uniqueKey = attributes["uniqueKey"] as? String
        self.firstName = attributes["firstName"] as? String
        self.lastName = attributes["lastName"] as? String
        self.mapString = attributes["mapString"] as? String
        self.mediaURL = attributes["mediaURL"] as? String ?? ""
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let updatedAt = attributes["updatedAt"] as? String
        self.updatedAt = DateFormatter().date(from: updatedAt ?? "")
    }
    
    func openMediaURL() {
        guard let mediaURL = mediaURL, var url = URL(string: mediaURL) else { return }
        if url.scheme == nil {
            var urlComponents = URLComponents(string: mediaURL)!
            urlComponents.scheme = "http"
            url = urlComponents.url!
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            NotificationCenter.default.post(name: .loadingURLErrorNotification, object: url)
        }
    }
}



class StudentLocationAnnotation: NSObject, MKAnnotation {
    
    let studentInformation: StudentInformation
    private(set) var hasPinAlreadyBeenDropped = false
    
    init(studentInformation: StudentInformation) {
        self.studentInformation = studentInformation
        super.init()
    }

    var coordinate: CLLocationCoordinate2D {
        return studentInformation.coordinate
    }
    
    func setPinDropped() {
        hasPinAlreadyBeenDropped = true
    }
}