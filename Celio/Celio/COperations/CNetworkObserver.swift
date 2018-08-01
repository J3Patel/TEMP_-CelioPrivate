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
    }

    func operation(operation: COperation, didProduceOperation newOperation: Operation) {

    }

    func operationDidFinish(operation: COperation, errors: [NSError]) {

    }

}

private class NetworkIndicatorController {

    static let sharedIndicatorController = NetworkIndicatorController()

    private var activityCount = 0

    private var visibilityTimer: Timer?

    func networkActivityDidStart() {

    }

    func networkActivityDidEnd() {

    }

    private func updateIndicatorVisibility() {

    }

    private func showIndicator() {

    }

    private func hideIndicator() {

    }
}
