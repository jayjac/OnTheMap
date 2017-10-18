//
//  MyLocations.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 16/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import CoreLocation
import UIKit

struct MyLocation {
    let objectId: String
    let location: CLLocationCoordinate2D
    let website: String?
    let mapString: String?
    
    func openMWebsiteURL() {
        guard let website = website, var url = URL(string: website) else { return }
        if url.scheme == nil {
            var urlComponents = URLComponents(string: website)!
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
