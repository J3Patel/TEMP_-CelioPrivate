//
//  NetworkRouter.swift
//  Celio
//
//  Created by MP-11 on 25/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

protocol NetworkRouter: CURLRequestConvertible {
  static var baseURLPath: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
}

protocol CURLRequestConvertible {
  public func asURLRequest() throws -> URLRequest
}
