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

enum LoginStatus {
    case loggedIn
    case loggedOut
}

class LoginCredentials: NSObject, NSCoding {
    
    var status: LoginStatus
    private var loginSuccess: LoginSuccess?
    private static let archiveKey = "loginCredentials"
    
    override private init() {
        status = .loggedOut
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        if let status = aDecoder.decodeObject(forKey: "status") as? LoginStatus,
            let loginSuccess = aDecoder.decodeObject(forKey: "loginSuccess") as? LoginSuccess {
            self.status = status
            self.loginSuccess = loginSuccess
        } else {
            status = .loggedOut
        }
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(status, forKey: "status")
        aCoder.encode(loginSuccess, forKey: "loginSuccess")
    }
    
    static var shared: LoginCredentials {
        guard let data = UserDefaults.standard.object(forKey: archiveKey) as? Data else {
            return LoginCredentials()
        }
        if let credentials = NSKeyedUnarchiver.unarchiveObject(with: data) as? LoginCredentials {
            return credentials
        } else {
            return LoginCredentials()
        }
    }

    
}
