//
//  ViewController.swift
//  Celio
//
//  Created by MP-11 on 20/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var opertaionQueue = COperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController-----viewDidLoad-")

    }
    @IBAction func callApiButtonTapped(_ sender: Any) {
        let opn = FetchUserDataOperation { (data) in
            
            print(data)
        }

//        let networkOperation = CNetworkOperation(networkRequest: APIRouter.getData())
//        networkOperation.start()
//        opertaionQueue = COperationQueue()

//        let op = TempOp()
//        op.userInitiated = true

        opertaionQueue.qualityOfService = .userInitiated
        opertaionQueue.addOperation(opn)
    }

}
