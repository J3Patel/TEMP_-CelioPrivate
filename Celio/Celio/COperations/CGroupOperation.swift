//
//  CGroupOperation.swift
//  Celio
//
//  Created by MP-11 on 31/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class CGroupOperation: COperation {

    private let internalQueue = COperationQueue()
    private let startingOperation = BlockOperation(block: {})
    private let finishingOperation = BlockOperation(block: {})

    private var aggregatedErrors = [NSError]()

    convenience init(operations: Operation...) {
        self.init(operations: operations)
    }

    init(operations: [Operation]) {
        super.init()
        internalQueue.isSuspended = true
        internalQueue.delegate = self
        internalQueue.addOperation(startingOperation)
        for operation in operations {
            internalQueue.addOperation(operation)
        }
    }

    override func cancel() {
        internalQueue.cancelAllOperations()
        super.cancel()
    }

    override func execute() {
        internalQueue.isSuspended = false
        internalQueue.addOperation(finishingOperation)
    }

    func addOperation(operation: COperation) {
        internalQueue.addOperation(operation)
    }

    final func aggregateError(error: NSError) {
        aggregatedErrors.append(error)
    }

    func operationDidFinish(operation: Operation, withErrors errors: [NSError]) {
        // For use by subclassers.
    }
}

extension CGroupOperation: COperationQueueDelegate {

    final func operationQueue(_ operationQueue: COperationQueue, willAddOperation operation: Operation) {
        assert(!finishingOperation.isFinished && !finishingOperation.isExecuting,
               "cannot add new operations to a group after the group has completed")
        if operation != finishingOperation {
            finishingOperation.addDependency(operation)
        }

        if operation != startingOperation {
            operation.addDependency(startingOperation)
        }

    }

    final func operationQueue(_ operationQueue: OperationQueue,
                              operationDidFinish operation: Operation,
                              withErrors errors: [NSError]) {
        aggregatedErrors += errors
        if operation === finishingOperation {
            internalQueue.isSuspended = true
            finish(with: aggregatedErrors)
        } else if operation !== startingOperation {
            operationDidFinish(operation: operation, withErrors: errors)
        }

    }
}
