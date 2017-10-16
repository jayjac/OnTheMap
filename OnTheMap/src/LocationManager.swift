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
    private(set) var myLocations = [MyLocation]()
    
    private init() {}
    
    static let `default` = LocationManager()
    
    /** 
     * Retrieves Udacity students' last 100 locations from the server
     */
    func retrieveStudentLocations() {
        if let date = lastRefresh, date.timeIntervalSinceNow > -15 {
            GUI.removeOverlaySpinner()
            return
        }
        
        let url = NetworkRequestFactory.last100StudentLocationsURL()
        let request = NSMutableURLRequest(url: url)
        request.addValue(UdacityAPI.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityAPI.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request as URLRequest) { data, response, error in
            DispatchQueue.main.async {
                GUI.removeOverlaySpinner()
            }
            if let error = error {
                NotificationCenter.default.post(name: .studentLocationsLoadingFailed, object: error)
                return
            }
            guard let results = NetworkRequestFactory.retrieveJSONResponse(from: data, with: "results") else { return }
            self.lastRefresh = Date() //Only remember the date of the last successful request
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
    
    
    func retrieveMyLocations() {
        guard let url = NetworkRequestFactory.myLocationsURL() else { return }
        let request = NSMutableURLRequest(url: url)
        request.addValue(UdacityAPI.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityAPI.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //GUI.showOverlaySpinnerOverMainController()
        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request as URLRequest) { data, response, error in
            DispatchQueue.main.async {
               // GUI.removeOverlaySpinner()
            }
            if let error = error {
                NotificationCenter.default.post(name: .studentLocationsLoadingFailed, object: error)
                return
            }
            guard let results = NetworkRequestFactory.retrieveJSONResponse(from: data, with: "results") else { return }
           
            var myLocations = [MyLocation]()
            for result in results {
                guard let studentInformation = StudentInformation(attributes: result) else { continue }
                let myLocation = MyLocation(location: studentInformation.coordinate, website: studentInformation.mediaURL, mapString: studentInformation.mapString)
                myLocations.append(myLocation)
            }
            self.myLocations = myLocations

            DispatchQueue.main.async {
                //NotificationCenter.default.post(name: .studentLocationsWereLoaded, object: nil)
            }
            
        }
        task.resume()
    }
    
    
}
