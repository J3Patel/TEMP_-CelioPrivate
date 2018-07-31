//
//  CURLSessionTaskOperation.swift
//  Celio
//
//  Created by MP-11 on 31/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class CURLSessionTaskOperation: COperation {
  
  let requestEndpoint: NetworkRouter
  
  init(_ requestEndpoint: NetworkRouter) {
    self.requestEndpoint = requestEndpoint
    super.init()
    
    
//    sessionManager.delegate
    if let urlRequest = requestEndpoint.urlRequest {
      URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        
      }
    }
    
    
  }
  
}
