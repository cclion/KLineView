//
//  KLineModel.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit
import HandyJSON
struct KLineModel: HandyJSON {

    var closeprice: Double = 0
    var openprice: Double = 0
    var highestprice: Double = 0
    var lowestprice: Double = 0
    var turnovervol: Double = 0    //交易量
    var avg_5: Double = 0          //均线5
    var avg_10: Double = 0         //均线10
    var avg_20: Double = 0         //均线20

//    lazy var isUp: Bool = openprice.st
    
}





