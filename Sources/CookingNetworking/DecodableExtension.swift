//
//  DecodableExtension.swift
//  
//
//  Created by Rob Resma on 11/29/20.
//

import Foundation

public extension Decodable {
    static func decoded<T: Decodable>(_ data: Data) -> T? {
        do {
            return try JSONDecoder.api.decode(
                T.self,
                from: data
            )
        } catch {
            return nil
        }
    }
}
