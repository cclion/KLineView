//
//  KLineView.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit
import HandyJSON

@objc protocol KLineViewDelegate: NSObjectProtocol {
    /// 保持价格视图和交易量视图 偏移量一致
    func kLineViewDidScroll(_ tableView: UITableView)
    /// 保持价格视图和交易量视图捏合时 cell的宽度一致
    func kLineViewDidPinch(_ tableView: UITableView)
    /// 保持价格视图和交易量视图长按时可以统一绘制数据线
//    func kLineViewDidHandleLong(_ tableView: UITableView)
    func kLineViewDidHandleLong(_ tableView: UITableView, longPressGes: UILongPressGestureRecognizer, index: IndexPath)
}


class KLineView: UIView, KLineViewDelegate {
    func kLineViewDidHandleLong(_ tableView: UITableView, longPressGes: UILongPressGestureRecognizer, index: IndexPath) {
        if tableView == priceView{
            volumeView.drawWithLongPress(longPressGes: longPressGes, index: index)
        }else{
            priceView.drawWithLongPress(longPressGes: longPressGes, index: index)
        }
    }
    
    func kLineViewDidScroll(_ tableView: UITableView) {
        if tableView == priceView{
            volumeView.contentOffset = priceView.contentOffset
        }else{
            priceView.contentOffset = volumeView.contentOffset
        }
    }
    
    func kLineViewDidPinch(_ tableView: UITableView) {
        if tableView == priceView{
            volumeView.reloadData()
        }else{
            priceView.reloadData()
        }
    }
    
    var priceView = KLinePriceView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .plain)
    var volumeView = KLineVolumeView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(priceView)
        self.addSubview(volumeView)

        priceView.delegateK = self
        volumeView.delegateK = self
        
        priceView.layer.borderWidth = 1
        volumeView.layer.borderWidth = 1

        priceView.transform = CGAffineTransform(rotationAngle: CGFloat(.pi * 0.5));
        volumeView.transform = CGAffineTransform(rotationAngle: CGFloat(.pi * 0.5));

        priceView.frame = CGRect.init(x: 0, y: 0, width: kLineViewWitdh, height: kLinePriceViewHeight)
        volumeView.frame = CGRect.init(x: 0, y: kLinePriceViewHeight + kLineViewInterval, width: kLineViewWitdh, height: kLineVolumeViewHeight)

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

