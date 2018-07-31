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
  var method: CHTTPMethod { get }
  var path: String { get }
}

protocol CURLRequestConvertible {
  func asURLRequest() -> URLRequest
}


public enum CHTTPMethod: String {
  case options = "OPTIONS"
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case trace   = "TRACE"
  case connect = "CONNECT"
}
