//
//  RaceDisplayModel.swift
//  RacesFeature
//
//  Created by Chris Nevin on 18/5/2025.
//

import Core
import Foundation
import SwiftUI

public struct RaceDisplayModel: Identifiable {
    public let id: String
    public let icon: ImageResource
    public let name: String
    public let number: Int
    public let timeElapsed: String
}

extension NextRacesResponse {
    func toDisplayModels(
        allowedCategories: [Category],
        dateProvider: DateProvider
    ) -> [RaceDisplayModel] {
        data.raceSummaries.values
            .filter { allowedCategories.contains($0.category) && $0.validateDate(dateProvider) }
            .sorted { $0.venue.name > $1.venue.name }
            .sorted { $0.advertisedStart < $1.advertisedStart }
            .prefix(5)
            .map {
                RaceDisplayModel.init(
                    id: $0.race.id,
                    icon: $0.category.icon,
                    name: $0.meetingName,
                    number: $0.race.number,
                    timeElapsed: dateProvider.elapsedTime(from: Date(timeIntervalSince1970: $0.advertisedStart))
                )
            }
    }
}

extension Category {
    var icon: ImageResource {
        switch self {
        case .greyhoundRacing: return .greyhound
        case .harnessRacing: return .harness
        case .horseRacing: return .horse
        }
    }

    var title: LocalizedStringKey {
        switch self {
        case .greyhoundRacing: return "Greyhound Racing"
        case .harnessRacing: return "Harness Racing"
        case .horseRacing: return "Horse Racing"
        }
    }
}

private extension RaceSummary {
    func validateDate(_ dateProvider: DateProvider) -> Bool {
        dateProvider.currentDate().addingTimeInterval(-60) < Date(timeIntervalSince1970: advertisedStart)
    }
}
