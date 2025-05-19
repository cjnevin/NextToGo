//
//  JSONDecoder+SnakeCase.swift
//  Core
//
//  Created by Chris Nevin on 18/5/2025.
//

import Foundation

public extension JSONDecoder {
    /// Handles parsing of `snake_case` keys and `ISO-8601` date values.
    static let `default`: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
