//
//  File.swift
//  
//
//  Created by Rob Resma on 1/7/21.
//

import Foundation

extension HTTPCookieStorage {
    private var sessionCookieName: String {
        return "session_id"
    }
    
    /// Returns the session cookie
    public var sessionCookie: HTTPCookie? {
        return cookie(for: sessionCookieName)
    }
    
    /// Returns the cookie for the specified name
    public func cookie(for name: String) -> HTTPCookie? {
        return cookies?.first(where: { (cookie: HTTPCookie) -> Bool in
            return cookie.name == name
        })
    }
}
