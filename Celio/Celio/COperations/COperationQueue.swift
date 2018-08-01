//
//  COperationQueue.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

@objc protocol COperationQueueDelegate: NSObjectProtocol {
    @objc optional func operationQueue(_ operationQueue: COperationQueue, willAddOperation operation: Operation)
    @objc optional func operationQueue(_ operationQueue: OperationQueue,
                                       operationDidFinish operation: Operation,
                                       withErrors errors: [NSError])
}

class COperationQueue: OperationQueue {

    weak var delegate: COperationQueueDelegate?

    override func addOperation(_ op: Operation) {
        if let operation = op as? COperation {
            let delegate = CBlockObserver(
                producHandler: { [weak self](operation, producedOperation) in
                    self?.addOperation(producedOperation)
                },
                finishHandler: { [weak self] operation, errors in
                    if let queue = self {
                        queue.delegate?.operationQueue?(queue, operationDidFinish: operation, withErrors: errors)
                    }
            })
            operation.addObserver(observer: delegate)

            let dependencies = operation.conditions.compactMap { $0.dependency(for: operation) }

            for dependency in dependencies {
                operation.addDependency(dependency)
                self.addOperation(dependency)
            }

            let concurrentCategories: [String] = operation.conditions.compactMap {
                if !type(of: $0).isMutuallyExclusive {
                    return nil
                }
                return "\(type(of: $0))"
            }
            if !concurrentCategories.isEmpty {
                let exclusivityController = CExclusivityController.sharedExclusivityController
                exclusivityController.addOperation(operation: operation, categories: concurrentCategories)

                operation.addObserver(observer:
                    CBlockObserver(finishHandler: { (operation, _) in
                        exclusivityController.removeOperation(operation: operation, categories: concurrentCategories)
                    })
                )
            }
            operation.willEnqueue()
        } else {
            op.completionBlock = { [weak self, weak op] in
                guard let queue = self, let op = op else {
                    return
                }

                queue.delegate?.operationQueue?(queue, operationDidFinish: op, withErrors: [])

            }
        }
        delegate?.operationQueue?(self, willAddOperation: op)
        super.addOperation(op)
    }

    override func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        for operation in operations {
            addOperation(operation)
        }

        if wait {
            for operation in operations {
                operation.waitUntilFinished()
            }
        }
    }

}
