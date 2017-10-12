//
//  CreateStudentLocationViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 11/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class CreateStudentLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonWasTapped(_ sender: Any) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Sumone\", \"lastName\": \"Incayenne\",\"mapString\": \"Montabo, Cayenne\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 4.93333, \"longitude\": 4.93333 -52.33333}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                print("some error occurred")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }



}
