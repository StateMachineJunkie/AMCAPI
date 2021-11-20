//
//  AMCAPITests.swift
//  AMCAPITests
//
//  Created by Michael A. Crawford on 9/2/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import XCTest
import Combine
@testable import AMCAPI

final class AMCAPITests: XCTestCase {

    func testDateDecoder() throws {
        let dateDecoder = AMCAPI.DateDecoder()
        XCTAssertNoThrow(try dateDecoder.decode(dateString: "2021-08-29T05:00:00Z"))
        XCTAssertNoThrow(try dateDecoder.decode(dateString: "2021-08-29T15:00:00"))
        XCTAssertNoThrow(try dateDecoder.decode(dateString: "2021-08-29T14:55:00.327Z"))
        XCTAssertNoThrow(try dateDecoder.decode(dateString: "2021-08-29T14:55:00.327"))
    }

    func testQueryItemsDictionaryExtension() {
        let params: [String : Any] = [
            "boolParam" : true,
            "doubleParam" : 3.1415926,
            "intParam" : 42,
            "stringParam" : "I sometimes wish I had a coding partner."
        ]
        let queryItems = params.queryItems
        XCTAssertNotNil(queryItems)
        let sortedQueryItems = queryItems!.sorted { $0.name < $1.name }
        XCTAssertEqual(sortedQueryItems.count, 4)
        XCTAssertEqual(sortedQueryItems[0].name, "boolParam")

        var urlComponents = URLComponents(string: "https://test.com")!
        urlComponents.queryItems = sortedQueryItems
        let query = urlComponents.url?.query
        XCTAssertNotNil(query)
        XCTAssertEqual(query!, "boolParam=true&doubleParam=3.1415926&intParam=42&stringParam=I%20sometimes%20wish%20I%20had%20a%20coding%20partner.")
    }

    func testDateExtensions() {
        let components = DateComponents(year: 2021, month: 09, day: 04)
        let calendar = Calendar.current
        let date = calendar.date(from: components)
        XCTAssertNotNil(date)
        let stringValue = date!.stringValue()
        XCTAssertEqual(stringValue, "2021-09-04")
    }

    func testActivityIndicator() {
        var subscriptions = Set<AnyCancellable>()

        let first = URLSession.shared.dataTaskPublisher(for: .init(string: "http://httpbin.org/delay/10")!)
            .tryMap { (data: Data, response: URLResponse) in
                return data
            }

        let second = URLSession.shared.dataTaskPublisher(for: .init(string: "http://httpbin.org/delay/5")!)
            .tryMap { (data: Data, response: URLResponse) in
                return data
            }

        Publishers.Zip(first, second)
            .flatMap { lolo in
                first
            }
            .handleEvents(receiveSubscription: { subscription in
                print("receiveCancel: activityIndicatorView.startAnimating()")
            }, receiveCancel: {
                print("receiveCancel: activityIndicatorView.stopAnimating()")
            })
            .sink { completion in
                print("sink completion: activityIndicatorView.stopAnimating()")
            } receiveValue: { value in
                print(value)
            }
            .store(in: &subscriptions)
    }
}
