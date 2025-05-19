//
//  Weather.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import Foundation

struct Weather: Decodable, Sendable {
    let id: String
    let iconUri: String
    let name: String
    let shortName: String
}
