//
//  TicketPriceModel.swift
//  AMCAPI
//
//  Created by Michael A. Crawford on 11/02/21.
//  Copyright © 2021 CDE, LLC. All rights reserved.
//

import Foundation
import os.log

extension AMCAPI {
    public struct TicketPriceModel: Equatable {
		public enum TicketType: String, Codable, CaseIterable { case adult, child, senior }

		/// A decimal value representing the price of the ticket in USD.
		/// This value is not final and is for display only.
        public let price: Double

		/// The ticket type: adult, child, or senior.
        public let type: TicketType

		/// The SKU value used to assemble the product for an order.
        public let sku: String

		/// The age based policy regarding sale of the particular ticket type.
		public let agePolicy: String?

		/// A decimal value representing the tax on the ticket price in USD.
		/// This value is not final and is for display only.
		public let tax: Double
    }
}

extension AMCAPI.TicketPriceModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case price, type, sku, agePolicy, tax
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do {
            // Decode built-in and supported types.
            price       = try container.decode(Double.self, forKey: .price)
            sku         = try container.decode(String.self, forKey: .sku)
            agePolicy   = try container.decodeIfPresent(String.self, forKey: .agePolicy)
            tax         = try container.decode(Double.self, forKey: .tax)

            // Decode user-defined types.
            if let ticketTypeRawValue = try container.decodeIfPresent(String.self, forKey: .type) {
                guard let ticketType = TicketType(rawValueIgnoreCase: ticketTypeRawValue) else {
                    let error =  DecodingError.typeMismatch(TicketType.self,
                                                            DecodingError.Context(codingPath: [CodingKeys.type],
                                                                                  debugDescription: "'\(ticketTypeRawValue)' is not a valid ticket type."))
                    Logger.logAMCAPIDecodingError(error)
                    throw error
                }
                self.type = ticketType
            } else {
                self.type = .adult
            }
        } catch let error as DecodingError {
            Logger.logAMCAPIDecodingError(error)
            throw error
        } catch {
            Logger.logAMCAPIError(error)
            throw error
        }
    }
}
