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

    @IBAction func callApiButtonTapped(_ sender: Any) {
        let opn = FetchUserDataOperation { (data) in
            print(data)
        }
        opertaionQueue.addOperation(opn)
    }

}
