//
//  EndpointTargetType.swift
//  
//
//  Created by Michael A. Crawford on 8/25/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Combine
import Foundation

/// HTTP method associated with a request.
public enum HTTPMethod: String {
    case delete = "DELETE"
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
}

/// HTTP task associated with a request. Mainly used to determine how input and output is handled.
public enum HTTPTask {
    /// No additional data.
	case requestPlain
    /// Data encapsulated within the HTTP request body.
    case requestData(Data)
    /// `Encodable` encapsulated within the HTTP request body.
    case requestJSONEncodable(Encodable)
    /// `Encodable` encapsulated within the HTTP request body; encoded with customized JSON encoder.
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
    /// Encoded parameters encapsulated within the HTTP request body.
    case requestParams([String: Any])
}

public typealias HTTPHeaders = [String: String]

/// Protocol to be implemented by all HTTP targets.
///
/// A target consists of a URL (base and path), optional headers, an HTTP method, and a task. Once this information is
/// provided either explicitly or implicitly via a protocol extension, it may be combined with an endpoint, which uses
/// the target information to execute the request and process the result of the request.
///
public protocol HTTPTargetType {
    var baseURL: URL { get }
    var headers: HTTPHeaders? { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var task: HTTPTask { get }
}

/// Protocol to be implemented by all HTTP endpoints.
///
/// Uses the associated target and decodable types generate a proper URL request and process the HTTP response. As I write
/// this I realize that `HTTPEndpoint` may not be the best name for this protocol. Maybe something like `HTTPRequester` or
/// `RequestProcessor` might be better. Well, I'm not going to worry about that now. If someone raises an issue or comes
/// up a better more compelling name for this, I'll be happy to update the implementation or merge their pull-request.
public protocol HTTPEndpoint {
    associatedtype Target: HTTPTargetType
    associatedtype Model: Decodable
    func request(_ target: Target) throws -> URLSession.DataTaskPublisher
}

public extension HTTPEndpoint {
    /// Common URL request composer for HTTP endpoints.
    ///
    /// Builds and issues a URL request from a given `HTTPTarget` using `URLSession` for implementation.
    ///
    /// - Parameter target: Entity describing the base URL, headers, method, and path for the given request.
    /// - Returns: A *Combine* `DataTaskPublisher` publisher, which is used publish the results of the request.
    func request(_ target: Target) throws -> URLSession.DataTaskPublisher {
        /// Retrieves authorization header(s) from `UserDefaults`.
        ///
        /// We use `UserDefaults` as a mechanism for passing data from the application to the surrounding
        /// internal method. Thus, the mechanism for authentication and authorization is assumed to be handled
        /// and managed externally. This will allow the OAuth scenario or any other authorization method that
        /// requires a special header to be included in order to authorize a given API request.
        /// - Returns: A dictionary containing zero or more HTTP header values, which are included in outgoing
        ///            HTTP requests.
        func getAuthHeaders() -> HTTPHeaders {
            return UserDefaults.standard.object(forKey: "HTTPHeaders") as? HTTPHeaders ?? [:]
        }

        let url: URL
        // For HTTPTask.requestParams tasks, we need to unpack the associated parameters and add them to the URL as
        // query parameters. For every other type of HTTPTask we only need the remaining target parameters to formulate
        // the URL and subsequent URLRequest.
        if case let HTTPTask.requestParams(params) = target.task {
            var urlComponents = URLComponents(url: target.baseURL, resolvingAgainstBaseURL: false)!
            urlComponents.path = target.path
            urlComponents.queryItems = params.queryItems
            url = urlComponents.url!
        } else {
            url = URL(string: target.path, relativeTo: target.baseURL)!
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        urlRequest.httpMethod = target.method.rawValue

        // Include target specific and authorization headers, if applicable.
        if let targetHeaders = target.headers {
            urlRequest.allHTTPHeaderFields = targetHeaders.merging(getAuthHeaders()) { (_, new) in new }
        } else {
            urlRequest.allHTTPHeaderFields = getAuthHeaders()
        }

        switch target.task {
        case .requestPlain, .requestParams:
            break 	// Nothing remaining to be done.
        case .requestData(let data):
            urlRequest.httpBody = data
        case .requestJSONEncodable(let encodable):
            let encoder = JSONEncoder()
            let encodable = AnyEncodable(encodable)
            let data = try encoder.encode(encodable)
            urlRequest.httpBody = data
        case let .requestCustomJSONEncodable(encodable, encoder: encoder):
            let encodable = AnyEncodable(encodable)
            let data = try encoder.encode(encodable)
            urlRequest.httpBody = data
        }
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
    }
}

/// Wrapper for types conforming to `Encodable`. Needed because types using `Encodable` as a generic constraint cannot
/// conform to itself, meaning we can't encode them without knowing the actual type. (At least that's what I think is
/// going on here. There are still plenty of subtleties that I'm picking up along the way when it comes to protocol
/// oriented programming. Again, I'm relying on the Moya project here.
struct AnyEncodable: Encodable {
    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
