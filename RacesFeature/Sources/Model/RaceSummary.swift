//
//  RaceSummary.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import Foundation

struct RaceSummary: Decodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case advertisedStart
        case category = "categoryId"
        case meetingId
        case meetingName
    }

    enum AdvertisedStartCodingKeys: CodingKey {
        case seconds
    }

    let advertisedStart: TimeInterval
    let category: Category
    let meetingId: String
    let meetingName: String
    let race: Race
    let venue: Venue

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(
            keyedBy: AdvertisedStartCodingKeys.self,
            forKey: .advertisedStart
        )
        let seconds = try nestedContainer.decode(TimeInterval.self, forKey: .seconds)
        self.advertisedStart = seconds
        self.category = try container.decode(Category.self, forKey: .category)
        self.meetingId = try container.decode(String.self, forKey: .meetingId)
        self.meetingName = try container.decode(String.self, forKey: .meetingName)
        self.race = try Race(from: decoder)
        self.venue = try Venue(from: decoder)
    }
}
