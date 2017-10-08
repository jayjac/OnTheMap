//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 24/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class StudentLocation: NSObject, MKAnnotation {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: URL?
    let coordinate: CLLocationCoordinate2D
    let updatedAt: Date?
    private(set) var hasPinAlreadyBeenDropped = false
    
    init(objectId: String, uniqueKey: String?, firstName: String?, lastName: String?, mapString: String?, mediaURL: URL?, coordinate: CLLocationCoordinate2D, updatedAt: Date?) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.coordinate = coordinate
        self.updatedAt = updatedAt
    }
    
    func setPinDropped() {
        hasPinAlreadyBeenDropped = true
    }
}


protocol StudentLocationDelegate {
    func studentLocation(didRetrieveLocations locations: [StudentLocation])
    func studentLocation(failedToRetrieveLocations error: NSError)
}
