//
//  Race.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import Core
import Foundation

struct Race: Decodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case id = "raceId"
        case name = "raceName"
        case number = "raceNumber"
        case raceForm
    }

    enum AdditionalDataCodingKeys: CodingKey {
        case revealedRaceInfo
    }

    enum RaceFormCodingKeys: String, CodingKey {
        case additionalData
        case comment = "raceComment"
        case commentAlternative = "raceCommentAlternative"
        case distance
        case distanceType
        case silkBaseUrl
        case trackCondition
        case weather
    }

    let id: String
    let additionalData: [String: JSONValue]
    let comment: String?
    let commentAlternative: String?
    let distance: Int
    let distanceType: DistanceType
    let name: String
    let number: Int
    let silkBaseUrl: String
    let trackCondition: TrackCondition?
    let weather: Weather?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        number = try container.decode(Int.self, forKey: .number)
        let nestedContainer = try container.nestedContainer(keyedBy: RaceFormCodingKeys.self, forKey: .raceForm)
        let nestedJSONString = try nestedContainer.decode(String.self, forKey: .additionalData)
        let nestedJSONDecoder = JSONDecoder()
        nestedJSONDecoder.dateDecodingStrategy = .iso8601
        nestedJSONDecoder.keyDecodingStrategy = .convertFromSnakeCase
        additionalData = try nestedJSONDecoder.decode([String: JSONValue].self, from: Data(nestedJSONString.utf8))
        comment = try nestedContainer.decodeIfPresent(String.self, forKey: .comment)
        commentAlternative = try nestedContainer.decodeIfPresent(String.self, forKey: .commentAlternative)
        distance = try nestedContainer.decode(Int.self, forKey: .distance)
        distanceType = try nestedContainer.decode(DistanceType.self, forKey: .distanceType)
        silkBaseUrl = try nestedContainer.decode(String.self, forKey: .silkBaseUrl)
        trackCondition = try nestedContainer.decodeIfPresent(TrackCondition.self, forKey: .trackCondition)
        weather = try nestedContainer.decodeIfPresent(Weather.self, forKey: .weather)
    }
}
