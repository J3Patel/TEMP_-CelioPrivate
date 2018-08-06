//
//  CMutuallyExclusive.swift
//  Celio
//
//  Created by MP-11 on 06/08/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

struct CMutuallyExclusive<T>: COperationCondition {

    static var name: String {
        return "MutuallyExclusive<\(T.self)>"
    }

    static var isMutuallyExclusive: Bool {
        return true
    }

    func dependency(for operation: COperation) -> Operation? {
        return nil
    }

    func evaluate(for operation: COperation, completion: @escaping (OperationConditionResult) -> Void) {
        return completion(.satisfied)
    }
}
