//
//  AMCAPI+Theatres.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import APICore
import Combine
import Foundation

extension AMCAPI {

    func fetchAllTheatres(pageNumber: Int = 1, pageSize: Int = 10) -> AnyPublisher<TheatresModel, Swift.Error> {
        do {
            let publisher = try theatresEndpoint.request(.getAll(pageNumber: pageNumber, pageSize: pageSize))
            return AnyPublisher<TheatresModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<TheatresModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    func fetchTheatre(with id: TheatreId) -> AnyPublisher<TheatreModel, Swift.Error> {
        do {
            let publisher = try theatresEndpoint.request(.getById(id: id))
            return AnyPublisher<TheatreModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<TheatreModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }

    func fetchTheatre(with slug: String) -> AnyPublisher<TheatreModel, Swift.Error> {
        do {
            let publisher = try theatresEndpoint.request(.getBySlug(slug: slug))
            return AnyPublisher<TheatreModel, Swift.Error>(processPublisherResults(publisher))
        } catch {
            return Fail<TheatreModel, Swift.Error>(error: error).eraseToAnyPublisher()
        }
    }
}
