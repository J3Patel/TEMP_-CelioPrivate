//
//  APIRouter.swift
//  Celio
//
//  Created by MP-11 on 25/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

public enum APIRouter: NetworkRouter {

    case getData()

    static var baseURLPath: String {
        return "http://uinames.com"
    }

    var method: CHTTPMethod {
        switch self {
        case .getData:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getData:
            return "/api/?ext&amount=250"
        }
    }

    public func asURLRequest() -> URLRequest {
        //Setting the request with all the necessary parameters for the call

        let url = URL(string: APIRouter.baseURLPath)!
        var request = URLRequest(url: url.appendingPathComponent(path))

        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(30)

        switch self {
        case .getData:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }
    }
}
