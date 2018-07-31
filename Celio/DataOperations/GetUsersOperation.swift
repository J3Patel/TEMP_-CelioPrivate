//
//  GetUsersOperation.swift
//  Celio
//
//  Created by MP-11 on 26/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class GroupOperation: Operation {
  
  let queue = OperationQueue()
  var operations: [Operation] = []
  
  override func main() {
    queue.addOperations(operations, waitUntilFinished: true)
  }
  
}
