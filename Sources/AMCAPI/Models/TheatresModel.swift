//
//  TheatresModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 9/4/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation

public extension AMCAPI {
    struct EmbeddedTheatresModel: Codable, Equatable {
        let theatres: [TheatreModel]
    }

    struct TheatresModel: Equatable {
        let pageSize: Int
        let pageNumber: Int
        let count: Int
        let links: LinksModel
        let embedded: EmbeddedTheatresModel
    }
}

extension AMCAPI.TheatresModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case pageSize, pageNumber, count
        case links = "_links"
        case embedded = "_embedded"
    }
}
