//
//  JPCreditCard.swift
//  Celio
//
//  Created by MP-11 on 25/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

struct JPCreditCard: Codable {

    let expiration: String?
    let number: String?
    let pin: Int?
    let security: Int?

    enum CodingKeys: String, CodingKey {
        case expiration
        case number
        case pin
        case security
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        expiration = try values.decodeIfPresent(String.self, forKey: .expiration)
        number = try values.decodeIfPresent(String.self, forKey: .number)
        pin = try values.decodeIfPresent(Int.self, forKey: .pin)
        security = try values.decodeIfPresent(Int.self, forKey: .security)
    }

}
