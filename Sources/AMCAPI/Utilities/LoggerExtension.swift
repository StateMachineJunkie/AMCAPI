//
//  Logger.swift
//  
//
//  Created by Michael Crawford on 10/19/23.
//

import Foundation
import os.log

private var logger: Logger!

extension Logger {
    /// Log `DecodingError` values that are generated while processing results from AMCAPI requests.
    ///
    /// These log entries will appear in the console under the "AMCAPI" category and will include detailed information
    /// intended to the developer understand exactly whey the associated JSON data did not decode properly.
    ///
    /// - Parameter error: `DecodingError` to be logged
    /// - Note: I consider a `DecoderError` to be a fault in the system because it requires a mistake, either on the
    ///         part of the back-end programmer or the front-end programmer or both, if a single person wrote both
    ///         sides; which, by the way, would be especially embarrassing. 😬🤦‍♂️
    static func logAMCAPIDecodingError(_ error: DecodingError) {
        if logger == nil { logger = Logger(subsystem: "AMCAPI", category: "AMCAPI") }
        switch error {
        case .dataCorrupted(let context), .keyNotFound(_, let context), .typeMismatch(_, let context), .valueNotFound(_, let context):
            logger.fault("\(context.debugDescription)")
        @unknown default:
            logger.fault("\(String(describing: error))")
        }
    }

    /// Log `Error` values that are generated while processing results from AMCAPI requests.
    ///
    /// These log entries will appear in the console under the "AMCAPI" category.
    ///
    /// - Parameter error: Value conforming to `Error` protocol.
    /// - Parameter info: Optional string that will be appended to the error output. Use as you see fit.
    /// - Note: `DecodingError` values should not be logged using this method. Used `logAMCAPIDecodingError` instead.
    static func logAMCAPIError(_ error: Error, withInfo info: String? = nil) {
        if logger == nil { logger = Logger(subsystem: "AMCAPI", category: "AMCAPI") }
        logger.fault("\(String(describing: error))")
    }
}
