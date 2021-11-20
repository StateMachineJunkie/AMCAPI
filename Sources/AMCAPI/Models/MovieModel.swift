//
//  MovieModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 8/26/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation

extension AMCAPI {
    /// Entity identifiers use a common integer type. This is sufficient for
    /// making them conform to the `Identifiable` protocol but we don't want those
    /// IDs to be interchangeable with other integer based identifiable entities.
    /// This type will prevent that from occurring. After implementing this solution
    /// I learned about phantom types from Hacking With Swift, which is another way
    /// to accomplish the same type safety. If I run into limitations or issues with
    /// this solution, I can revisit changing the implementation to phantom types
    /// but for now, this is good enough.
    public struct MovieId: Codable, Equatable, Hashable, RawRepresentable {
        public typealias RawValue = Int
        public var rawValue: RawValue

        public init?(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        private enum CodingKeys: String, CodingKey {
            case rawValue = "id"
        }
    }

    public struct MovieModel: Equatable, Identifiable {
        public enum Genre: String, Codable, CaseIterable {
            case adventure      = "Adventure"
            case animation      = "Animation"
            case comedy         = "Comedy"
            case western        = "Western"
            case specialEvents  = "Special Events"
            case fantasy        = "Fantasy"
            case musical        = "Musical"
            case scifi          = "Sci-Fi"
            case filmFestival   = "Film Festival"
            case suspense       = "Suspense"
            case family         = "Family"
            case urban          = "Urban"
            case romanticComedy = "Romantic Comedy"
            case action         = "Action"
            case specialty      = "Specialty"
            case documentary    = "Documentary"
            case horror         = "Horror"
            case drama          = "Drama"
            case scienceFiction = "Science Fiction"
            case unavailable
        }

    	public enum MPAARating: String, Codable, CaseIterable {
            case rated_G    = "G"
            case rated_PG   = "PG"
            case rated_PG13 = "PG13"
            case rated_14A  = "14A"
            case rated_R    = "R"
            case rated_NC17 = "NC17"
            case rated_18A  = "18A"
            case rated_X    = "X"
            case rated_NR   = "NR"
            case unrated
        }

        public enum RentalTier: String, Codable, CaseIterable {
            case tier1 = "Tier1"
            case tier2 = "Tier2"
            case unavailable
        }

        public enum PreferredMediaType: String, Codable, CaseIterable {
            case onDemand = "OnDemand"
            case theatrical = "Theatrical"
        }

        public struct Media: Codable, Equatable {
            public let posterThumbnail: String
            public let posterStandard: String
            public let posterLarge: String
            public let trailerFlv: String
            public let trailerHd: String
            public let trailerMp4: String
            public let primaryTrailerExternalVideoId: String?
            public let primaryTrailerVideoId: String?
            public let heroDesktopDynamic: String
            public let heroMobileDynamic: String
            public let posterDynamic: String
            public let posterAlternateDynamic: String
            public let poster3DDynamic: String
            public let posterIMAXDynamic: String
            public let trailerTeaserDynamic: String
            public let trailerAlternateDynamic: String
            public let onDemandTrailerVideoId: String
            public let onDemandTrailerExternalVideoId: String
            public let onDemandPosterDynamic: String
            public let onDemandTrailerMp4Dynamic: String
            public let onDemandTrailerHdDynamic: String
            public let attributes: [AttributeModel]?
        }

        public let id: MovieId
        public let name: String
        public let sortableName: String

         /// A comma-separated `String` representing a list of actors.
        public let starringActors: String

         /// A comma-separated `String` representing a list of directors.
        public let directors: String

        /// The movie's primary genre.
        public let genre: Genre

        /// The assigned MPAA rating.
        public let rating: MPAARating

        /// The West World Media release number
        public let releaseNumber: Int?

        /// Total runtime in minutes
        public let runTime: Int?

        /// 0.0 ~ 1.0
        public let score: Double

        /// A dash-separated title.
        public let slug: String

        /// A short description of the film.
        public let synopsis: String?

        /// A short tag-line for the film.
        public let synopsisTagLine: String?

        /// The official release date in UTC (ISO-8601).
        public let releaseDateUTC: Date

        /// The earliest showing date in UTC (ISO-8601).
        public let earliestShowingUTC: Date?

        /// Indicates whether performances have been scheduled.
        public let hasScheduledShowtimes: Bool

        /// Indicates if tickets are available for purchase online.
        public let displayOnlineTicketAvailability: Bool?

        /// The date tickets will be available for online purchase in UTC (ISO-8601).
        public let onlineTicketAvailabilityDateUTC: Date

        /// The website URL.
        public let websiteURL: URL

        /// The showtimes URL.
        public let showtimesURL: URL

        /// The unique identifier for the distributor of a film.
        public let distributorId: Int?

        /// The code to identify the distributor of a film.
        public let distributorCode: String?

        public let availableForAList: Bool

        /// The preferred media type (Theatrical or OnDemand)
        public let preferredMediaType: PreferredMediaType

        /// The external IMDB ID for this movie
        public let imdbId: String?

        /// The tier of this movie for private theatre rentals (Tier1, Tier2, and Unavailable)
        public let privateTheatreRentalTier: RentalTier?

        public let media: MovieModel.Media
    }
}

extension CaseIterable where Self:RawRepresentable, RawValue == String {
    /// Unfortunately, AMC does not use consistent case when passing in Genre values in JSON. Thus we need to be able
    /// to handle raw-value initialization in a way that ignores case. Sourced from the following Stack Overflow article:
    /// https://stackoverflow.com/questions/36890895/enum-rawvalue-constructor-ignoring-case
    /// - Parameter rawValueIgnoreCase: Case-insensitive raw value used to initialize enum.
    public init?(rawValueIgnoreCase: RawValue) {
        if let caseFound = Self.allCases.first(where: { $0.rawValue.caseInsensitiveCompare(rawValueIgnoreCase) == .orderedSame }) {
            self = caseFound
        } else {
            self.init(rawValue: rawValueIgnoreCase)
        }
    }
}

extension AMCAPI.MovieModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, name, sortableName, starringActors, directors, genre, runTime,
             score, slug, synopsis, synopsisTagLine, hasScheduledShowtimes,
             displayOnlineTicketAvailability, distributorId, distributorCode,
             availableForAList, preferredMediaType, imdbId, privateTheatreRentalTier,
             media
        case rating = "mpaaRating"
        case releaseNumber = "wwmReleaseNumber"
        case releaseDateUTC = "releaseDateUtc"
        case earliestShowingUTC = "earliestShowingUtc"
        case onlineTicketAvailabilityDateUTC = "onlineTicketAvailabilityDateUtc"
        case websiteURL = "websiteUrl"
        case showtimesURL = "showtimesUrl"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode built-in and supported types.
        id                              = try container.decode(AMCAPI.MovieId.self, forKey: .id)
        name                            = try container.decode(String.self, forKey: .name)
        sortableName                    = try container.decode(String.self, forKey: .sortableName)
        starringActors                  = try container.decode(String.self, forKey: .starringActors)
        directors                       = try container.decode(String.self, forKey: .directors)
        rating                          = try container.decodeIfPresent(MPAARating.self, forKey: .rating) ?? .unrated
        releaseNumber                   = try container.decodeIfPresent(Int.self, forKey: .releaseNumber)
        runTime                         = try container.decodeIfPresent(Int.self, forKey: .runTime)
        score                           = try container.decode(Double.self, forKey: .score)
        slug                            = try container.decode(String.self, forKey: .slug)
        synopsis                        = try container.decodeIfPresent(String.self, forKey: .synopsis)
        synopsisTagLine                 = try container.decodeIfPresent(String.self, forKey: .synopsisTagLine)
        releaseDateUTC                  = try container.decode(Date.self, forKey: .releaseDateUTC)
        earliestShowingUTC              = try container.decodeIfPresent(Date.self, forKey: .earliestShowingUTC)
        hasScheduledShowtimes           = try container.decode(Bool.self, forKey: .hasScheduledShowtimes)
        displayOnlineTicketAvailability = try container.decodeIfPresent(Bool.self, forKey: .displayOnlineTicketAvailability)
        onlineTicketAvailabilityDateUTC = try container.decode(Date.self, forKey: .onlineTicketAvailabilityDateUTC)
        websiteURL                      = try container.decode(URL.self, forKey: .websiteURL)
        showtimesURL                    = try container.decode(URL.self, forKey: .showtimesURL)
        distributorId                   = try container.decodeIfPresent(Int.self, forKey: .distributorId)
        distributorCode                 = try container.decodeIfPresent(String.self, forKey: .distributorCode)
        preferredMediaType              = try container.decode(PreferredMediaType.self, forKey: .preferredMediaType)
        availableForAList               = try container.decode(Bool.self, forKey: .availableForAList)
        imdbId                          = try container.decodeIfPresent(String.self, forKey: .imdbId)
        privateTheatreRentalTier        = try container.decodeIfPresent(RentalTier.self, forKey: .privateTheatreRentalTier)
        media                           = try container.decode(Media.self, forKey: .media)

        // Decode user-defined types.
        if let genreRawValue = try container.decodeIfPresent(String.self, forKey: .genre) {
            guard let genre = Genre(rawValueIgnoreCase: genreRawValue) else {
                throw DecodingError.typeMismatch(Genre.self,
                                                 DecodingError.Context(codingPath: [CodingKeys.genre],
                                                                       debugDescription: "'\(genreRawValue)' is not a valid Genre."))
            }
            self.genre = genre
        } else {
            self.genre = .unavailable
        }
    }
}

extension AMCAPI.MovieModel {
    public var thumbnailImageURL: URL? {
        // I original implemented this using the nil-coalescing operator but the compiler couldn't
        // type-check the expression in a reasonable time so I was asked to simplify it.
        if let url = URL(string: media.posterDynamic) {
            return url
        } else if let url = URL(string: media.posterThumbnail) {
            return url
        } else if let url = URL(string: media.posterLarge) {
            return url
        } else if let url = URL(string: media.posterStandard) {
            return url
        } else if let url = URL(string: media.posterIMAXDynamic) {
            return url
        } else if let url = URL(string: media.posterAlternateDynamic) {
            return url
        } else if let url = URL(string: media.poster3DDynamic) {
            return url
        } else if let url = URL(string: media.onDemandPosterDynamic) {
            return url
        } else {
            return nil
        }
    }
}
