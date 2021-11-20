//
//  ShowtimeModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 9/3/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation

extension AMCAPI {
    /// See the description for `MovieId`.
    public struct ShowtimeId: Codable, Equatable, Hashable, RawRepresentable {
        public typealias RawValue = Int
        public var rawValue: RawValue

        public init?(rawValue: RawValue) {
            self.rawValue = rawValue
        }
    }

    public struct ShowtimeModel: Equatable, Identifiable {
        public struct Media: Codable, Equatable {
            /// URL location of hero Desktop.
            public let heroDesktopDynamic: String

            /// URL Location of hero Mobile.
            public let heroMobileDynamic: String

            /// URL location of the Movie poster.
            public let posterDynamic: String

            /// URL location of the Movie poster alternate.
            public let posterAlternateDynamic: String

            /// URL location of the Movie 3D poster.
            public let poster3DDynamic: String

            /// URL location of the IMAX poster.
            public let posterIMAXDynamic: String

            /// URL location of the trailer teaser.
            public let trailerTeaserDynamic: String

            /// URL location of the alternate trailer.
            public let trailerAlternateDynamic: String
        }

        /// The Showtime Id.
        public let id: ShowtimeId

          /// The Radiant performance number.
        public let performanceNumber: Int

        /// Identifies the associated movie.
        public let movieId: MovieId

        /// The title of the associated movie.
        public let movieName: String

        /// The primary genre of the associated movie.
        public let genre: MovieModel.Genre

        /// The movie website URL.
        public let movieURL: URL

        /// The movie's sortable title name.
        public let sortableMovieName: String

        /// The show date/time in UTC (ISO-8601)
        public let showDateTimeUTC: Date

        /// The show date/time in the theatre's local timezone.
        public let showDateTimeLocal: Date

        /// The date/time UTC of when the showtime should stop being sold.
        public let sellUntilDateTimeUTC: Date

        /// The auditorium id where the showing is taking place.
        public let auditorium: Int

        /// The auditorium layout being used for this showtime.
        public let layoutId: Int

        /// The auditorium layout version number. This is incremented whenever an auditorium layout is modified.
        public let layoutVersionNumber: Int

        /// Indicates if tickets are sold out.
        public let isSoldOut: Bool

        /// Indicates if tickets are almost sold out based on an AMC predefined threshold.
        public let isAlmostSoldOut: Bool

        /// Indicates if the showing has been canceled.
        public let isCanceled: Bool

        /// The UTC offset of the showtime.
        public let utcOffset: String

        /// The website URL where tickets may be purchased from AMC Theaters.
        public let purchaseURL: URL

        /// The mobile website URL where tickets may be purchased from AMC Theaters.
        public let mobilePurchaseURL: URL

        /// The duration of the showing in minutes.
        public let runTime: Int?

        /// The MPAA's official movie rating.
        public let rating: MovieModel.MPAARating

        /// The premium format of the showtime.
        public let premiumFormat: String

        /// The showing's ticket prices.
        public let ticketPrices: [TicketPriceModel]

        /// The date/time UTC indicating when the showtime was last updated.
        public let lastUpdatedDateUTC: Date

        public let media: ShowtimeModel.Media

        /// Nullable flag indicating if this showtime is embargoed. If false or null, showtime is not embargoed.
        /// Null value is converted to `false` on decode.
        public let isEmbargoed: Bool

        /// Nullable flag indicating if this showtime is coming soon (will be available for display soon).
        /// If false or null, showtime is not coming soon. Null value is converted to `false` on decode.
        public let isComingSoon: Bool

        /// Indicates whether this showtime is available at a discounted matinee price.
        public let isDiscountMatineePriced: Bool

        /// If a showtime is available at discounted matinee price, display message for PLF and Non-PLF showtimes.
        public let discountMatineeMessage: String?

        /// A UTC date/time indicating when an embargoed showtime will be come displayable, and no longer be embargoed.
        public let visibilityDateTimeUTC: Date

        /// The maximum allowed intended attendance for this Private Theatre Rental.
        public let maximumIntendedAttendance: Int?

        /// A list of showtime attributes.
        public let attributes: [AttributeModel]
    }
}

extension AMCAPI.ShowtimeModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, performanceNumber, movieId, movieName, genre, sortableMovieName, showDateTimeLocal, auditorium, layoutId,
             layoutVersionNumber, isSoldOut, isAlmostSoldOut, isCanceled, utcOffset, runTime, premiumFormat, ticketPrices,
             media, isEmbargoed, isComingSoon, isDiscountMatineePriced, discountMatineeMessage, maximumIntendedAttendance,
             attributes
        case movieURL = "movieUrl"
        case showDateTimeUTC = "showDateTimeUtc"
        case sellUntilDateTimeUTC = "sellUntilDateTimeUtc"
        case purchaseURL = "purchaseUrl"
        case mobilePurchaseURL = "mobilePurchaseUrl"
        case rating = "mpaaRating"
        case lastUpdatedDateUTC = "lastUpdatedDateUtc"
        case visibilityDateTimeUTC = "visibilityDateTimeUtc"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode built-in and supported types.
        id                              = try container.decode(AMCAPI.ShowtimeId.self, forKey: .id)
        performanceNumber               = try container.decode(Int.self, forKey: .performanceNumber)
        movieId                         = try container.decode(AMCAPI.MovieId.self, forKey: .movieId)
        movieName                       = try container.decode(String.self, forKey: .movieName)
        movieURL                        = try container.decode(URL.self, forKey: .movieURL)
        sortableMovieName               = try container.decode(String.self, forKey: .sortableMovieName)
        showDateTimeUTC                 = try container.decode(Date.self, forKey: .showDateTimeUTC)
        showDateTimeLocal               = try container.decode(Date.self, forKey: .showDateTimeLocal)
        sellUntilDateTimeUTC            = try container.decode(Date.self, forKey: .sellUntilDateTimeUTC)
        auditorium                      = try container.decode(Int.self, forKey: .auditorium)
        layoutId                        = try container.decode(Int.self, forKey: .layoutId)
        layoutVersionNumber             = try container.decode(Int.self, forKey: .layoutVersionNumber)
        isSoldOut                       = try container.decode(Bool.self, forKey: .isSoldOut)
        isAlmostSoldOut                 = try container.decode(Bool.self, forKey: .isAlmostSoldOut)
        isCanceled                      = try container.decode(Bool.self, forKey: .isCanceled)
        utcOffset                       = try container.decode(String.self, forKey: .utcOffset)
        purchaseURL                     = try container.decode(URL.self, forKey: .purchaseURL)
        mobilePurchaseURL               = try container.decode(URL.self, forKey: .mobilePurchaseURL)
        runTime                         = try container.decodeIfPresent(Int.self, forKey: .runTime)
        rating                          = try container.decodeIfPresent(AMCAPI.MovieModel.MPAARating.self, forKey: .rating) ?? .unrated
        premiumFormat                   = try container.decode(String.self, forKey: .premiumFormat)
        ticketPrices                    = try container.decode([AMCAPI.TicketPriceModel].self, forKey: .ticketPrices)
        lastUpdatedDateUTC              = try container.decode(Date.self, forKey: .lastUpdatedDateUTC)
        media                           = try container.decode(Media.self, forKey: .media)
        isEmbargoed                     = try container.decodeIfPresent(Bool.self, forKey: .isEmbargoed) ?? false
        isComingSoon                    = try container.decodeIfPresent(Bool.self, forKey: .isComingSoon) ?? false
        isDiscountMatineePriced         = try container.decodeIfPresent(Bool.self, forKey: .isDiscountMatineePriced) ?? false
        discountMatineeMessage          = try container.decodeIfPresent(String.self, forKey: .discountMatineeMessage)
        visibilityDateTimeUTC           = try container.decode(Date.self, forKey: .visibilityDateTimeUTC)
        maximumIntendedAttendance       = try container.decodeIfPresent(Int.self, forKey: .maximumIntendedAttendance)
        attributes                      = try container.decode([AMCAPI.AttributeModel].self, forKey: .attributes)

        // Decode user-defined types.
        if let genreRawValue = try container.decodeIfPresent(String.self, forKey: .genre) {
            guard let genre = AMCAPI.MovieModel.Genre(rawValueIgnoreCase: genreRawValue) else {
                throw DecodingError.typeMismatch(AMCAPI.MovieModel.Genre.self,
                                                 DecodingError.Context(codingPath: [CodingKeys.genre],
                                                                       debugDescription: "'\(genreRawValue)' is not a valid Genre."))
            }
            self.genre = genre
        } else {
            self.genre = .unavailable
        }
    }
}
