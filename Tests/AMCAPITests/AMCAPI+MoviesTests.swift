//
//  AMCAPI+MoviesTests.swift
//  AMCAPITests
//
//  Created by Michael A. Crawford on 9/6/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import XCTest
import Combine
@testable import AMCAPI

final class AMCAPI_MoviesTests: XCTestCase {

    override func setUp() {
        AMCAPI.shared.setVendorAuthKey("Your vendor key from http://developers.amctheatres.com goes here!")
    }

    func testFetchActiveMovies() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Active Movies")
        AMCAPI.shared.fetchActiveMovies().sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch active movies. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }

    func testFetchAdvanceTicketMovies() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Advance Ticket Movies")
        AMCAPI.shared.fetchAdvanceTicketMovies().sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch advance ticket movies. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }

    func testFetchAllMovies() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch All Movies")
        AMCAPI.shared.fetchAllMovies().sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch all movies. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }

    func testFetchComingSoonMovies() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Coming-Soon Movies")
        AMCAPI.shared.fetchComingSoonMovies().sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch coming-soon movies. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }

    func testFetchNowPlayingMovies() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Now-Playing Movies")
        AMCAPI.shared.fetchNowPlayingMovies().sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch now-playing movies. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }
}
