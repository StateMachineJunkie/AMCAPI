//
//  MoviesModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 8/25/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation

extension AMCAPI {
    public struct LinkModel: Equatable {
        public let href: String
        public let isTemplated: Bool
    }

    public struct LinksModel: Codable, Equatable {
        public let `self`: LinkModel
        public let next: LinkModel?
    }

    /// A list of Movie Representations returned.
    public struct EmbeddedMoviesModel: Codable, Equatable {
        /// Array of individual Movie Representations.
        public let movies: [MovieModel]
    }

    /// AMC Theatres movie information.
    public struct MoviesModel: Equatable {
        /// The number of results included for each page, up to a maximum of 100. Defaults to 10.
        public let pageSize: Int
        /// The page number returned.
        public let pageNumber: Int
        /// Total number of results across all pages.
        public let count: Int
        public let links: LinksModel
        /// A list of Movie Representations returned.
        public let embedded: EmbeddedMoviesModel
    }
}

extension AMCAPI.LinkModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case href
        case isTemplated = "templated"
    }
}

extension AMCAPI.MoviesModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case pageSize, pageNumber, count
        case links = "_links"
        case embedded = "_embedded"
    }
}
