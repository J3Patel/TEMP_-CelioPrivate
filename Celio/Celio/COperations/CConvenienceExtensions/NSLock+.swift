//
//  NSLock+.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

extension NSLock {
    func withCriticalScope<T>(block: () -> T) -> T {
    lock()
    let value = block()
    unlock()
    return value
  }
}
