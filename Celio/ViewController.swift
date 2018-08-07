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

        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        let op = CBlockOperation {
            self.present(vc!, animated: true, completion: nil)
        }
        op.addCondition(condition: CMutuallyExclusive<UIViewController>())
        opertaionQueue.addOperation(op)
    }

}
