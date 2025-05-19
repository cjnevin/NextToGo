//
//  NextRacesResponse.swift
//  RacesFeature
//
//  Created by Chris Nevin on 19/5/2025.
//

import Foundation

public struct NextRacesResponse: Decodable, Sendable {
    public struct RaceData: Decodable, Sendable {
        let nextToGoIds: [String]
        let raceSummaries: [String: RaceSummary]
    }
    public let data: RaceData
    public let message: String
    public let status: Int
}
