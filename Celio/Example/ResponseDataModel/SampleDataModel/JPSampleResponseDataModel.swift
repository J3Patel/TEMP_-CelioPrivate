//
//  SampleResponseDataModel.swift
//  Celio
//
//  Created by MP-11 on 25/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

//SAMPLE API: http://uinames.com/api/?ext&amount=250
// Created class from http://www.jsoncafe.com/

import Foundation

struct JPSampleResponseDataModel: ResponseDataModel, Codable {

    let age: Int?
    let birthday: JPBirthday?
    let creditCard: JPCreditCard?
    let email: String?
    let gender: String?
    let name: String?
    let password: String?
    let phone: String?
    let photo: String?
    let region: String?
    let surname: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case age = "age"
        case birthday = "birthday"
        case creditCard = "credit_card"
        case email = "email"
        case gender = "gender"
        case name = "name"
        case password = "password"
        case phone = "phone"
        case photo = "photo"
        case region = "region"
        case surname = "surname"
        case title = "title"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        birthday = try JPBirthday(from: decoder)
        creditCard = try JPCreditCard(from: decoder)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        surname = try values.decodeIfPresent(String.self, forKey: .surname)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }

}
