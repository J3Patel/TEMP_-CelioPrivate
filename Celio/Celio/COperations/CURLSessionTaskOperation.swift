//
//  CURLSessionTaskOperation.swift
//  Celio
//
//  Created by MP-11 on 31/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

private var URLSessionTaksOperationKVOContext = 0

class CURLSessionTaskOperation: COperation {

    let task: URLSessionTask

    init(_ task: URLSessionTask) {
        assert(task.state == .suspended, "Tasks must be suspended.")
        self.task = task
        super.init()
    }

    override func execute() {
        assert(task.state == .suspended, "Task was resumed by something other than \(self).")
        task.addObserver(self, forKeyPath: "state", options: [], context: &URLSessionTaksOperationKVOContext)
        task.resume()
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard context == &URLSessionTaksOperationKVOContext else { return }
        if task.isEqual(object) && keyPath == "state" && task.state == .completed {
            task.removeObserver(self, forKeyPath: "state")
            finish()
        }
    }

    override func cancel() {
        task.cancel()
        super.cancel()
    }

}
