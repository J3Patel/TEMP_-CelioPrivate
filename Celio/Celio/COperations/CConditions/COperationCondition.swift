//
//  OperationCondition.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

let kOperationConditionKey = "OperationCondition"

protocol COperationCondition {

    static var name: String { get }

    static var isMutuallyExclusive: Bool { get }

    func dependency(for operation: COperation) -> Operation?

    func evaluate(for operation: COperation, completion: @escaping (OperationConditionResult) -> Void)

}

enum OperationConditionResult: Equatable {

    case satisfied
    case failed(NSError)

    var error: NSError? {
        if case .failed(let error) = self {
            return error
        }
        return nil
    }

    static func == (lhs: OperationConditionResult, rhs: OperationConditionResult) -> Bool {
        switch (lhs, rhs) {
        case (.satisfied, .satisfied):
            return true
        case (.failed(let lError), failed(let rError)):
            return lError == rError
        default:
            return false
        }
    }
}

struct OperationConditionEvaluator {

    static func evaluate(conditions: [COperationCondition],
                         for operation: COperation,
                         completion: @escaping ([NSError]) -> Void) {

        guard !conditions.isEmpty else {
            completion([])
            return
        }

        let conditionGroup = DispatchGroup()
        var results = [OperationConditionResult?](repeating: nil, count: conditions.count)

        for (index, condition) in conditions.enumerated() {
            conditionGroup.enter()
            condition.evaluate(for: operation) { (result) in
                results[index] = result
                conditionGroup.leave()
            }
        }

        conditionGroup.notify(queue: DispatchQueue.global(qos: .default)) {
            var failures = results.compactMap { $0?.error }

            if operation.isCancelled {
                failures.append(NSError(code: COperationErrorCode.executionFailed))
            }
            completion(failures)
        }
    }

}
