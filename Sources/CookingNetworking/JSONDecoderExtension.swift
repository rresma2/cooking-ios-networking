//
//  File.swift
//  
//
//  Created by Rob Resma on 11/29/20.
//

import Foundation

public extension JSONDecoder {
    static let api: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
