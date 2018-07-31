//
//  OperationObserver.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

protocol COperationObserver {
  
  func operationDidStart(operation: COperation)
  
  func operation(operation: COperation, didProduceOperation newOperation: Operation)
  
  func operationDidFinish(operation: COperation, errors: [NSError])
}
