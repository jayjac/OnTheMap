//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 24/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import CoreLocation

struct StudentLocation {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: URL?
    let coordinate: CLLocation?
    let updatedAt: Date?
}


protocol StudentLocationDelegate {
    func studentLocation(didRetrieveLocations locations: [StudentLocation])
    func studentLocation(failedToRetrieveLocations error: NSError)
}
