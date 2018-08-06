//
//  JPBirthday.swift
//  Celio
//
//  Created by MP-11 on 25/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

struct JPBirthday: Codable {

    let dmy: String?
    let mdy: String?
    let raw: Int?

    enum CodingKeys: String, CodingKey {
        case dmy
        case mdy
        case raw
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dmy = try values.decodeIfPresent(String.self, forKey: .dmy)
        mdy = try values.decodeIfPresent(String.self, forKey: .mdy)
        raw = try values.decodeIfPresent(Int.self, forKey: .raw)
    }

}
