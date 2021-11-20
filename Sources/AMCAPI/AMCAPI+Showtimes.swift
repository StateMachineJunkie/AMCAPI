//
//  AMCAPI+Showtimes.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import APICore
import Combine
import Foundation

extension AMCAPI {

    /// Fetch all showtimes for a given theatre for today or a specific date.
    /// - Parameters:
    ///   - id: Identifiers the specific theatre for which the showtimes are given.
    ///   - date: Filters showtimes by given date. By default, if no date is provided, the current date is used.
    /// - Returns: Publisher of showtimes model.
    func fetchAllShowtimes(forTheatre id: TheatreId, onDate date: Date? = nil) -> AnyPublisher<ShowtimesModel, Swift.Error> {
        do {
            let publisher: URLSession.DataTaskPublisher

            if let date = date {
                publisher = try theatresEndpoint.request(.getAllShowtimesForTheatreOnDate(id: id, date: date))
            } else {
                publisher = try theatresEndpoint.request(.getAllShowtimesForTheatre(id: id))
            }

            return AnyPublisher<ShowtimesModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<ShowtimesModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    /// Fetch showtime by identifier.
    ///
    /// - Parameter id: Identifiers a unique and specific showtime.
    /// - Returns: Publisher of showtime model.
    func fetchShowtime(with id: ShowtimeId) -> AnyPublisher<ShowtimeModel, Swift.Error> {
        do {
            let publisher = try showtimesEndpoint.request(.getById(id: id))
            return AnyPublisher<ShowtimeModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<ShowtimeModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    /// Fetch showtimes for the given date and location.
    ///
    /// Returns all showtimes in proximity to the latitude and longitude for the specified Date and meeting additional
    /// search criteria provided.
    /// - Parameters:
    ///   - date: Date parameter for desired results.
    ///   - location: Latitude and longitude parameter for desired results.
    ///   - queryParams: Dictionary containing optional parameters used to narrow down the result set.
    /// - Returns: Publisher of showtimes model.
    /// - Note: It may be useful to include option query parameters such as `movie`, `movie-id`, `radius`, `city`, and `state`.
    ///         The `state` parameter may be used without `city`, however, the `city`parameter is ignored if `state` is not present.
    func fetchShowtimes(with date: Date, location: (lat: Double, lon: Double), queryParams: [String: Any]? = nil) -> AnyPublisher<ShowtimesModel, Swift.Error> {
        do {
            let publisher = try showtimesEndpoint.request(.getByDateAndLocation(date: date, latitude: location.lat, longitude: location.lon, queryParams: queryParams))
            return AnyPublisher<ShowtimesModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<ShowtimesModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }
}
