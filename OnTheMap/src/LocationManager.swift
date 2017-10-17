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
    private lazy var reverseGeocoder = CLGeocoder()
    
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

        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loadingMyLocationsFailed, object: error)
                }
                return
            }
            guard let results = NetworkRequestFactory.retrieveJSONResponse(from: data, with: "results") else { return }
           
            var myLocations = [MyLocation]()
            for result in results {
                guard let studentInformation = StudentInformation(attributes: result) else { continue }
                let myLocation = MyLocation(objectId: studentInformation.objectId, location: studentInformation.coordinate, website: studentInformation.mediaURL, mapString: studentInformation.mapString)
                myLocations.append(myLocation)
            }
            self.myLocations = myLocations
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .loadingMyLocationsSuccess, object: nil)
            }
            
        }
        task.resume()
    }
    
    func addLocation(with url: String, coordinates: CLLocationCoordinate2D, mapString: String?) {
        var request = URLRequest(url: UdacityAPI.studentLocationURL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        guard let key = SessionManager.default.loginSuccess?.key else { return }
        let myIdentity = SessionManager.default.identity
        let firstName = myIdentity?.firstName ?? ""
        let lastName = myIdentity?.lastName ?? ""

        
        let dictionary: [String: Any] = ["uniqueKey": key, "mapString": mapString ?? "", "mediaURL": url, "latitude": coordinates.latitude, "longitude": coordinates.longitude, "firstName": firstName, "lastName": lastName]
        guard let json = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            fatalError("Malformed JSON in AddURLViewController in -sendURLButtonWasTapped method")
        }

        request.httpBody = json
        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request as URLRequest) { data, response, error in
            GUI.removeOverlaySpinner()
            if let error = error {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .addingLocationFailed, object: error)
                }
                return
            }
            
            let message = String.init(data: data!, encoding: String.Encoding.utf8)
            print(message ?? "no message")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .addingLocationSuccess, object: nil)
            }
            self.retrieveMyLocations()
        }
        task.resume()
    }
    
    func deleteLocation(at index: Int) {
        let locationId = myLocations[index].objectId

        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(locationId)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request) { data, response, error in
            if let error = error { // Handle error…
                print("error trying to delete the link")
                print(error.localizedDescription)
                return
            }
            print("deleted object at index \(index)")
            self.myLocations.remove(at: index)
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .removedMyLocation, object: index)
            }
            
        }
        task.resume()
        
    }
    
    func reverseGeocode(text: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        reverseGeocoder.geocodeAddressString(text, completionHandler: completionHandler)
    }
    
    func cancelGeoCoding() {
        reverseGeocoder.cancelGeocode()
    }
    
    var isGeocoding: Bool {
        return reverseGeocoder.isGeocoding
    }
    
    
}
