//
//  NextRacesEndpoint.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import Core
import Foundation

// swiftlint:disable file_length

public protocol NextRacesEndpoint: Actor {
    func fetchNextRaces() async throws(NextRacesError) -> NextRacesResponse
}

extension APIManager: NextRacesEndpoint {
    public func fetchNextRaces() async throws(NextRacesError) -> NextRacesResponse {
        guard let url = URL(string: "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10") else {
            throw .invalidRequest
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            let apiModel = try decoder.decode(NextRacesResponse.self, from: data)
            return apiModel
        } catch {
            throw .invalidResponse
        }
    }
}

#if DEBUG
final actor MockNextRacesEndpoint: NextRacesEndpoint {
    var nextRacesResult: Result<NextRacesResponse, NextRacesError>

    init(success: Bool = true) {
        if success {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            // swiftlint:disable:next force_try
            let response = try! jsonDecoder.decode(NextRacesResponse.self, from: Data(NextRacesResponse.mock.utf8))
            nextRacesResult = .success(response)
        } else {
            nextRacesResult = .failure(.invalidRequest)
        }
    }

    func fetchNextRaces() async throws(NextRacesError) -> NextRacesResponse {
        try nextRacesResult.get()
    }
}

// swiftlint:disable line_length
extension NextRacesResponse {
    static let mock = """
    {
        "status": 200,
        "data": {
            "next_to_go_ids": [
                "c902069b-70f0-4c64-8d54-b7b1990697ad",
                "f748c418-991b-494c-90de-92465ff64a04",
                "250bf63c-87d5-484a-8957-136260967ecb",
                "2c152680-7b6d-483e-b22b-56a24684ad49",
                "eb297f8a-7c20-49fb-9887-d64a2a04cbdb",
                "2522a10e-8e9c-476b-a2ec-1588036580a6",
                "ebb1ed53-fc85-49c2-bda8-4185300ae5d6",
                "a3b447ae-0ce0-40f9-adfa-7135a0d806bc",
                "09c29c84-bc8f-42cd-9773-ca5885dda69f",
                "e5f2f93c-1f85-445e-a320-fc7b165fb61d"
            ],
            "race_summaries": {
                "09c29c84-bc8f-42cd-9773-ca5885dda69f": {
                    "race_id": "09c29c84-bc8f-42cd-9773-ca5885dda69f",
                    "race_name": "5 1/2F Stakes",
                    "race_number": 1,
                    "meeting_id": "dcf51728-b0ca-4cef-9f8a-1de825e49947",
                    "meeting_name": "Prairie Meadows",
                    "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start": {
                        "seconds": 1747436400
                    },
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
                        "race_comment": "BEAUTIFLY TROUBL'D (1) returns after a spell of eight months. Started the last campaign in good style when in the placings over 1207m at this track. Has switched to the Todd James Jordan stable. One of the genuine hopes in the race. CUPIDS SWEETY (4) returns from a break of eight months. Genuine performer last prep whose most recent appearance resulted in a win over 1106m at this track. Finds the right race to launch another bright campaign. TOMMY'S CRUE (2) returns from a layoff of eight months. Scored over 1006m at this track at the start of last prep. Can make her presence felt. HARD SPIRITS (5) lines up for the first time since September 26. Started the last campaign in good style when in the placings over 1106m at this track. Can make her presence felt. Something for the Multiples: ANCHORS AND SPURS (3)",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Prairie Meadows\\",\\"state\\":\\"IA\\",\\"country\\":\\"USA\\",\\"number\\":1,\\"race_name\\":\\"Race 1 - Starter Allowance\\",\\"time\\":\\"2025-05-16T23:00:00Z\\",\\"class\\":\\"ALLOW\\",\\"start_type\\":\\"\\",\\"prizemonies\\":{\\"total_value\\":59378},\\"localised_prizemonies\\":{\\"AUD\\":{\\"total_value\\":59378},\\"NZD\\":{\\"total_value\\":64128}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Left\\",\\"track_surface\\":\\"Dirt\\",\\"group\\":\\"\\",\\"gait\\":\\"Gallop\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "BEAUTIFLY TROUBL'D (1) returns after a spell of eight months. Started the last campaign in good style when in the placings over 1207m at this track. Has switched to the Todd James Jordan stable. One of the genuine hopes in the race. CUPIDS SWEETY (4) returns from a break of eight months. Genuine performer last prep whose most recent appearance resulted in a win over 1106m at this track. Finds the right race to launch another bright campaign. TOMMY'S CRUE (2) returns from a layoff of eight months. Scored over 1006m at this track at the start of last prep. Can make her presence felt. HARD SPIRITS (5) lines up for the first time since September 26. Started the last campaign in good style when in the placings over 1106m at this track. Can make her presence felt. Something for the Multiples: ANCHORS AND SPURS (3)"
                    },
                    "venue_id": "79f0ab71-a9ab-49d1-aeb6-7b6d8cf35951",
                    "venue_name": "Prairie Meadows",
                    "venue_state": "IA",
                    "venue_country": "USA"
                },
                "250bf63c-87d5-484a-8957-136260967ecb": {
                    "race_id": "250bf63c-87d5-484a-8957-136260967ecb",
                    "race_name": "George E. Mitchell Black-Eyed Susan Stakes (Group 1)",
                    "race_number": 13,
                    "meeting_id": "c4deddbd-3aca-48b3-8f3d-2fdb794bbe62",
                    "meeting_name": "Pimlico",
                    "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start": {
                        "seconds": 1747436100
                    },
                    "race_form": {
                        "distance": 1811,
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
                        "weather": {
                            "id": "08e5f78c-1a36-11eb-9269-cef03e67f1a3",
                            "name": "FINE",
                            "short_name": "fine",
                            "icon_uri": "FINE"
                        },
                        "weather_id": "08e5f78c-1a36-11eb-9269-cef03e67f1a3",
                        "race_comment": "MARGIE'S INTENTION (3) Came on strongly to finish 2nd when beaten by 1 1/4L last start at Fair Grounds and putting a tidy record together so far. One of the major players. REPLY (7) Flashed home late into 2nd last start at Laurel Park. Have to respect the recent stable form. Irad Ortiz Jr is a smart booking. Key player. KINZIE QUEEN (5) Ran home strongly to win last run at Oaklawn Park. Displays very good finishing speed. Very competitive this preparation. Looks to be value. PARIS LILY (6) Gave them all something to chase when winning by a margin of 3/4L last start at Keeneland and good career start. Displays good tactical speed. Could run into the placings.",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Pimlico\\",\\"state\\":\\"MD\\",\\"country\\":\\"USA\\",\\"number\\":13,\\"race_name\\":\\"George E. Mitchell Black-Eyed Susan Stakes (Group 1)\\",\\"time\\":\\"2025-05-16T22:55:00Z\\",\\"class\\":\\"OPEN\\",\\"start_type\\":\\"\\",\\"prizemonies\\":{\\"total_value\\":468750},\\"localised_prizemonies\\":{\\"AUD\\":{\\"1st\\":295312,\\"2nd\\":93750,\\"3rd\\":46875,\\"4th\\":32812,\\"total_value\\":468750},\\"NZD\\":{\\"1st\\":318937,\\"2nd\\":101250,\\"3rd\\":50625,\\"4th\\":35437,\\"total_value\\":506250}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Left\\",\\"track_surface\\":\\"Dirt\\",\\"group\\":\\"\\",\\"gait\\":\\"Gallop\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "MARGIE'S INTENTION (3) Came on strongly to finish 2nd when beaten by 1 1/4L last start at Fair Grounds and putting a tidy record together so far. One of the major players. REPLY (7) Flashed home late into 2nd last start at Laurel Park. Have to respect the recent stable form. Irad Ortiz Jr is a smart booking. Key player. KINZIE QUEEN (5) Ran home strongly to win last run at Oaklawn Park. Displays very good finishing speed. Very competitive this preparation. Looks to be value. PARIS LILY (6) Gave them all something to chase when winning by a margin of 3/4L last start at Keeneland and good career start. Displays good tactical speed. Could run into the placings."
                    },
                    "venue_id": "9687f695-4a58-4b1f-9324-ab41dc93499c",
                    "venue_name": "Pimlico",
                    "venue_state": "MD",
                    "venue_country": "USA"
                },
                "2522a10e-8e9c-476b-a2ec-1588036580a6": {
                    "race_id": "2522a10e-8e9c-476b-a2ec-1588036580a6",
                    "race_name": "Race 4",
                    "race_number": 4,
                    "meeting_id": "6406886f-9ca3-410a-9ee5-39fcd15dcf27",
                    "meeting_name": "Western Fair Raceway",
                    "category_id": "161d9be2-e909-4326-8c2c-35ed71fb460b",
                    "advertised_start": {
                        "seconds": 1747436340
                    },
                    "race_form": {
                        "distance": 1609,
                        "distance_type": {
                            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                            "name": "Metres",
                            "short_name": "m"
                        },
                        "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                        "track_condition": {
                            "id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                            "name": "Good",
                            "short_name": "good"
                        },
                        "track_condition_id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                        "race_comment": "SNAKE EYES HANOVER (9) finished fifth last start over 1609m at this track, beaten 4 metres. Best recent result was a win at Flamboro Downs three starts ago over 1609m. Has to contend with a very wide draw. Won't find this any harder and she can give this a mighty shake. MY ONLY SUNSHINE (2) drew a wide gate last start and was easily accounted for, beaten 6 metres into sixth at this track over 1609m. Sure to enjoy an economical run from this better draw. Primary contender if things go her way. THE HEART VALLEY (8) scored last start over 1609m at this track. Generally runs very well at this circuit so can play a big role again. FASHION FORWARD (4) is worth plenty of thought off a last-start win by 0.3 metres at this track over 1609m.",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Western Fair Raceway\\",\\"state\\":\\"ON\\",\\"country\\":\\"CA\\",\\"number\\":4,\\"race_name\\":\\"Race 4\\",\\"time\\":\\"2025-05-16T22:59:00Z\\",\\"class\\":\\"\\",\\"start_type\\":\\"Mobile\\",\\"prizemonies\\":{\\"total_value\\":5650},\\"localised_prizemonies\\":{\\"AUD\\":{\\"total_value\\":5650},\\"NZD\\":{\\"total_value\\":6102}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Right\\",\\"track_surface\\":\\"All Weather\\",\\"group\\":\\"\\",\\"gait\\":\\"P\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "SNAKE EYES HANOVER (9) finished fifth last start over 1609m at this track, beaten 4 metres. Best recent result was a win at Flamboro Downs three starts ago over 1609m. Has to contend with a very wide draw. Won't find this any harder and she can give this a mighty shake. MY ONLY SUNSHINE (2) drew a wide gate last start and was easily accounted for, beaten 6 metres into sixth at this track over 1609m. Sure to enjoy an economical run from this better draw. Primary contender if things go her way. THE HEART VALLEY (8) scored last start over 1609m at this track. Generally runs very well at this circuit so can play a big role again. FASHION FORWARD (4) is worth plenty of thought off a last-start win by 0.3 metres at this track over 1609m."
                    },
                    "venue_id": "9f90b14e-580d-4106-94fb-f29363df4a4b",
                    "venue_name": "Western Fair Raceway",
                    "venue_state": "ON",
                    "venue_country": "CA"
                },
                "2c152680-7b6d-483e-b22b-56a24684ad49": {
                    "race_id": "2c152680-7b6d-483e-b22b-56a24684ad49",
                    "race_name": "5F Hcap",
                    "race_number": 16,
                    "meeting_id": "2f37af27-f1c4-4d70-a9cf-e2266d1f10fd",
                    "meeting_name": "Santiago",
                    "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start": {
                        "seconds": 1747436100
                    },
                    "race_form": {
                        "distance": 1000,
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
                        "race_comment": "LIDER DIGITAL (5) did little and finished 22 lengths from the winner in 15th over 1200m at Hipodromo Chile last start, a less impressive effort than his fifth at this track the run before. Will enjoy a drop in class so he is one of the main contenders. TANGO MIO (1) finished second at this track two runs back but didn't measure up last time over 1000m at this track, finishing 3.5 lengths back in eighth. Suitably placed so anticipating a big run this time. GITANA GUAPA (7) has been out of the placings in two runs since a break, the latest when seventh, beaten 4 lengths, over 1000m at this track. Cherry-ripe now and is sure to be about the mark. EL CURICANO (10) missed the placings two runs back then didn't do any better last start when 7 lengths away in eighth over 1200m at this track. Suitably placed so can turn things around.",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Santiago\\",\\"state\\":\\"CHI\\",\\"country\\":\\"CHI\\",\\"number\\":16,\\"race_name\\":\\"5F Hcap\\",\\"time\\":\\"2025-05-16T22:55:00Z\\",\\"class\\":\\"HCP\\",\\"start_type\\":\\"\\",\\"prizemonies\\":{\\"total_value\\":3869},\\"localised_prizemonies\\":{\\"AUD\\":{\\"1st\\":2866,\\"2nd\\":573,\\"3rd\\":287,\\"4th\\":143,\\"total_value\\":3869},\\"NZD\\":{\\"1st\\":3095,\\"2nd\\":619,\\"3rd\\":310,\\"4th\\":154,\\"total_value\\":4179}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Right\\",\\"track_surface\\":\\"Dirt\\",\\"group\\":\\"\\",\\"gait\\":\\"Gallop\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "LIDER DIGITAL (5) did little and finished 22 lengths from the winner in 15th over 1200m at Hipodromo Chile last start, a less impressive effort than his fifth at this track the run before. Will enjoy a drop in class so he is one of the main contenders. TANGO MIO (1) finished second at this track two runs back but didn't measure up last time over 1000m at this track, finishing 3.5 lengths back in eighth. Suitably placed so anticipating a big run this time. GITANA GUAPA (7) has been out of the placings in two runs since a break, the latest when seventh, beaten 4 lengths, over 1000m at this track. Cherry-ripe now and is sure to be about the mark. EL CURICANO (10) missed the placings two runs back then didn't do any better last start when 7 lengths away in eighth over 1200m at this track. Suitably placed so can turn things around."
                    },
                    "venue_id": "8a58ddef-bbe6-459f-9656-585543a9cf2f",
                    "venue_name": "Santiago",
                    "venue_state": "CHI",
                    "venue_country": "CHI"
                },
                "a3b447ae-0ce0-40f9-adfa-7135a0d806bc": {
                    "race_id": "a3b447ae-0ce0-40f9-adfa-7135a0d806bc",
                    "race_name": "6F Stakes",
                    "race_number": 5,
                    "meeting_id": "48af6071-baa0-48fe-806b-7d848c6aa5c2",
                    "meeting_name": "Las Americas",
                    "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start": {
                        "seconds": 1747436400
                    },
                    "race_form": {
                        "distance": 1207,
                        "distance_type": {
                            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                            "name": "Metres",
                            "short_name": "m"
                        },
                        "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                        "race_comment": "QUITATE D' AI (1) Game effort to win narrowly last run at this track and can save some energy from the alley. Amongst the placegetters at every start this campaign. Genuine threat. BAMBINA IN FUGA (3) Tidy run when 2nd last run at this track. Has run into the money 2 from 2 attempts this preparation. Has to be strongly considered. KOLENCA (4) Game effort to win narrowly last start at this venue. Has won 2 from 3 starts this preparation. No shock to see a win. GIO MARIA (6) Looked good when 2nd last time at this venue. Has plenty of early speed. One of the hopes.",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Las Americas\\",\\"state\\":\\"BCN\\",\\"country\\":\\"MEX\\",\\"number\\":5,\\"race_name\\":\\"6F Stakes\\",\\"time\\":\\"2025-05-16T23:00:00Z\\",\\"class\\":\\"\\",\\"start_type\\":\\"\\",\\"prizemonies\\":null,\\"localised_prizemonies\\":null,\\"rail_position\\":\\"\\",\\"track_direction\\":\\"\\",\\"track_surface\\":\\"\\",\\"group\\":\\"\\",\\"gait\\":\\"Gallop\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "QUITATE D' AI (1) Game effort to win narrowly last run at this track and can save some energy from the alley. Amongst the placegetters at every start this campaign. Genuine threat. BAMBINA IN FUGA (3) Tidy run when 2nd last run at this track. Has run into the money 2 from 2 attempts this preparation. Has to be strongly considered. KOLENCA (4) Game effort to win narrowly last start at this venue. Has won 2 from 3 starts this preparation. No shock to see a win. GIO MARIA (6) Looked good when 2nd last time at this venue. Has plenty of early speed. One of the hopes."
                    },
                    "venue_id": "b770120b-be68-4ae0-bf68-ac784aaa7955",
                    "venue_name": "Las Americas",
                    "venue_state": "BCN",
                    "venue_country": "MEX"
                },
                "c902069b-70f0-4c64-8d54-b7b1990697ad": {
                    "race_id": "c902069b-70f0-4c64-8d54-b7b1990697ad",
                    "race_name": "Race 1",
                    "race_number": 1,
                    "meeting_id": "fe84e82e-9e12-4472-98ca-589ecd0c643d",
                    "meeting_name": "Yonkers Raceway",
                    "category_id": "161d9be2-e909-4326-8c2c-35ed71fb460b",
                    "advertised_start": {
                        "seconds": 1747435500
                    },
                    "race_form": {
                        "distance": 1609,
                        "distance_type": {
                            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                            "name": "Metres",
                            "short_name": "m"
                        },
                        "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                        "track_condition": {
                            "id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                            "name": "Good",
                            "short_name": "good"
                        },
                        "track_condition_id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Yonkers Raceway\\",\\"state\\":\\"NY\\",\\"country\\":\\"USA\\",\\"number\\":1,\\"race_name\\":\\"Race 1\\",\\"time\\":\\"2025-05-16T22:45:00Z\\",\\"class\\":\\"FMNW5000L5\\",\\"start_type\\":\\"Mobile\\",\\"prizemonies\\":{\\"total_value\\":21875},\\"localised_prizemonies\\":{\\"AUD\\":{\\"total_value\\":21875},\\"NZD\\":{\\"total_value\\":23625}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Right\\",\\"track_surface\\":\\"All Weather\\",\\"group\\":\\"\\",\\"gait\\":\\"P\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net"
                    },
                    "venue_id": "38708866-f2be-47c3-a5c8-fd12cb7b4364",
                    "venue_name": "Yonkers Raceway",
                    "venue_state": "NY",
                    "venue_country": "USA"
                },
                "e5f2f93c-1f85-445e-a320-fc7b165fb61d": {
                    "race_id": "e5f2f93c-1f85-445e-a320-fc7b165fb61d",
                    "race_name": "Premio Enjoy Dubai 2011",
                    "race_number": 14,
                    "meeting_id": "71020b1e-620c-46c8-8bcb-e7967920ae18",
                    "meeting_name": "San Isidro",
                    "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start": {
                        "seconds": 1747436400
                    },
                    "race_form": {
                        "distance": 1200,
                        "distance_type": {
                            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                            "name": "Metres",
                            "short_name": "m"
                        },
                        "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                        "track_condition": {
                            "id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                            "name": "Good",
                            "short_name": "good"
                        },
                        "track_condition_id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                        "weather": {
                            "id": "5ba75165-3cec-11eb-88bb-36fbfdf5d97f",
                            "name": "OCAST",
                            "short_name": "ocast",
                            "icon_uri": "OCAST"
                        },
                        "weather_id": "5ba75165-3cec-11eb-88bb-36fbfdf5d97f",
                        "race_comment": "CURSI ROY RIM (3) was always forward and boxed on to finish third over 1200m at this track last time. Yet to win here at this trip but has never missed the frame from three starts. Fitter and should give a great sight. DONA VANIDAD (5) made her debut last start and was just fair in finishing eighth at this track over 1200m, beaten 5.5 lengths. Progressive type who can play a role. AZZAR RIDE (10) never really threatened when resuming last time out, finishing midfield over 1000m at Palermo. Has the pace to settle in the leading division. Will give backers a great sight. RIDE BEACH (8) is on debut. By Treasure Beach and comes from the Roberto Andres Pellegatta stable. Worth watching for any possible betting push.",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"San Isidro\\",\\"state\\":\\"ARG\\",\\"country\\":\\"ARG\\",\\"number\\":14,\\"race_name\\":\\"Premio Enjoy Dubai 2011\\",\\"time\\":\\"2025-05-16T23:00:00Z\\",\\"class\\":\\"MSW\\",\\"start_type\\":\\"\\",\\"prizemonies\\":{\\"total_value\\":8872},\\"localised_prizemonies\\":{\\"AUD\\":{\\"1st\\":5219,\\"2nd\\":1827,\\"3rd\\":1044,\\"4th\\":522,\\"5th\\":261,\\"total_value\\":8872},\\"NZD\\":{\\"1st\\":5637,\\"2nd\\":1973,\\"3rd\\":1128,\\"4th\\":564,\\"5th\\":282,\\"total_value\\":9582}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Left\\",\\"track_surface\\":\\"Dirt\\",\\"group\\":\\"\\",\\"gait\\":\\"\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "CURSI ROY RIM (3) was always forward and boxed on to finish third over 1200m at this track last time. Yet to win here at this trip but has never missed the frame from three starts. Fitter and should give a great sight. DONA VANIDAD (5) made her debut last start and was just fair in finishing eighth at this track over 1200m, beaten 5.5 lengths. Progressive type who can play a role. AZZAR RIDE (10) never really threatened when resuming last time out, finishing midfield over 1000m at Palermo. Has the pace to settle in the leading division. Will give backers a great sight. RIDE BEACH (8) is on debut. By Treasure Beach and comes from the Roberto Andres Pellegatta stable. Worth watching for any possible betting push."
                    },
                    "venue_id": "686d91ad-e635-40ef-b2db-bac393e38bed",
                    "venue_name": "San Isidro",
                    "venue_state": "ARG",
                    "venue_country": "ARG"
                },
                "eb297f8a-7c20-49fb-9887-d64a2a04cbdb": {
                    "race_id": "eb297f8a-7c20-49fb-9887-d64a2a04cbdb",
                    "race_name": "7 1/2F Stakes",
                    "race_number": 2,
                    "meeting_id": "ff37aacc-921e-439c-afb8-9786fa328473",
                    "meeting_name": "Evangeline Downs",
                    "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start": {
                        "seconds": 1747436220
                    },
                    "race_form": {
                        "distance": 1509,
                        "distance_type": {
                            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                            "name": "Metres",
                            "short_name": "m"
                        },
                        "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                        "track_condition": {
                            "id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                            "name": "Good",
                            "short_name": "good"
                        },
                        "track_condition_id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                        "race_comment": "AOIDE (2) is back after a break of five months. At the last run before the layoff he finished tenth over 1609m in stakes class at Fairgrounds (Dirt). Has ability and can get off the mark. M L BRODY'S GEM (6) has put together back-to-back placings, the latest when 4 lengths away in third over 1207m at this track (Dirt) when he was in the firing line all the way. Best figures measure up. Sure to run well. GEM OF A STORM (7) returns after three months in the paddock. Closed the last campaign with a tenth over 1609m at Fairgrounds (Turf). Rates highly and is a chance to break through. EQUAL FORCE (1) finished out of the money on debut two starts back then he got a long way back and was beaten 16 lengths when sixth over 1106m at this track four weeks ago. Likely improver with strong prospects.",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Evangeline Downs\\",\\"state\\":\\"LA\\",\\"country\\":\\"USA\\",\\"number\\":2,\\"race_name\\":\\"Race 2 - Maiden Claiming\\",\\"time\\":\\"2025-05-16T22:57:00Z\\",\\"class\\":\\"MDN CLM\\",\\"start_type\\":\\"\\",\\"prizemonies\\":{\\"total_value\\":28125},\\"localised_prizemonies\\":{\\"AUD\\":{\\"total_value\\":28125},\\"NZD\\":{\\"total_value\\":30375}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Left\\",\\"track_surface\\":\\"Turf\\",\\"group\\":\\"\\",\\"gait\\":\\"Gallop\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "AOIDE (2) is back after a break of five months. At the last run before the layoff he finished tenth over 1609m in stakes class at Fairgrounds (Dirt). Has ability and can get off the mark. M L BRODY'S GEM (6) has put together back-to-back placings, the latest when 4 lengths away in third over 1207m at this track (Dirt) when he was in the firing line all the way. Best figures measure up. Sure to run well. GEM OF A STORM (7) returns after three months in the paddock. Closed the last campaign with a tenth over 1609m at Fairgrounds (Turf). Rates highly and is a chance to break through. EQUAL FORCE (1) finished out of the money on debut two starts back then he got a long way back and was beaten 16 lengths when sixth over 1106m at this track four weeks ago. Likely improver with strong prospects."
                    },
                    "venue_id": "9eb22211-f026-45cc-8c5e-10273469b247",
                    "venue_name": "Evangeline Downs",
                    "venue_state": "LA",
                    "venue_country": "USA"
                },
                "ebb1ed53-fc85-49c2-bda8-4185300ae5d6": {
                    "race_id": "ebb1ed53-fc85-49c2-bda8-4185300ae5d6",
                    "race_name": "Race 1 - Maiden Claiming",
                    "race_number": 1,
                    "meeting_id": "3dfe5ea9-db49-4e2d-bb0b-a2f2441b82b4",
                    "meeting_name": "Remington Park",
                    "category_id": "4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start": {
                        "seconds": 1747436400
                    },
                    "race_form": {
                        "distance": 320,
                        "distance_type": {
                            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                            "name": "Metres",
                            "short_name": "m"
                        },
                        "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                        "track_condition": {
                            "id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                            "name": "Good",
                            "short_name": "good"
                        },
                        "track_condition_id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                        "weather": {
                            "id": "5ba75165-3cec-11eb-88bb-36fbfdf5d97f",
                            "name": "OCAST",
                            "short_name": "ocast",
                            "icon_uri": "OCAST"
                        },
                        "weather_id": "5ba75165-3cec-11eb-88bb-36fbfdf5d97f",
                        "race_comment": "TURNPIKERS EAGLE (6) Ran home into 3rd last run at this track. Displays good tactical speed. Jesus Rios Ayala rates highly. Amongst the placegetters at every start this campaign. Capable of taking this out. HES PAINTED HOT (9) Didn't find the line when 6th last start at the track. Happy to forgive that run. Should be rolling forward early from the wide draw. Won't be far away. PASATIEMPO (2) Narrowly denied a win last time here and has a good draw. Respect. LACHISMOSA (5) Moved ahead of some to finish 5th last run here. Should jump out and bowl along. Not without claims.",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Remington Park\\",\\"state\\":\\"OK\\",\\"country\\":\\"USA\\",\\"number\\":1,\\"race_name\\":\\"Race 1 - Maiden Claiming\\",\\"time\\":\\"2025-05-16T23:00:00Z\\",\\"class\\":\\"MDN CLM\\",\\"start_type\\":\\"\\",\\"prizemonies\\":{\\"total_value\\":14062},\\"localised_prizemonies\\":{\\"AUD\\":{\\"total_value\\":14062},\\"NZD\\":{\\"total_value\\":15187}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Left\\",\\"track_surface\\":\\"Dirt\\",\\"group\\":\\"\\",\\"gait\\":\\"Gallop\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net",
                        "race_comment_alternative": "TURNPIKERS EAGLE (6) Ran home into 3rd last run at this track. Displays good tactical speed. Jesus Rios Ayala rates highly. Amongst the placegetters at every start this campaign. Capable of taking this out. HES PAINTED HOT (9) Didn't find the line when 6th last start at the track. Happy to forgive that run. Should be rolling forward early from the wide draw. Won't be far away. PASATIEMPO (2) Narrowly denied a win last time here and has a good draw. Respect. LACHISMOSA (5) Moved ahead of some to finish 5th last run here. Should jump out and bowl along. Not without claims."
                    },
                    "venue_id": "4ac3cc01-c5bf-4eab-a8e3-e130b11ad8f4",
                    "venue_name": "Remington Park",
                    "venue_state": "OK",
                    "venue_country": "USA"
                },
                "f748c418-991b-494c-90de-92465ff64a04": {
                    "race_id": "f748c418-991b-494c-90de-92465ff64a04",
                    "race_name": "Race 2",
                    "race_number": 2,
                    "meeting_id": "fa7b0c7b-281c-42d9-b152-c73d7ab74a15",
                    "meeting_name": "Hoosier Park",
                    "category_id": "161d9be2-e909-4326-8c2c-35ed71fb460b",
                    "advertised_start": {
                        "seconds": 1747435680
                    },
                    "race_form": {
                        "distance": 1609,
                        "distance_type": {
                            "id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                            "name": "Metres",
                            "short_name": "m"
                        },
                        "distance_type_id": "570775ae-09ec-42d5-989d-7c8f06366aa7",
                        "track_condition": {
                            "id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                            "name": "Good",
                            "short_name": "good"
                        },
                        "track_condition_id": "10a14653-a33d-11e7-810d-0a1a4ae29bd2",
                        "additional_data": "{\\"revealed_race_info\\":{\\"track_name\\":\\"Hoosier Park\\",\\"state\\":\\"IN\\",\\"country\\":\\"USA\\",\\"number\\":2,\\"race_name\\":\\"Race 2\\",\\"time\\":\\"2025-05-16T22:48:00Z\\",\\"class\\":\\"MsNaughFNL\\",\\"start_type\\":\\"Mobile\\",\\"prizemonies\\":{\\"total_value\\":39062},\\"localised_prizemonies\\":{\\"AUD\\":{\\"total_value\\":39062},\\"NZD\\":{\\"total_value\\":42187}},\\"rail_position\\":\\"\\",\\"track_direction\\":\\"Left\\",\\"track_surface\\":\\"All Weather\\",\\"group\\":\\"\\",\\"gait\\":\\"T\\",\\"track_home_straight_metres\\":0,\\"track_circumference\\":0}}",
                        "generated": 1,
                        "silk_base_url": "drr38safykj6s.cloudfront.net"
                    },
                    "venue_id": "4f7d90ce-9d88-4bdd-9b78-3f0199b1afcd",
                    "venue_name": "Hoosier Park",
                    "venue_state": "IN",
                    "venue_country": "USA"
                }
            }
        },
        "message": "Next 10 races from each category"
    }
    """
}
// swiftlint:enable line_length
#endif
