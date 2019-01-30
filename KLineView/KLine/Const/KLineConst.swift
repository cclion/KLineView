//
//  KLineConst.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//  用于记录K线竖屏版各个常亮

import Foundation
import UIKit

/// 视图宽度
let kLineViewWitdh: CGFloat = UIScreen.main.bounds.width

// MARK:- 日K线数据
//1、价格走势部分
/// K线价格视图高度（含两边边距）
let kLinePriceViewHeight: CGFloat = 200
/// K线价格视图内边距
let kLinePriceViewSeg: CGFloat = 10
/// K线价格视图Cell中K线柱的内边距
let kLinePriceViewCellSeg: CGFloat = 2

//2、间隔
/// K线价格视图和交易量视图间距
let kLineViewInterval: CGFloat = 30

//3、交易量部分
/// K线交易量视图高度（自身无边距）
let kLineVolumeViewHeight: CGFloat = 150
/// K线视图默认cell的宽度
let kLineViewCellDefaultHeight: CGFloat = 10
/// K线视图总高度
let kLineViewHeight: CGFloat = kLinePriceViewHeight + kLineVolumeViewHeight + kLineViewInterval

// MARK:- 日K线常量
/// K线视图价格cell reuseIdentifier
let kLinePriceRID = "KLinePriceRID"
/// K线视图交易量cell reuseIdentifier
let kLineVolumeRID = "kLineVolumeRID"
/// K线价格视图极值发生变化
let KLinePriceExtremumChangeNotification = "KLinePriceExtremumChangeNotification"
/// K线交易量视图极值发生变化
let KLineVolumeExtremumChangeNotification = "KLineVolumeExtremumChangeNotification"

// MARK:- 字体大小
/// K线极值显示字体大小
let kLineViewFontSize: CGFloat = 12

// MARK:- 颜色
func KRGBColor(r:CGFloat,g:CGFloat,b:CGFloat) ->UIColor{
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
}
/// K线上升颜色
let kLinePriceUpColor = KRGBColor(r: 221, g: 71, b: 66) //红
/// K线下降颜色
let kLinePriceDownColor = KRGBColor(r: 76, g: 167, b: 68) //绿
/// K线MA5颜色
let kLineMA5Color = KRGBColor(r: 240, g: 158, b: 66)
/// K线MA10颜色
let kLineMA10Color = KRGBColor(r: 78, g: 140, b: 224)
/// K线MA20颜色
let kLineMA20Color = KRGBColor(r: 195, g: 81, b: 161)
/// K线border颜色
let kLineBorderColor = KRGBColor(r: 240, g: 240, b: 240)
