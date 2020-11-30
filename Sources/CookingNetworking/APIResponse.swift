//
//  APIResponse.swift
//  
//
//  Created by Rob Resma on 11/29/20.
//

import Foundation

/// The base response object
public class APIResponse {
    
    /// The response message
    public private(set) var message: String?
    
    /// A custom status code from the `dict`
    public let code: Int
    
    /// The response dict. Deserialize any custom models via `Decodable` from `data` and use this solely for debugging
    public let dict: [String: Any]
    
    /// The response data. Deserialize any custom models from this
    public let data: Data?
    
    /// The status code from Alamofire
    public let statusCode: Int?
    
    public init(dict: [String: Any] = [:],
                data: Data? = nil,
                message: String? = nil,
                statusCode: Int? = nil) {
        self.message = (dict["message"] as? String) ?? message
        self.code = (dict["code"] as? Int) ?? -1
        self.dict = (dict["data"] as? [String: Any]) ?? [:]
        self.data = (try? JSONSerialization.data(withJSONObject: dict, options: [])) ?? data
        self.statusCode = statusCode
    }
}
