//
//  COperation.swift
//  Celio
//
//  Created by MP-11 on 30/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

/**
 The subclass of `Operation` from which all other operations should be derived.
 This class adds both Conditions and Observers, which allow the operation to define
 extended readiness requirements, as well as notify many interested parties
 about interesting operation state changes
 */

class COperation: Operation {

    private enum State: Int, Comparable {
        case initialized
        case pending
        case evaluatingConditions
        case ready
        case executing
        case finishing
        case finished

        func canTransition(toState target: State) -> Bool {
            switch (self, target) {
            case (.initialized, .pending):
                return true
            case (.pending, .evaluatingConditions):
                return true
            case (.evaluatingConditions, .ready):
                return true
            case  (.ready, .executing):
                return true
            case  (.ready, .finishing):
                return true
            case (.executing, .finishing):
                return true
            case (.finishing, .finished):
                return true
            default:
                return false
            }
        }

        static func < (lhs: State, rhs: State) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

        static func == (lhs: State, rhs: State) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }

    }

    // use the KVO mechanism to indicate that changes to "state" affect other properties as well
    @objc class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
        return ["state" as NSObject]
    }

    @objc class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
        return ["state" as NSObject]
    }

    @objc class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
        return ["state" as NSObject]
    }



    private var _state: State = .initialized

    private let stateBlock = NSLock()

    private var state: State {
        get {
            return stateBlock.withCriticalScope(block: {
                _state
            })
        }

        set(newState) {

            willChangeValue(forKey: "state")

            stateBlock.withCriticalScope {
                guard _state != .finished else {
                    return
                }
                assert(_state.canTransition(toState: newState), "Performing invalid state transition.")
                _state = newState
            }
            didChangeValue(forKey: "state")

        }
    }

    func willEnqueue() {
        state = .pending
    }

    override var isReady: Bool {
        switch state {
        case .initialized:
            return isCancelled
        case .pending:
            guard !isCancelled else {
                return true
            }

            if super.isReady {
                evaluateConditions()
            }
            return false
        case .ready:
            return super.isReady || isCancelled
        default:
            return false
        }
    }

    var userInitiated: Bool {
        get {
            return qualityOfService == .userInitiated
        }
        set {
            assert(state < .executing, "Cannot modify userInitiated after execution has begun.")
            qualityOfService = newValue ? .userInitiated : .default
        }
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    private func evaluateConditions() {
        assert(state == .pending && !isCancelled, "evaluateConditions() was called out-of-order")
        state = .evaluatingConditions

        OperationConditionEvaluator.evaluate(conditions: conditions, for: self) { failures in
            self._internalErrors += failures
            self.state = .ready
        }
    }

    private(set) var conditions: [COperationCondition] = []

    private var _internalErrors = [NSError]()

    private(set) var observers: [COperationObserver] = []

    private var hasFinishedAlready = false

    func addCondition(condition: COperationCondition) {
        assert(state < .evaluatingConditions, "Cannot modify conditions after execution has begun.")

        conditions.append(condition)
    }

    func addObserver(observer: COperationObserver) {
        assert(state < .executing, "Cannot modify observers after execution has begun.")

        observers.append(observer)
    }

    override func addDependency(_ op: Operation) {
        assert(state < .executing, "Dependencies cannot be modified after execution has begun.")
        super.addDependency(op)
    }

    // MARK: - Execution and Cancellation

    override final func start() {
        super.start()
        if isCancelled {
            finish()
        }
    }

    override final func main() {
        assert(state == .ready, "This operation must be performed on an operation queue.")
        if _internalErrors.isEmpty && !isCancelled {
            state = .executing

            for observer in observers {
                observer.operationDidStart(operation: self)
            }

            execute()
        } else {
            finish()
        }
    }

    func execute() {
        finish()
    }

    func cancel(with error: NSError? = nil) {
        if let error = error {
            _internalErrors.append(error)
        }
        cancel()
    }

    final func produceOperation(operation: Operation) {
        for observer in observers {
            observer.operation(operation: self, didProduceOperation: operation)
        }
    }

    final func finish(with error: NSError?) {
        if let error = error {
            finish(with: [error])
        } else {
            finish()
        }
    }

    final func finish(with errors: [NSError] = []) {
        if !hasFinishedAlready {
            hasFinishedAlready = true
            state = .finishing

            let combinedErrors = _internalErrors + errors
            finished(errors: combinedErrors)

            for observer in observers {
                observer.operationDidFinish(operation: self, errors: combinedErrors)
            }
            state = .finished
        }
    }

    func finished(errors: [NSError]) {
        // No op.
    }

    override func waitUntilFinished() {
        fatalError("Waiting on operations is an anti-pattern."
            + "Remove this ONLY if you're absolutely sure there is No Other Way™.")
    }
}
