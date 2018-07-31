//
//  ViewController.swift
//  Celio
//
//  Created by MP-11 on 20/07/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let temp: APIRouter = .getData()
    print(temp.path)
  }

}

