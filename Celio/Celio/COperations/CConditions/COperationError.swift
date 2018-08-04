//
//  OperationError.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

enum CErrorDomain: String {
    case APIError
    case COperationError
}

enum COperationErrorCode: Int {
  case conditionFailed = 1
  case executionFailed = 2
}

// This makes it easy to compare an `NSError.code` to an `OperationErrorCode`.
func == (lhs: Int, rhs: COperationErrorCode) -> Bool {
  return lhs == rhs.rawValue
}

func == (lhs: COperationErrorCode, rhs: Int) -> Bool {
  return lhs.rawValue == rhs
}
