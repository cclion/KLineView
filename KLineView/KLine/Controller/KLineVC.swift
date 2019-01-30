//
//  KLineVC.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//
/*
注：Demo仅提供思路，假如是公司项目，建议根据思路自己搭建，面对产品的其他要求才会游刃有余。
    
*/
import UIKit

class KLineVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let kLineView = KLineView.init(frame: CGRect.init(x: 0, y: 200, width: kLineViewWitdh, height: kLineViewHeight))
        self.view.addSubview(kLineView)
    }
    

}
