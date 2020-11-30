//
//  File.swift
//  
//
//  Created by Rob Resma on 11/29/20.
//

import Foundation

/// An interface used to handle API requests
public protocol APIDelegate: AnyObject {
    func didReceiveSuccessResponse(response: APIResponse, request: APIRequest)
    func didReceiveFailureResponse(response: APIResponse, request: APIRequest)
}
