//
//  CNetworkObserver.swift
//  Celio
//
//  Created by MP-11 on 01/08/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class CNetworkObserver: COperationObserver {

    init() { }

    func operationDidStart(operation: COperation) {
        DispatchQueue.main.async {
            CNetworkIndicatorController.sharedIndicatorController.networkActivityDidStart()
        }
    }

    func operation(operation: COperation, didProduceOperation newOperation: Operation) { }

    func operationDidFinish(operation: COperation, errors: [NSError]) {
        DispatchQueue.main.async {
            CNetworkIndicatorController.sharedIndicatorController.networkActivityDidEnd()
        }
    }

}

protocol CNetworkIndicatorControllerDelegate: class {
    func networkActivityDidStart()
    func networkActivityDidEnd()
}

private class CNetworkIndicatorController {

    static let sharedIndicatorController = CNetworkIndicatorController()

    weak var delegate: CNetworkIndicatorControllerDelegate?

    private init() { }

    func networkActivityDidStart() {
        delegate?.networkActivityDidStart()
    }

    func networkActivityDidEnd() {
        delegate?.networkActivityDidEnd()
    }
}
