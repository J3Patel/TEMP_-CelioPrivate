//
//  NSError+.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

extension NSError {

    convenience init(code: COperationErrorCode, userInfo: [String: Any]? = nil) {
        self.init(.COperationError, code: code.rawValue, userInfo: userInfo)
    }

    convenience init(_ domain: CErrorDomain, code: Int, userInfo: [String: Any]? = nil) {
        self.init(domain: domain.rawValue, code: code, userInfo: userInfo)
    }

}
