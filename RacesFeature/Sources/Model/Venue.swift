//
//  Venue.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import Foundation

struct Venue: Decodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id = "venueId"
        case country = "venueCountry"
        case name = "venueName"
        case state = "venueState"
    }
    let id: String
    let country: String
    let name: String
    let state: String
}
