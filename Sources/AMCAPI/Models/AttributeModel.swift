//
//  AttributeModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 8/26/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation

extension AMCAPI {
    public struct AttributeModel: Codable, Equatable {
        public let code: String
        public let name: String
        public let description: String?
    }
}
