//
//  File.swift
//  
//
//  Created by Rob Resma on 1/7/21.
//

import Foundation
import Alamofire

extension HTTPCookieStorage {
    private var sessionCookieName: String {
        return "session_id"
    }
    
    /// Returns the session cookie
    public var sessionCookie: HTTPCookie? {
        return cookie(for: sessionCookieName)
    }
    
    /// Returns a dictionary of cookie headers
    var cookieHeaders: HTTPHeaders {
        guard let cookies = cookies else {
            return HTTPHeaders([])
        }
        return HTTPHeaders(HTTPCookie.requestHeaderFields(with: cookies))
    }
    
    /// Returns the cookie for the specified name
    public func cookie(for name: String) -> HTTPCookie? {
        return cookies?.first(where: { (cookie: HTTPCookie) -> Bool in
            return cookie.name == name
        })
    }
}
