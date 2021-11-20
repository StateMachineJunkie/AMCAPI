//
//  ShowtimesModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 9/4/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation

extension AMCAPI {
    public struct EmbeddedShowtimesModel: Codable, Equatable {
        public let showtimes: [ShowtimeModel]
    }

    public struct ShowtimesModel: Equatable {
        public let pageSize: Int
        public let pageNumber: Int
        public let count: Int
        public let lastUpdatedDate: Date
        public let links: LinksModel
        public let embedded: EmbeddedShowtimesModel
    }
}

extension AMCAPI.ShowtimesModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case pageSize, pageNumber, count
        case lastUpdatedDate = "lastUpdatedDateUtc"
        case links = "_links"
        case embedded = "_embedded"
    }
}
