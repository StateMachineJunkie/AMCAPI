//
//  TheatreModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation
import os.log

extension AMCAPI {
    /// See the description for `MovieId`.
    public struct TheatreId: Codable, Equatable, Hashable, RawRepresentable {
        public typealias RawValue = Int
        public var rawValue: RawValue

        public init?(rawValue: RawValue) {
            self.rawValue = rawValue
        }
    }

    public struct TheatreModel: Equatable {
        public struct Closure: Codable, Equatable {
            public let startDateTimeUtc: Date
            public let endDateTimeUtc: Date?
        }

        public struct Location: Codable, Equatable {
            public let addressLine1: String
            public let addressLine2: String?
            public let city: String
            public let postalCode: String
            public let state: String
            public let stateName: String
            public let country: String
            public let latitude: Double
            public let longitude: Double
            public let marketName: String
            public let marketId: Int
            public let cityUrlSuffixText: String?
            public let stateUrlSuffixText: String?
            public let marketUrlSuffixText: String?
            /// The URL for an image of a map to be used for directions to the theatre.
            public let directionsUrl: URL?
        }

        public struct Media: Codable, Equatable {
            public let theatreImageIcon: URL
            public let theatreImageStandard: URL
            public let theatreImageThumbnail: URL
            public let theatreImageLarge: URL
            public let heroDesktopDynamic: URL
            public let heroMobileDynamic: URL
            public let interiorDynamic: URL
            public let exteriorDynamic: URL
            public let promotionDynamic: URL
        }

        public enum ConcessionDeliveryOption: String, Equatable, CaseIterable {
            case deliveryToSeat = "DeliveryToSeat"
            case expressPickup = "ExpressPickup"
        }

        /// The theatre identifier.
        public let id: TheatreId

        /// The name of the theatre.
        public let name: String

        /// The long name of the theatre
        public let longName: String

        /// The guest services phone number.
        public let guestServicesPhoneNumber: String

        /// The current UTC offset of the theatre's timezone.
        public let utcOffset: String

        /// The timezone where the theatre is located.
        public let timezone: String

        /// The theatre slug.
        public let slug: String

        /// The URL for the theatre's fan page on FaceBook.
        public let facebookURL: URL?

        /// The reason the theatre is temporarily closed if applicable.
        public let outageDescription: String?

        /// The website URL for the theatre on amctheatres.com
        public let websiteURL: URL?

        /// The version of AMC's loyalty program offered by the theatre.
        public let loyaltyVersionId: Int

        /// An indicator that the theatre is closed.
        public let isClosed: Bool

        /// A list of theatre closures.
        public let closures: [Closure]

        /// The date that the theatre closed.
        public let lastBusinessDate: Date?

        public let ticketable: String

        /// A list of theatre attributes.
        public let attributes: [AttributeModel]

        /// The theatre's location info.
        public let location: Location

        public let media: Media

        /// A list of redemption methods supported by the theatre.
        public let redemptionMethods: [String]

        /// The West World Media theatre number.
        public let westWorldMediaNumber: Int?

        /// A list of Concession Delivery Options
        public let concessionsDeliveryOptions: [ConcessionDeliveryOption]

        /// Tax rate percentage at which convenience fee tax is calculated. Used if flat tax is zero.
        public let convenienceFeeTaxPercent: Double

        /// Flat tax amount for convenience fee.
        public let convenienceFeeTaxFlatAmount: Double

        /// Theatre's brand abbreviation (AMC, DIT, Classic).
        public let brand: String

        /// An indicator that signifies the theatre's tier level.
        public let subscriptionUsageLevel: Int

        /// Indicates whether the theatre supports ordering online concessions.
        public let onlineConcessions: Bool

        /// Indicates whether the theatre has multiple kitchens used for express pickup concession orders.
        public let hasMultipleKitchens: Bool

        public let deliveryToSeat: Bool
    }
}

extension AMCAPI.TheatreModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, name, longName, guestServicesPhoneNumber, utcOffset, timezone, slug, outageDescription, loyaltyVersionId,
             isClosed, closures, lastBusinessDate, ticketable, attributes, location, media, redemptionMethods, westWorldMediaNumber,
             concessionsDeliveryOptions, convenienceFeeTaxPercent, convenienceFeeTaxFlatAmount, brand, subscriptionUsageLevel,
             onlineConcessions, hasMultipleKitchens, deliveryToSeat
        case facebookURL = "facebookUrl"
        case websiteURL = "websiteUrl"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            // Decode built-in and supported types.
            id                              = try container.decode(AMCAPI.TheatreId.self, forKey: .id)
            name                            = try container.decode(String.self, forKey: .name)
            longName	                    = try container.decode(String.self, forKey: .longName)
            guestServicesPhoneNumber		= try container.decode(String.self, forKey: .guestServicesPhoneNumber)
            utcOffset						= try container.decode(String.self, forKey: .utcOffset)
            timezone						= try container.decode(String.self, forKey: .timezone)
            slug							= try container.decode(String.self, forKey: .slug)
            facebookURL						= try container.decodeIfPresent(URL.self, forKey: .facebookURL)
            outageDescription				= try container.decodeIfPresent(String.self, forKey: .outageDescription)
            websiteURL						= try container.decodeIfPresent(URL.self, forKey: .websiteURL)
            loyaltyVersionId				= try container.decode(Int.self, forKey: .loyaltyVersionId)
            isClosed                        = try container.decodeIfPresent(Bool.self, forKey: .isClosed) ?? false
            closures						= try container.decode([Closure].self, forKey: .closures)
            lastBusinessDate				= try container.decodeIfPresent(Date.self, forKey: .lastBusinessDate)
            ticketable						= try container.decode(String.self, forKey: .ticketable)
            attributes						= try container.decode([AMCAPI.AttributeModel].self, forKey: .attributes)
            location						= try container.decode(Location.self, forKey: .location)
            media							= try container.decode(Media.self, forKey: .media)
            redemptionMethods				= try container.decode([String].self, forKey: .redemptionMethods)
            westWorldMediaNumber			= try container.decodeIfPresent(Int.self, forKey: .westWorldMediaNumber)
            concessionsDeliveryOptions		= try container.decode([ConcessionDeliveryOption].self, forKey: .concessionsDeliveryOptions)
            convenienceFeeTaxPercent		= try container.decode(Double.self, forKey: .convenienceFeeTaxPercent)
            convenienceFeeTaxFlatAmount		= try container.decode(Double.self, forKey: .convenienceFeeTaxFlatAmount)
            brand							= try container.decode(String.self, forKey: .brand)
            subscriptionUsageLevel			= try container.decode(Int.self, forKey: .subscriptionUsageLevel)
            onlineConcessions				= try container.decode(Bool.self, forKey: .onlineConcessions)
            hasMultipleKitchens				= try container.decode(Bool.self, forKey: .hasMultipleKitchens)
            deliveryToSeat					= try container.decode(Bool.self, forKey: .deliveryToSeat)
        } catch let error as DecodingError {
            Logger.logAMCAPIDecodingError(error)
            throw error
        } catch {
            Logger.logAMCAPIError(error)
            throw error
        }
    }
}

extension AMCAPI.TheatreModel.ConcessionDeliveryOption: Codable {
    private enum CodingKeys: String, CodingKey {
        case deliveryToSeat, expressPickup
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if
            let option = try? container.decode(String.self),
            let caseFound = Self.allCases.first(where: { $0.rawValue.caseInsensitiveCompare(option) == .orderedSame }) {
            self = caseFound
        } else {
            let error = DecodingError.typeMismatch(AMCAPI.TheatreModel.ConcessionDeliveryOption.self,
                                                   DecodingError.Context(codingPath: [CodingKeys.deliveryToSeat, CodingKeys.expressPickup],
                                                                         debugDescription: "'Invalid ConcessionDeliveryOption."))
            Logger.logAMCAPIDecodingError(error)
            throw error
        }
    }
}
