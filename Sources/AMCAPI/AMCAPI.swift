//
//  AMCAPI.swift
//  AMCAPI
//
//  Created by Michael Crawford on 7/5/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import APICore
import Combine
import Foundation

/// This singleton is the one-stop-shop for accessing the API wrappers functions I've created in order to leverage AMC's API.
/// The bulk of its implementation exists in three extensions. One for Movies, one for Showtimes, and one for Theatres.
/// - Note: Whether or not this should really be a reference type instead of a value type makes for an interesting
///         discussion. Logically, value types can't really be singletons because they are easily copied. On the other hand,
///         the one non-static property in `AMCAPI` is itself a reference type; when `AMCAPI` is copied, all copies have
///         a reference to the same instance of said property. In my mind, at least for now, this makes the discussion moot.
///         I'm in the habit of always starting with a struct and only changing it to a class when it becomes obvious that
///         this is necessary in order for my design or solution to work the way I want it to. I'm not saying it is correct.
///         I'm saying it is what it is.
public struct AMCAPI {
    /// Concurrent dispatch queue used to process network requests.
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)

    private static let dateDecoder = DateDecoder()

    /// AMC API dates are all supposed to be in ISO8601 format but some of them do not meet the input standards for
    /// Apple's built-in formatter.
    private static let dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom({ decoder -> Date in
        // Fetch the date string from the container.
        var dateString = try decoder.singleValueContainer().decode(String.self)
        // Test to see if dateString is in iso8601 format. If so, use the iso8601 formatter. If not, use a custom date formatter.
        return try dateDecoder.decode(dateString: dateString)
    })

    /// Returns the common JSON decoder configure for use with the *Movies* endpoint.
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }()

    public func setVendorAuthKey(_ vendorAuthKey: String) {
        UserDefaults.standard.set(["X-AMC-Vendor-Key": vendorAuthKey], forKey: "HTTPHeaders")
    }

    static public private(set) var shared = AMCAPI()

	private init() {}

    /// Common processor for all `HTTPEndpoint` `DataTaskPublisher` results.
    ///
    /// This method is invoked with the a `DataTaskPublisher` produced by entities implementing the `HTTPEndpoint` protocol.
    /// Its purpose is to take care of the common processing of the results from said publisher and convert them to the
    /// publisher data-type or an `Error`, which may be thrown due to a problem with the associated `URLRequest`.
    ///
    /// - Parameter publisher: This is a URL session publisher associated with a request from a `MoviesEndpoint`.
    /// - Returns: Type-erased publisher with either the requested decoded JSON object or an error.
    internal func processPublisherResults<T: Decodable>(_ publisher: URLSession.DataTaskPublisher) -> AnyPublisher<T, Swift.Error> {
        // 1) Make sure the response status is in the acceptable range. If not, try and throw an AMCAPI.Error assuming one
        //    has been provided. If there are no errors, return the data associated with the response.
        // 2) Decode the response data into the requested JSON type.
        // 3) Make the request JSON type available via anonymous publisher.
        publisher.receive(on: apiQueue).tryMap({ element -> Data in
            guard
                let httpResponse = element.response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                    if let errors = try? decoder.decode(AMCAPI.Errors.self, from: element.data) {
                        throw errors
                    } else {
                        throw URLError(.badServerResponse)
                    }
                }
            return element.data
        })
        .decode(type: T.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
}

// This extension provides default values for the HTTPTargetType protocol properties.
public extension HTTPTargetType {
    var baseURL: URL { URL(string: "https://api.amctheatres.com")! }
    var headers: [String: String]? { ["X-AMC-Vendor-Key": "[--Go to http://developers.amctheatres.com--]"] }
    var method: HTTPMethod { .get }
}

public extension AMCAPI {
    /// Error as defined by AMC's API.
    struct Error: Codable, Swift.Error {
        let code: Int
        let message: String?
        let exceptionMessage: String?
        let exceptionType: String?
        let stackTrace: String?
    }

    /// AMC API call return errors in groups of one or more. This structure will contain all associated errors for a
    /// given failed API call.
    struct Errors: Codable, Swift.Error {
        let errors: [AMCAPI.Error]
    }
}

public extension AMCAPI.Error {
    init(code: Int, message: String) {
        self.code = code
        self.message = message
        exceptionType = nil
        exceptionMessage = nil
        stackTrace = nil
    }

    init(error: Swift.Error) {
        self.init(code: -1, message: error.localizedDescription)
    }
}

extension AMCAPI.Error: LocalizedError {
    public var errorDescription: String? {
        return message ?? exceptionMessage ?? NSLocalizedString("The operation couldn’t be completed. (AMCAPI.Error error 1.)", comment: "")
    }
}

extension AMCAPI.Errors: LocalizedError {
    public var errorDescription: String? {
        return errors.first?.localizedDescription ?? NSLocalizedString("The operation couldn’t be completed. (AMCAPI.Errors error 1.)", comment: "")
    }
}
