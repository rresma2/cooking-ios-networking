//
//  APIRequest.swift
//  
//
//  Created by Rob Resma on 11/29/20.
//

import Foundation
import Alamofire

/// The base request object
open class APIRequest {
    
    /// The endpoint of the API. Specified via the `EndpointRepresentable` protocol.
    private let endpoint: String
    
    /// Any parameters that are passed to the Cooking APIs
    open var parameters = [String: Any]()
    
    /// The HTTPHeaders constructed from cookies
    open var headers: HTTPHeaders
    
    /// The API delegate. Make sure this is set correctly on all instances of `APIRequest`to connect with the server
    public weak var delegate: APIDelegate?
    
    /// Alamofire's data request
    private var request: DataRequest?
    
    /// The URL of the request being made
    public private(set) lazy var url: String = {
        return "http://0.0.0.0:5000/api/" + endpoint
    }()
    
    public init(endpointRepresentable: EndpointRepresentable) {
        endpoint = endpointRepresentable.endpointString
        headers = HTTPCookieStorage.shared.cookieHeaders
    }
    
    /// Call this function to make the request
    public func startService() {
        guard let delegate = delegate else {
            return
        }
        
        request = Session.default.request(
            url,
            method: .post,
            parameters: parameters,
            headers: headers
        )
        request?
            .validate()
            .responseJSON(completionHandler: { [weak self] (dataResponse) in
                guard let self = self else {
                    return
                }
                
                switch dataResponse.result {
                case .success:
                    self.handleSuccess(response: dataResponse, delegate: delegate)
                case .failure:
                    self.handleFailure(response: dataResponse, delegate: delegate)
                }
                
                self.request = nil
        })
    }
    
    /// Call this function to cancel the request
    public func cancel() {
        request?.cancel()
    }
    
    /// A useful operator to add key-value pairs to the parameters dictionary
    public subscript(key: String) -> Any? {
        get {
            return parameters[key]
        }
        
        set {
            guard let newValue = newValue else {
                return
            }
            
            if let newInt = newValue as? Int {
                parameters[key] = String(format: "%i", newInt)
            } else if let newDouble = newValue as? Double {
                parameters[key] = String(format: "%f", newDouble)
            } else if let newString = newValue as? String {
                parameters[key] = newString
            } else if let newBool = newValue as? Bool {
                parameters[key] = newBool ? "true" : "false"
            } else if let newArr = newValue as? [Any] {
                let array = newArr.map { String(describing: $0) }
                parameters[key] = array
            }
        }
    }
}

private extension APIRequest {
    /// Parses cookies from the data response
    func getCookies(from response: AFDataResponse<Any>) -> [HTTPCookie] {
        guard let headerFields = response.response?.allHeaderFields as? [String: String],
              let url = response.response?.url else {
            return []
        }
        
        return HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
    }
    
    /// Handles a successful response
    func handleSuccess(response: AFDataResponse<Any>, delegate: APIDelegate) {
        for cookie in getCookies(from: response) {
            HTTPCookieStorage.shared.cookieAcceptPolicy = .always
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        
        if let result = response.value as? [String: Any] {
            let apiResponse = APIResponse(
                dict: result,
                data: response.data,
                statusCode: response.response?.statusCode
            )
            delegate.didReceiveSuccessResponse(response: apiResponse, request: self)
        }
    }
    
    /// Handles a failed response
    func handleFailure(response: AFDataResponse<Any>, delegate: APIDelegate) {
        for cookie in getCookies(from: response) {
            HTTPCookieStorage.shared.cookieAcceptPolicy = .always
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        
        let statusCode = response.response?.statusCode
        let data = response.data
        
        var dict: [String: Any] = [:]
        var message: String?
        if let failureData = data {
            do {
                if let failureDict = try JSONSerialization.jsonObject(with: failureData) as? [String: Any] {
                    dict = failureDict
                } else if let failureMessage = try JSONSerialization.jsonObject(with: failureData) as? String {
                    message = failureMessage
                }
            } catch {
                
            }
        }
        
        let apiResponse = APIResponse(
            dict: dict,
            data: data,
            message: message,
            statusCode: statusCode
        )
        
        delegate.didReceiveFailureResponse(response: apiResponse, request: self)
    }
}
