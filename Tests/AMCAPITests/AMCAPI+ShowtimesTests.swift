//
//  AMCAPI+ShowtimesTests.swift
//  AMCAPITests
//
//  Created by Michael A. Crawford on 9/6/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import XCTest
import Combine
@testable import AMCAPI

/// - Note: Showtime tests do not pass when using the sandbox URL. They only work with the production URL. This is due
///         to the fact that the sandbox does not have live or simulated showtime data.
final class AMCAPI_ShowtimesTests: XCTestCase {

    override func setUp() {
        AMCAPI.shared.setVendorAuthKey("Your vendor key from http://developers.amctheatres.com goes here!")
    }

    func testFetchAllShowtimesForTheatreOnDate() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Showtimes for Theatre on Date")
        AMCAPI.shared.fetchAllShowtimes(forTheatre: AMCAPI.TheatreId(rawValue: 2698)!, onDate: Date()).sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch showtimes by theatre and date. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { showtimesModel in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20)
    }

    func testFetchShowtimesByDateAndLocation() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Showtimes by Date and Location")
        // These are the lat/lon coords for the "AMC Foothills 15" theatre in Tucson, AZ.
        // I assume the back-end will perform a search within a given radius of these coordinates.
        let location = (lat: 32.341400, lon: -111.015451)
        AMCAPI.shared.fetchShowtimes(with: Date(), location: location).sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch showtimes by date and location. Error: \(error.localizedDescription)")
                expectation.fulfill()
            }
        } receiveValue: { model in
            expectation.fulfill()
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }

    func testFetchShowtimesById() throws {
        var subscriptions = Set<AnyCancellable>()
        let expectation = expectation(description: "Fetch Showtimes for theatre; Fetch Showtime by ID")
        expectation.expectedFulfillmentCount = 2

        func fetchShowtime(with id: AMCAPI.ShowtimeId, completion: @escaping (AMCAPI.ShowtimeModel) -> Void) {
            AMCAPI.shared.fetchShowtime(with: id).sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("Failed to fetch showtime by ID. Error: \(error.localizedDescription)")
                    expectation.fulfill()
                }
            } receiveValue: { model in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        }

        let theatreId = AMCAPI.TheatreId(rawValue: 2698)!

        AMCAPI.shared.fetchAllShowtimes(forTheatre: theatreId).sink { completion in
            if case let .failure(error) = completion {
                XCTFail("Failed to fetch showtimes for theatre \(theatreId). Error: \(error.localizedDescription)")
                // Avoid compound error and delay due to failed API call.
                expectation.fulfill()
                expectation.fulfill()
            }
        } receiveValue: { showtimesModel in
            expectation.fulfill()

            if showtimesModel.embedded.showtimes.count > 0 {
                let originalShowtime = showtimesModel.embedded.showtimes[0]

                fetchShowtime(with: originalShowtime.id) { showtime in
                    XCTAssertEqual(showtime, originalShowtime, "Showtime fetched by ID should match the original data from the `fetchAll` call but it doesn't!")
                }
            } else {
                XCTFail("No showtimes found in returned payload; the code may actually work but without at least one valid show, I can't verify anything.")
                expectation.fulfill()
            }
        }
        .store(in: &subscriptions)
        wait(for: [expectation], timeout: 20.0)
    }
}
