//
//  Races.swift
//  NalinEntainRaces
//
//  Created by Nalin Aswani on 30/03/2025.
//

import Foundation

// MARK: - Races
struct Races: Decodable {
    let status: Int?
    let data: DataClass?
    let message: String?
}

// MARK: - DataClass
struct DataClass: Decodable {
    let nextToGoIDS: [String]?
    let raceSummaries: [String: RaceSummary]?

    enum CodingKeys: String, CodingKey {
        case nextToGoIDS = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

// MARK: - RaceSummary
struct RaceSummary: Decodable, Identifiable {
    let raceID, raceName: String?
    let raceNumber: Int?
    let meetingID, meetingName: String?
    let category: RaceCategory?
    let advertisedStart: AdvertisedStart?
    let raceForm: RaceForm?
    let venueID, venueName, venueState, venueCountry: String?
    
    // Conforming to Identifiable by using raceId as the id or generating a universally unique id.
    var id: String {
        return raceID ?? UUID().uuidString
    }

    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingID = "meeting_id"
        case meetingName = "meeting_name"
        case category = "category_id"
        case advertisedStart = "advertised_start"
        case raceForm = "race_form"
        case venueID = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
}

// MARK: - RaceCategory
/// RaceCategory: CategoryID  be one of 3 known ids. It is decoded  into appropriate known categories. If not it is defaulted to unknown.
enum RaceCategory: String, Decodable, CaseIterable {
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case unknown  // Fallback case for unknown values
    
    var shortName: String {
        switch self {
        case .horse: return "Horse"
        case .harness: return "Harness"
        case .greyhound: return "Greyhound"
        case .unknown: return "Unknown"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = RaceCategory(rawValue: value) ?? .unknown  // Default to .unknown
    }
}

// MARK: - AdvertisedStart
struct AdvertisedStart: Decodable {
    let seconds: TimeInterval?
}

// MARK: - RaceForm
struct RaceForm: Decodable {
    let distance: Int?
    let distanceType: Info?
    let distanceTypeID: String?
    let trackCondition: Info?
    let trackConditionID, raceComment, additionalData: String?
    let generated: Int?
    let silkBaseURL, raceCommentAlternative: String?
    let weather: Info?
    let weatherID: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case distanceType = "distance_type"
        case distanceTypeID = "distance_type_id"
        case trackCondition = "track_condition"
        case trackConditionID = "track_condition_id"
        case raceComment = "race_comment"
        case additionalData = "additional_data"
        case generated
        case silkBaseURL = "silk_base_url"
        case raceCommentAlternative = "race_comment_alternative"
        case weather
        case weatherID = "weather_id"
    }
}

// MARK: - DistanceType
/// This is a reusable Info type. Is used for several objects such as distanceType, TrackCondition and Weather.
struct Info: Decodable {
    let id, name, shortName, iconURI: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case shortName = "short_name"
        case iconURI = "icon_uri"
    }
}
