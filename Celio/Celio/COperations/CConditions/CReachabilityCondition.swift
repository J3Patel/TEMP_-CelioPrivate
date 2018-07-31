//
//  ReachabilityCondition.swift
//  Celio
//
//  Created by MP-11 on 31/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation
import SystemConfiguration

struct CReachabilityCondition: COperationCondition {
  
  static let hostKey = "Host"
  static let name = "Reachability"
  static let isMutuallyExclusive = false
  
  let host: URL
  
  init(host: URL) {
    self.host = host
  }
  
  func dependency(for operation: COperation) -> Operation? {
    return nil
  }
  
  func evaluate(for operation: COperation, completion: @escaping (OperationConditionResult) -> Void) {
    CReachabilityController.requestReachability(url: host) { reachable in
      if reachable {
        completion(.satisfied)
      } else {
        let error = NSError(code: COperationErrorCode.conditionFailed,
                            userInfo: [OperationConditionKey: type(of: self).name,
                                       type(of: self).hostKey: self.host])
        completion(.failed(error))
      }
    }
  }
  
}

private class CReachabilityController {
  static var reachabilityRefs = [String: SCNetworkReachability]()
  static let reachabilityQueue = DispatchQueue(label: "Operations.Reachability")
  
  static func requestReachability(url: URL, completionHandler: @escaping (Bool) -> Void) {
    if let host = url.host {
      reachabilityQueue.async {
        var ref = reachabilityRefs[host]
        
        if ref == nil {
          let hostString = host as NSString
          ref = SCNetworkReachabilityCreateWithName(nil, hostString.utf8String!)
        }
        if let ref = ref {
          self.reachabilityRefs[host] = ref
          
          var reachable = false
          var flags: SCNetworkReachabilityFlags = []
          if SCNetworkReachabilityGetFlags(ref, &flags) {
            /*
             Note that this is a very basic "is reachable" check.
             Your app may choose to allow for other considerations,
             such as whether or not the connection would require
             VPN, a cellular connection, etc.
             */
            reachable = flags.contains(.reachable)
          }
          completionHandler(reachable)
        } else {
          completionHandler(false)
        }
      }
    } else {
      completionHandler(false)
    }
  }
}
