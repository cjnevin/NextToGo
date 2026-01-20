//
//  NextRacesEndpointTests.swift
//  RacesFeature
//
//  Created by Chris Nevin on 20/1/2026.
//

import Core
import Foundation
import Testing
@testable import RacesFeature

// To avoid data races on MockURLProtocol we need to serialize these tests.
@Suite(.serialized)
struct NextRacesEndpointTests {
    func makeMockSession(mockStatusCode: Int = 200, mockData: Data, mockNoInternet: Bool = false) async -> URLSession {
        await MockURLProtocol.setHandler { request in
            if mockNoNetwork {
                throw NSError(domain: "NextRacesEndpointTests", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            }
            #expect(request.url?.absoluteString == "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=50")

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: mockStatusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, mockData)
        }
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    func makeJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    @Test
    func fetchNextRaces_success() async throws {
        let sut = await APIManager(
            decoder: makeJSONDecoder(),
            urlSession: makeMockSession(mockData: validMock)
        )

        let response = try await sut.fetchNextRaces()

        #expect(response.status == 200)
        #expect(response.message == "Next 10 horse races")
        #expect(response.data.nextToGoIds == ["09c29c84-bc8f-42cd-9773-ca5885dda69f"])
    }

    @Test
    func fetchNextRaces_decodingError() async throws {
        let sut = await APIManager(
            decoder: makeJSONDecoder(),
            urlSession: makeMockSession(mockData: decodingInvalidMock)
        )

        await #expect(throws: NextRacesError.invalidResponse) {
            try await sut.fetchNextRaces()
        }
    }

    @Test
    func fetchNextRaces_networkError() async throws {
        let sut = await APIManager(
            decoder: makeJSONDecoder(),
            urlSession: makeMockSession(mockStatusCode: 400, mockData: validMock)
        )

        await #expect(throws: NextRacesError.networkError) {
            try await sut.fetchNextRaces()
        }
    }

    @Test
    func fetchNextRaces_networkError() async throws {
        let sut = await APIManager(
            decoder: makeJSONDecoder(),
            urlSession: makeMockSession(mockData: validMock, mockNoInternet: true)
        )

        await #expect(throws: NextRacesError.noInternet) {
            try await sut.fetchNextRaces()
        }
    }
}

// Missing race_id
let decodingInvalidMock = """
{
  "status": 200,
  "data": {
    "next_to_go_ids": [
      "09c29c84-bc8f-42cd-9773-ca5885dda69f",
    ],
    "race_summaries": {
      "09c29c84-bc8f-42cd-9773-ca5885dda69f": {
        "race_name": "5 1/2F Stakes",
        "race_number": 1,
        "meeting_id": "dcf51728-b0ca-4cef-9f8a-1de825e49947",
        "meeting_name": "Prairie Meadows",
        "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
        "advertised_start": { "seconds": 1747436400 },
        "race_form": {
          "distance": 1106,
          "distance_type": {
            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
            "name": "Metres",
            "short_name": "m"
          },
          "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
          "track_condition": {
            "id": "1db9cab0-b747-11ea-80cf-6a390f79827e",
            "name": "Fast",
            "short_name": "fast"
          },
          "track_condition_id": "1db9cab0-b747-11ea-80cf-6a390f79827e",
          "race_comment": "BEAUTIFLY TROUBL'D (1) returns after a spell of eight months...",
          "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Prairie Meadows\\",\\"state\\":\\"IA\\",\\"country\\":\\"USA\\"}}",
          "generated": 1,
          "silk_base_url": "drr38safykj6s.cloudfront.net"
        },
        "venue_id": "79f0ab71-a9ab-49d1-aeb6-7b6d8cf35951",
        "venue_name": "Prairie Meadows",
        "venue_state": "IA",
        "venue_country": "USA"
      },
    }
  },
  "message": "Next 10 horse races"
}
""".data(using: .utf8)!

let validMock = """
{
  "status": 200,
  "data": {
    "next_to_go_ids": [
      "09c29c84-bc8f-42cd-9773-ca5885dda69f",
    ],
    "race_summaries": {
      "09c29c84-bc8f-42cd-9773-ca5885dda69f": {
        "race_id": "09c29c84-bc8f-42cd-9773-ca5885dda69f",
        "race_name": "5 1/2F Stakes",
        "race_number": 1,
        "meeting_id": "dcf51728-b0ca-4cef-9f8a-1de825e49947",
        "meeting_name": "Prairie Meadows",
        "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
        "advertised_start": { "seconds": 1747436400 },
        "race_form": {
          "distance": 1106,
          "distance_type": {
            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
            "name": "Metres",
            "short_name": "m"
          },
          "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
          "track_condition": {
            "id": "1db9cab0-b747-11ea-80cf-6a390f79827e",
            "name": "Fast",
            "short_name": "fast"
          },
          "track_condition_id": "1db9cab0-b747-11ea-80cf-6a390f79827e",
          "race_comment": "BEAUTIFLY TROUBL'D (1) returns after a spell of eight months...",
          "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Prairie Meadows\\",\\"state\\":\\"IA\\",\\"country\\":\\"USA\\"}}",
          "generated": 1,
          "silk_base_url": "drr38safykj6s.cloudfront.net"
        },
        "venue_id": "79f0ab71-a9ab-49d1-aeb6-7b6d8cf35951",
        "venue_name": "Prairie Meadows",
        "venue_state": "IA",
        "venue_country": "USA"
      },
    }
  },
  "message": "Next 10 horse races"
}
""".data(using: .utf8)!
