//
//  CBlockOperation.swift
//  Celio
//
//  Created by MP-11 on 07/08/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

typealias COperationBlock = (@escaping () -> Void) -> Void

class CBlockOperation: COperation {

    private let block: COperationBlock?

    init(_ block: COperationBlock? = nil) {
        self.block = block
        super.init()
    }

    convenience init(mainQueueBlock: @escaping () -> Void) {
        self.init { (continuation) in
            DispatchQueue.main.async {
                mainQueueBlock()
                continuation()
            }
        }
    }

    override func execute() {
        guard let block = block else {
            finish()
            return
        }
        block { [weak self] in
            self?.finish()
        }
    }
}
