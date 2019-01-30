//
//  ViewController.swift
//  KLineView
//
//  Created by job on 2019/1/30.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let kLineView = KLineView.init(frame: CGRect.init(x: 0, y: 200, width: kLineViewWitdh, height: kLineViewHeight))
        self.view.addSubview(kLineView)
    }


}

