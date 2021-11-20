//
//  AMCAPI+Movies.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Combine
import Foundation

public extension AMCAPI {
    func fetchActiveMovies() -> AnyPublisher<MoviesModel, Swift.Error> {
        do {
            let publisher = try moviesEndpoint.request(.getActive)
            return AnyPublisher<MoviesModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<MoviesModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    func fetchAdvanceTicketMovies() -> AnyPublisher<MoviesModel, Swift.Error> {
        do {
            let publisher = try moviesEndpoint.request(.getAdvance)
            return AnyPublisher<MoviesModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<MoviesModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    func fetchAllMovies(pageNumber: Int = 1, pageSize: Int = 10) -> AnyPublisher<MoviesModel, Swift.Error> {
        do {
            let publisher = try moviesEndpoint.request(.getAll(pageNumber: pageNumber, pageSize: pageSize))
            return AnyPublisher<MoviesModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<MoviesModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    func fetchComingSoonMovies(pageNumber: Int = 1, pageSize: Int = 10) -> AnyPublisher<MoviesModel, Swift.Error> {
        do {
            let publisher = try moviesEndpoint.request(.getComingSoon(pageNumber: pageNumber, pageSize: pageSize))
            return AnyPublisher<MoviesModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<MoviesModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    func fetchMovie(with id: MovieId) -> AnyPublisher<MovieModel, Swift.Error> {
        do {
            let publisher = try moviesEndpoint.request(.getById(id: id))
            return AnyPublisher<MovieModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<MovieModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    func fetchNowPlayingMovies(pageNumber: Int = 1, pageSize: Int = 10) -> AnyPublisher<MoviesModel, Swift.Error> {
        do {
            let publisher = try moviesEndpoint.request(.getNowPlaying(pageNumber: pageNumber, pageSize: pageSize))
            return AnyPublisher<MoviesModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<MoviesModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }
}
