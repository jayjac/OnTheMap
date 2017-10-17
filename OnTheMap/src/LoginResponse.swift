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

fileprivate let archiveKey = "loginCredentials"
fileprivate let loginSuccessKey = "loginSuccess"

class LoginCredentials: NSObject, NSCoding {
    

    private var loginSuccess: LoginSuccess?

    
    override private init() {

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        if let loginSuccess = aDecoder.decodeObject(forKey: loginSuccessKey) as? LoginSuccess {
            self.loginSuccess = loginSuccess
        }
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(loginSuccess, forKey: loginSuccessKey)
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
