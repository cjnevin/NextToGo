//
//  NextRacesError.swift
//  RacesFeature
//
//  Created by Chris Nevin on 19/5/2025.
//

import Foundation

public enum NextRacesError: Error, Sendable {
    case networkError
    case noInternet
    case invalidRequest
    case invalidResponse
}
