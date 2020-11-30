//
//  APIService.swift
//  
//
//  Created by Rob Resma on 11/29/20.
//

import Foundation

/// A generic service class that wraps around the request / response lifecycle. The steps to interface are listed below
/// 1. Construct a subclass of `APIRequest`
/// 2. Create a response model that conforms to `Decodable` and use its class name as the `Response` type parameter
/// 3. Pass the `APIRequest` into `requestService` along with a success / failure handler
open class APIService<Response: Decodable>: APIDelegate {
    
    /// The API request being made
    public var request: APIRequest?
    
    /// A completion block for external entities to handle successe
    public var completionBlock: ((Response) -> Void)?
    
    /// A failure block for external entities to handle failures
    public var failureBlock: DefaultFailureBlock?
    
    /// Call this to start the request
    public func requestService(request: APIRequest,
                               completionBlock: ((Response) -> Void)? = nil,
                               failureBlock: DefaultFailureBlock? = nil) {
        self.request = request
        request.delegate = self
        self.completionBlock = completionBlock
        self.failureBlock = failureBlock
        request.startService()
    }
    
    // MARK: APIDelegate
    
    /// The implementation of the success handler for `APIDelegate`
    public func didReceiveSuccessResponse(response: APIResponse, request: APIRequest) {
        self.request = nil
        handleSuccess(response: response)
    }
    
    /// The implementation of the failure handler for `APIDelegate`
    public func didReceiveFailureResponse(response: APIResponse, request: APIRequest) {
        self.request = nil
        handleFailure(response: response)
    }
    
    /// Subclasses should override this to handle the response object for the success case
    open func handleSuccess(response: APIResponse) {
        guard let data = response.data,
              let response: Response = .decoded(data) else {
            failureBlock?(.empty)
            return
        }
        
        completionBlock?(response)
    }
    
    /// Subclasses should override this to handle the response object for the failure case
    open func handleFailure(response: APIResponse) {
        failureBlock?(APIError(response: response))
    }
}
