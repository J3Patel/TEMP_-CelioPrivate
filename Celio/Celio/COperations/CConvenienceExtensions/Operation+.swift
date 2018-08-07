//
//  Operation+.swift
//  Celio
//
//  Created by MP-11 on 07/08/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

extension Operation {
    func addCompletionBlock(block: @escaping () -> Void) {
        if let existingBlock = completionBlock {
            completionBlock = {
                existingBlock()
                block()
            }
        } else {
            completionBlock = block
        }
    }
}
