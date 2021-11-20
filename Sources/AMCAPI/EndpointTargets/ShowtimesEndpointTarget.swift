//
//  ShowtimesEndpointTarget.swift
//  AMCAPI
//
//  Target and Endpoint definitions for Showtimes.
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import APICore
import Foundation

public extension AMCAPI {
    enum ShowtimesTarget: HTTPTargetType {
        /// Get a showtime by the Showtime Id.
        case getById(id: ShowtimeId)

        /// Get theatre showtimes by date, location, and query parameters.
        case getByDateAndLocation(date: Date, latitude: Double, longitude: Double, queryParams: [String: Any]?)
    }
}

public extension AMCAPI.ShowtimesTarget {
    var path: String {
        switch self {
        case .getById(let id):
            return "/v2/showtimes/\(id.rawValue)"
        case let .getByDateAndLocation(date, latitude, longitude, _):
            return "/v2/showtimes/views/current-location/\(date.stringValue())/\(latitude)/\(longitude)"
        }
    }

    var task: HTTPTask {
        switch self {
        case .getById:
            return .requestPlain
        case let .getByDateAndLocation(_, _, _, params):
            if let queryParams = params {
                return .requestParams(queryParams)
            } else {
                return .requestPlain
            }
        }
    }
}

public extension AMCAPI {
    struct ShowtimesEndpoint: HTTPEndpoint {
        public typealias Target = ShowtimesTarget
        public typealias Model = ShowtimesModel
    }
}

public let showtimesEndpoint = AMCAPI.ShowtimesEndpoint()
