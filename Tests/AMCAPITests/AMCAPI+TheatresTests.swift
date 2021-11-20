//
//  AMCAPI+TheatresTests.swift
//  AMCAPITests
//
//  Created by Michael A. Crawford on 9/6/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import XCTest
import Combine
@testable import AMCAPI

/// Unit tests for the Theatres endpoint/target.
/// - Note: Test that fetch information on a theatre based on ID or slug target the AMC Foothills 15 theatre in Tucson.
///         This is a theatre I frequent so it was the first to come to mind as a test case.
final class AMCAPI_TheatresTests: XCTestCase {

    override func setUp() {
        AMCAPI.shared.setVendorAuthKey("Your vendor key from http://developers.amctheatres.com goes here!")
    }

    func testFetchAllTheatres() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch All Theatres")
        AMCAPI.shared.fetchAllTheatres().sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch all theatres. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }

    func testFetchTheatreById() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Theatre by ID")
        let id = AMCAPI.TheatreId(rawValue: 2698)! // AMC Foothills 16
        AMCAPI.shared.fetchTheatre(with: id).sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch threatre by ID. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }

    func testFetchTheatreBySlug() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Theatre by SLUG")
        // FIXME: Missing magic string!
        AMCAPI.shared.fetchTheatre(with: "amc-foothills-15").sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch threatre by SLUG. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }
}
