//
//  TempOp.swift
//  Celio
//
//  Created by MP-11 on 02/08/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation

class TempOp: CGroupOperation {
    init() {
        let block = BlockOperation {
            print("Inside Block")
        }
        super.init(operations: [block])

        //        addOperation(operation: block)
    }
}


class Simple: COperation {

    let tem: Int

    init(value: Int) {
        tem = value
    }
    override func execute() {

        print("SIMPLE OPERATION \(tem)")


    }

    override func finished(errors: [NSError]) {
        print("Error")
    }
}
