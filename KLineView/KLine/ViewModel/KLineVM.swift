//
//  KLineViewModel.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit
import SwiftyJSON


class KLineVM: NSObject {
    static let sharedInstance = KLineVM()
    
    lazy var data: [KLineModel] = {

        let path = Bundle.main.path(forResource: "KLineData.plist", ofType: nil)
        let dataDict = NSDictionary(contentsOfFile: path!)
        let dataJson = JSON(dataDict!)
        let dataStr: String = dataJson["data"].rawString()!
        let dataKLine = [KLineModel].deserialize(from: dataStr) as! [KLineModel]
        return dataKLine
        
    }()
    
    /// cell高度
    var cellHeight = kLineViewCellDefaultHeight
    /// price极高值 默认0
    var priceMax: CGFloat = 10
    /// price极小值 默认0
    var priceMin: CGFloat = 0
    /// 交易量极高值 默认0
    var volumeMax: CGFloat = 50000000

    /// 计算价格K线柱在cell中的位置
    ///
    /// - Parameter data: 数据
    /// - Returns: 位置
    public func getKLinePriceRect(_ data: KLineModel) -> CGRect {
        
        let dataMax: CGFloat = CGFloat([data.openprice, data.closeprice].max()!)
        let dataMin: CGFloat = CGFloat([data.openprice, data.closeprice].min()!)
        
        let rect = CGRect.init(x: self.getKLinePriceTopDis(dataMax), y: kLinePriceViewCellSeg, width: self.getKLinePriceTopDis(dataMin) - self.getKLinePriceTopDis(dataMax), height: cellHeight - 2 * kLinePriceViewCellSeg)
        return rect
    }
    
    /// 计算交易量K线柱在cell中的位置
    ///
    /// - Parameter data: 数据
    /// - Returns: 位置
    public func getKLineVolumeRect(_ data: KLineModel) -> CGRect {
        
        let dataMax: CGFloat =  CGFloat(data.turnovervol)
        
        let rect = CGRect.init(x: self.getKLineVolumeTopDis(dataMax), y: kLinePriceViewCellSeg, width: kLineVolumeViewHeight - self.getKLineVolumeTopDis(dataMax), height: cellHeight - 2 * kLinePriceViewCellSeg)
        return rect
    }
    
    
    /// 计算这个值在cell中距上方位置
    ///
    /// - Parameter data: 数值
    /// - Returns:距上方位置
    public func getKLineVolumeTopDis(_ data: CGFloat) -> CGFloat {
        
        // 假如当前数据没有最高值 返回0
        if priceMax == 0 || data == priceMax{
            return 0
        }
        let top = (volumeMax - data) / volumeMax * kLineVolumeViewHeight
        return top
    }
    
    /// 计算这个值在cell中距上方位置
    ///
    /// - Parameter data: 数值
    /// - Returns:距上方位置
    public func getKLinePriceTopDis(_ data: CGFloat) -> CGFloat {

        // 假如当前数据没有最高值 返回0
        if priceMax == 0 {
            return 0
        }
        let top = (priceMax - data) / (priceMax - priceMin) * (kLinePriceViewHeight - kLinePriceViewSeg * 2) + kLinePriceViewSeg
        return top
    }
    
    
}
