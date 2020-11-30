//
//  APIError.swift
//  
//
//  Created by Rob Resma on 11/29/20.
//

import Foundation

/// A callback that takes in an `APIError`
public typealias DefaultFailureBlock = (APIError) -> Void

/// The base error object
public class APIError {
    
    /// The message from the API response
    public let message: String?
    
    /// The code from the API response JSON
    public let code: Int
    
    /// The response JSON
    public let extraInfo: [String: Any]
    
    /// The status code from Alamofre
    public let statusCode: Int?
    
    public init(response: APIResponse) {
        self.message = response.message
        self.code = response.code
        self.extraInfo = response.dict
        self.statusCode = response.statusCode
    }
    
    /// Constructs an error object with hardcoded parameters
    public init(message: String? = nil,
                code: Int = -1,
                extraInfo: [String: Any] = [:],
                statusCode: Int? = nil) {
        self.message = message
        self.code = code
        self.extraInfo = extraInfo
        self.statusCode = statusCode
    }
    
    /// Constructs an empty error object
    public static var empty: APIError {
        return APIError()
    }
    
    /// Returns the error message falling back to a specified fallback message then an internal fallback message
    public func message(fallBack: String? = nil) -> String {
        return self.message
            ?? fallBack
            ?? NSLocalizedString("Something went wrong. Please try again later.", comment: "")
    }
}
