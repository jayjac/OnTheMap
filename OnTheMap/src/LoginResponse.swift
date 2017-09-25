//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 20/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation


struct LoginSuccess {
    let key: String
    let sessionId: String
    let expirationDate: Date?
}


struct LoginError {
    let status: Int
    let message: String
}
