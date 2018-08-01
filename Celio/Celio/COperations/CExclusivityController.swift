//
//  ExclusivityController.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class CExclusivityController {

    static let sharedExclusivityController = CExclusivityController()

    private let serialQueue = DispatchQueue(label: "Operations.ExclusivityController")

    private var operations: [String: [COperation]] = [:]

    private init() {
        /*
         A private initializer effectively prevents any other part of the app
         from accidentally creating an instance.
         */
    }

    func addOperation(operation: COperation, categories: [String]) {
        serialQueue.sync {
            for category in categories {
                self.noqueue_addOperation(operation: operation, category: category)
            }
        }
    }

    func removeOperation(operation: COperation, categories: [String]) {
        serialQueue.async {
            for category in categories {
                self.noqueue_removeOperation(operation: operation, category: category)
            }
        }
    }

    // MARK: Operation Management

    private func noqueue_addOperation(operation: COperation, category: String) {
        var operationWithThisCategory = operations[category] ?? []

        if let last = operationWithThisCategory.last {
            operation.addDependency(last)
        }

        operationWithThisCategory.append(operation)
        operations[category] = operationWithThisCategory
    }

    private func noqueue_removeOperation(operation: COperation, category: String) {
        let matchingOperations = operations[category]
        if var operationsWithThisCategory = matchingOperations,
            let index = operationsWithThisCategory.index(of: operation) {
            operationsWithThisCategory.remove(at: index)
            operations[category] = operationsWithThisCategory
        }
    }

}
