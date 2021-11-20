//
//  MoviesEndpointTarget.swift
//	AMCAPI
//
//	Target and Endpoint definitions for Movies.
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import APICore
import Foundation

public extension AMCAPI {
    enum MoviesTarget: HTTPTargetType {
        /// Fetch all Movies.
        case getAll(pageNumber: Int, pageSize: Int)

        /// Get Now Playing Movies.
        case getNowPlaying(pageNumber: Int, pageSize: Int)

        /// Get Advance Ticket Movies.
        case getAdvance

        /// Get Coming Soon Movies.
        case getComingSoon(pageNumber: Int, pageSize: Int)

        /// Get a Movie by the Movie Id.
        case getById(id: MovieId)

        /// Get similar on-demand Movies by the Movie Id.
        case getSimilarOnDemandById(id: Int)

        /// Get all Active and Digital on-demand Movies.
        case getAllActive

        /// Get on-demand Movies.
        case getOnDemand

        /// Get Active Movies.
        case getActive

        /// Get Movie by the Movie Slug (a dash separated title).
        case getBySlug(slug: String)

        /// Get Movie by the internal release Id.
        case getByInternalId(id: Int)
    }
}

public extension AMCAPI.MoviesTarget {
    var path: String {
        switch self {
        case .getAll:
            return "/v2/movies"
        case .getNowPlaying:
            return "/v2/movies/views/now-playing"
        case .getAdvance:
            return "/v2/movies/views/advance"
        case .getComingSoon:
            return "/v2/movies/views/coming-soon"
        case .getById(let id):
            return "/v2/movies/\(id.rawValue)"
        case .getSimilarOnDemandById(let id):
            return "/v2/movies/\(id)/on-demand/similar"
        case .getAllActive:
            return "/v2/movies/views/all/active"
        case .getOnDemand:
            return "/v2/movies/views/on-demand"
        case .getActive:
            return "/v2/movies/views/active"
        case .getBySlug(let slug):
            return "/v2/movies/\(slug)"
        case .getByInternalId(let id):
            return "/v2/movies/internal-release/\(id)"
        }
    }

    var task: HTTPTask {
        switch self {
        case let .getAll(pageNumber, pageSize):
            let today = Date()
            let params: [String : Any] = [
                "page-number" : pageNumber,
                "page-size" : pageSize,
                "start-date" : today.stringValue(),	// Movies released on or before this date.
                "end-date" : today.stringValue()	// Movies released after this date.
            ]
            return HTTPTask.requestParams(params)

        case let .getNowPlaying(pageNumber, pageSize), let .getComingSoon(pageNumber, pageSize):
            let params: [String: Any] = [
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
    struct MoviesEndpoint: HTTPEndpoint {
        public typealias Target = MoviesTarget
        public typealias Model = MoviesModel
    }
}

public let moviesEndpoint = AMCAPI.MoviesEndpoint()
