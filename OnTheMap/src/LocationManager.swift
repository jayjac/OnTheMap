//
//  LocationManager.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 30/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit



class StudentLocationAnnotation: NSObject, MKAnnotation {
    
    let studentInformation: StudentInformation
    private(set) var hasPinAlreadyBeenDropped = false
    
    // Containes annotations for the last 100 locations uploaded by all students
    fileprivate(set) static var annotationsArray = [StudentLocationAnnotation]()
    

    
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

struct LoadingError: Error {
    
    let description: String
    
    var localizedDescription: String {
        return description
    }
}


class LocationManager {
    
    private var lastRefresh: Date?
    
    /* This model is for the third 'SettingsViewController' screen where I show ALL the locations I added.
     This array is not a subarray of the StudentLocationAnnotation.annotationsArray above.
     I need this model for the table view controller's data source. */
    fileprivate(set) static var myLocationsArray = [MyLocation]()
    private(set) var myLocations = [MyLocation]()
    private lazy var reverseGeocoder = CLGeocoder()
    
    private init() {}

    
    static let `default` = LocationManager()

    
    /** 
     * Retrieves Udacity students' last 100 locations from the server
     */
    func retrieveStudentLocations(force: Bool = false) {
        
        // Prevents flooding the Udacity server by waiting at least 15 seconds between updates
        if !force, let date = lastRefresh, date.timeIntervalSinceNow > -15 {
            GUI.removeOverlaySpinner()
            return
        }
        
        let url = NetworkRequestFactory.last100StudentLocationsURL()
        let request = NetworkRequestFactory.udacityServerRequest(with: url, of: .get, isJSON: false)
        
        // wrong credentials for testing purposes
        /*var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye", forHTTPHeaderField: "X-Parse-Application-Id") // wrong appId on purpose
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")*/
        
        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request) { data, response, error in
            GUI.removeOverlaySpinner()
            if let responseError = NetworkRequestFactory.getErrorFromResponse(error: error, response: response) {
                NotificationCenter.default.post(name: .studentLocationsLoadingFailed, object: responseError)
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
            StudentLocationAnnotation.annotationsArray = studentLocationAnnotations
            DispatchQueue.main.async {
               NotificationCenter.default.post(name: .studentLocationsWereLoaded, object: nil)
            }

        }
        task.resume()
    }
    
    
    func retrieveMyLocations() {
        guard let url = NetworkRequestFactory.myLocationsURL() else { return }
        let request = NetworkRequestFactory.udacityServerRequest(with: url, of: .get, isJSON: false)
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
        guard let key = SessionManager.default.loginSuccess?.key else { return }
        let myIdentity = SessionManager.default.identity
        let firstName = myIdentity?.firstName ?? ""
        let lastName = myIdentity?.lastName ?? ""

        let dictionary: [String: Any] = ["uniqueKey": key, "mapString": mapString ?? "", "mediaURL": url, "latitude": coordinates.latitude, "longitude": coordinates.longitude, "firstName": firstName, "lastName": lastName]
        guard let json = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            fatalError("Malformed JSON in AddURLViewController in -sendURLButtonWasTapped method")
        }

        var request = NetworkRequestFactory.udacityServerRequest(with: UdacityAPI.studentLocationURL, of: .post)
        request.httpBody = json
        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request as URLRequest) { data, response, error in
            GUI.removeOverlaySpinner()
            if let error = error {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .addingLocationFailed, object: error)
                }
                return
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .addingLocationSuccess, object: nil)
            }
            self.retrieveMyLocations()
        }
        task.resume()
    }
    
    
    
    func deleteLocation(at index: Int) {
        let locationId = LocationManager.default.myLocations[index].objectId
        let url = UdacityAPI.studentLocationURL(with: locationId)
        let request = NetworkRequestFactory.udacityServerRequest(with: url, of: .delete, isJSON: true)

        let task = NetworkRequestFactory.urlSessionWithTimeout().dataTask(with: request) { data, response, error in
            if let responseError = NetworkRequestFactory.getErrorFromResponse(error: error, response: response) {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .removedMyLocationFailed, object: responseError)
                }
                return
            }
            //print("deleted object at index \(index)")
            LocationManager.default.myLocations.remove(at: index)
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .removedMyLocation, object: index)
            }
        }
        task.resume()
    }
    
    func reverseGeocode(text: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
        cancelGeoCoding()
        reverseGeocoder.geocodeAddressString(text, completionHandler: completionHandler)
    }
    
    func reverseGeocodeLocation(_ location: CLLocation, completion: @escaping CLGeocodeCompletionHandler) {
        cancelGeoCoding()
        reverseGeocoder.reverseGeocodeLocation(location, completionHandler: completion)
    }
    
    func cancelGeoCoding() {
        reverseGeocoder.cancelGeocode()
    }
    
    var isGeocoding: Bool {
        return reverseGeocoder.isGeocoding
    }
    
    
}
