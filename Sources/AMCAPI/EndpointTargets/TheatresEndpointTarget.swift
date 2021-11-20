//
//  TheatresEndpointTarget.swift
//  AMCAPI
//
//  Target and Endpoint definitions for Theatres.
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import APICore
import Foundation

public extension AMCAPI {
    enum TheatresTarget: HTTPTargetType {
        /// Fetch all Theatres.
        case getAll(pageNumber: Int, pageSize: Int)

        /// Fetch all future showtimes for the Theatre with the specified identifier.
        case getAllShowtimesForTheatre(id: TheatreId)

        /// Fetch all future showtimes for the Theatre with the specified identifier on the given date.
        case getAllShowtimesForTheatreOnDate(id: TheatreId, date: Date)

        /// Get a Theatre by the Theatre identifier.
        case getById(id: TheatreId)

        /// Get Theatre by the Theatre Slug (a dash separated title).
        case getBySlug(slug: String)

        /// Fetch all theaters current playing a given movie by its release number.
        case getByNowPlayingReleaseNumber(releaseNumber: Int)
    }
}

public extension AMCAPI.TheatresTarget {
    var path: String {
        switch self {
        case .getAll:
            return "/v2/theatres"
        case .getAllShowtimesForTheatre(let id):
            return "/v2/theatres/\(id.rawValue)/showtimes"
        case let .getAllShowtimesForTheatreOnDate(id, date):
            return "/v2/theatres/\(id.rawValue)/showtimes/\(date.stringValue())"
        case .getById(let id):
            return "/v2/theatres/\(id.rawValue)"
        case .getBySlug(let slug):
            return "/v2/theatres/\(slug)"
        case .getByNowPlayingReleaseNumber(let releaseNumber):
            return "/v2/theatres/views/now-playing/wmm-release-number/\(releaseNumber)"
        }
    }

    var task: HTTPTask {
        switch self {
        case let .getAll(pageNumber, pageSize):
            let params: [String : Any] = [
                "page-number" : pageNumber,
                "page-size" : pageSize
            ]
            return HTTPTask.requestParams(params)

        default:
            return HTTPTask.requestPlain
        }
    }
}

public extension AMCAPI {
    struct TheatresEndpoint: HTTPEndpoint {
        public typealias Target = TheatresTarget
        public typealias Model = TheatresModel
    }
}

public let theatresEndpoint = AMCAPI.TheatresEndpoint()
