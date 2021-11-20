//
//  DateDecoder.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 8/27/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation

extension AMCAPI {
    struct DateDecoder {
        /// Date formatter used when the incoming date is not formatted according to the `ISO6801DateFormatter` standard.
        private var altDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.locale = Locale(identifier: "en_US")
            return formatter
        }()

        /// ISO-8601 date formatter used for decoding AMCAPI date strings.
        private var iso8601DateFormatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFractionalSeconds]
            return formatter
        }()

        /// Decode AMC API date strings.
        /// - Parameter dateString: ISO 8601 formatted date.
        /// - Throws: `DecodingError`
        /// - Returns: `Date`
        func decode(dateString: String) throws -> Date {
            if  dateString.hasSuffix("Z") || dateString.contains(".") {
                guard let date = iso8601DateFormatter.date(from: dateString) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "'\(dateString)' is not a valid Date format."))
                }
                return date
            } else {
                guard let date = altDateFormatter.date(from: dateString) else {
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "'\(dateString)' is not a valid Date format."))
                }
                return date
            }
        }
    }
}
