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





struct StudentInformation {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let coordinate: CLLocationCoordinate2D
    let updatedAt: Date?
    
    init?(attributes: [String: Any]) {
        guard let latitude = attributes["latitude"] as? Double,
            let longitude = attributes["longitude"] as? Double, let objectId = attributes["objectId"] as? String else {
            return nil
        }
        self.objectId = objectId
        self.uniqueKey = attributes["uniqueKey"] as? String
        self.firstName = attributes["firstName"] as? String
        self.lastName = attributes["lastName"] as? String
        self.mapString = attributes["mapString"] as? String
        self.mediaURL = attributes["mediaURL"] as? String ?? ""
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let updatedAt = attributes["updatedAt"] as? String
        let dateFormmatter = DateFormatter()
        dateFormmatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormmatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        self.updatedAt = dateFormmatter.date(from: updatedAt ?? "")
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



