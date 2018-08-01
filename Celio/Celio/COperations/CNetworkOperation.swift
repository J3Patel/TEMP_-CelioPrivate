//
//  CNetworkOperation.swift
//  Celio
//
//  Created by MP-11 on 31/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class CNetworkOperation: CGroupOperation {
  
  let networkRequest: NetworkRouter
  var dataFetched: Data?
  
  init(networkRequest: NetworkRouter) {
    self.networkRequest = networkRequest
    super.init(operations: [])
    name = "Network Operation"
    
    let task = URLSession.shared.dataTask(with: networkRequest.asURLRequest()) { [weak self] (data, response, error) in
      guard let strongSelf = self else {return}
      if let error = error {
        strongSelf.aggregateError(error: error as NSError)
      } else {
        strongSelf.dataFetched = data
      }
    }
    
    let taskOperation = CURLSessionTaskOperation(task)
    
    let reachabilityCondition = CReachabilityCondition(host: networkRequest.asURLRequest().url!)
    taskOperation.addCondition(condition: reachabilityCondition)
    
    let networkObserver = CNetworkObserver()
    taskOperation.addObserver(observer: networkObserver)
    
    addOperation(operation: taskOperation)
  }
  
}
