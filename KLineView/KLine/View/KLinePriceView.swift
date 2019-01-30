//
//  KLinePriceView.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit
class KLinePriceView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var cellLastHeight = KLineVM.sharedInstance.cellHeight
    
    weak var delegateK: KLineViewDelegate?
    
    /// 水平线
    lazy var horizontalLineLayer = CAShapeLayer.init()
    /// 竖直线
    lazy var verticalLineLayer = CAShapeLayer.init()
    
    lazy var maxTextLayer:CATextLayer = {
       
        var maxTextLayer = CATextLayer.init()
        maxTextLayer.fontSize = kLineViewFontSize
        maxTextLayer.foregroundColor = UIColor.black.cgColor
        maxTextLayer.alignmentMode = CATextLayerAlignmentMode.left
        maxTextLayer.contentsScale = UIScreen.main.scale
        return maxTextLayer
    }()
    lazy var minTextLayer:CATextLayer = {
        
        var minTextLayer = CATextLayer.init()
        minTextLayer.fontSize = kLineViewFontSize
        minTextLayer.foregroundColor = UIColor.black.cgColor
        minTextLayer.contentsScale = UIScreen.main.scale
        return minTextLayer
    }()
    lazy var midTextLayer:CATextLayer = {
        
        var midTextLayer = CATextLayer.init()
        midTextLayer.fontSize = kLineViewFontSize
        midTextLayer.foregroundColor = UIColor.black.cgColor
        midTextLayer.contentsScale = UIScreen.main.scale
        return midTextLayer
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KLineVM.sharedInstance.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建复用cell 并且传递index
        // 传递index是因为cell还要获取旁边两个cell的数据完成均线 传递的index可以借助VM实现数据获取 
        let cell = KLinePriceCell.init(style: .default, reuseIdentifier: kLinePriceRID)
        // 🔥渲染之前先计算出当前页面即将展示的所有数据的极值
        self.findExtreNum()
        cell.index = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return KLineVM.sharedInstance.cellHeight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.reloadMark()
        if let delegate = delegateK{
            delegate.kLineViewDidScroll(self)
        }
    }
    
    /// 🔥找到当前列表展示的数据极值
    func findExtreNum() {
        // 获取当前展示的cells的Indexpath数组
        let indexs = self.indexPathsForVisibleRows
      
        // 用于记录极值是否有变化 有变化则需要刷新cell
        var max: CGFloat = 0
        var min: CGFloat = 0
      
        for indexPath in indexs! {
            let data = KLineVM.sharedInstance.data[indexPath.row]
        
            let dataMax: CGFloat = CGFloat([data.highestprice, data.lowestprice].max()!)
            let dataMin: CGFloat = CGFloat([data.highestprice, data.lowestprice].min()!)
            
            if max == 0 || dataMax > max{
                max = dataMax
            }
            
            if min == 0 || dataMin < min{
                min = dataMin
            }
        }
        
        // 🔥极值变化 发送通知
        if KLineVM.sharedInstance.priceMax == 0 || max != KLineVM.sharedInstance.priceMax{
            KLineVM.sharedInstance.priceMax = max
            
            let notificationName = Notification.Name(rawValue: KLinePriceExtremumChangeNotification)
            NotificationCenter.default.post(name: notificationName, object: self,
                                            userInfo: nil)
            self.reloadMark()
        }
        if KLineVM.sharedInstance.priceMin == 0 || min != KLineVM.sharedInstance.priceMin{
            KLineVM.sharedInstance.priceMin = min
            
            let notificationName = Notification.Name(rawValue: KLinePriceExtremumChangeNotification)
            NotificationCenter.default.post(name: notificationName, object: self,
                                            userInfo: nil)
            self.reloadMark()
        }
        
    }
    
    @objc func pinchAction(pinchGes: UIPinchGestureRecognizer) {
        print(pinchGes.state)
        print(pinchGes.scale)
        print(pinchGes.velocity)
        
        // 滑动开始 记录一下当前cell的高度
        if pinchGes.state == .began {
            cellLastHeight = KLineVM.sharedInstance.cellHeight
        }
        
        // 滑动过程中 动态修改cell的宽度
        if (pinchGes.numberOfTouches) == 2 && (pinchGes.state == .changed){
            //计算当前捏合后cell的应该宽度
            let tempHeight = cellLastHeight * pinchGes.scale
            
            if tempHeight != cellLastHeight && tempHeight >= 10 && tempHeight <= 30{
                 // 🔥计算捏合中心，根据中心点，确定放大位置
                let pOne = pinchGes.location(ofTouch: 0, in: self)
                let pTwo = pinchGes.location(ofTouch: 1, in: self)
                let center = CGPoint.init(x: (pOne.x+pTwo.x)/2, y: (pOne.y+pTwo.y)/2)
                let indexPath = self.indexPathForRow(at: center) ;//获取响应的长按的indexpath
                if indexPath == nil {
                    return
                }
             
                // 🔥小学知识用到了 具体计算方式在文章中有讲
                // 变化之前
                let y1 = CGFloat(indexPath!.row) * KLineVM.sharedInstance.cellHeight;
                let o1 = self.contentOffset.y;
                let h1 = KLineVM.sharedInstance.cellHeight * 0.5;

                // 变化之后
                let y2 = CGFloat(indexPath!.row) * tempHeight;
                let h2 = tempHeight * 0.5;

                let o2 = y2 + h2 - y1 + o1 - h1;
            
                KLineVM.sharedInstance.cellHeight = tempHeight
                self.reloadData()
                // 修改偏移量 使中心点一直处于中心 注意设置 estimatedRowHeight、estimatedSectionHeaderHeight、estimatedSectionFooterHeight来保证contentOffset可用
                self.contentOffset = CGPoint.init(x: 0, y: o2)
            
                if let delegate = delegateK{
                    delegate.kLineViewDidPinch(self)
                }
            }
        }
        
        if pinchGes.state == .ended ||  pinchGes.state == .recognized{
            cellLastHeight = KLineVM.sharedInstance.cellHeight
        }
        
    }
    
    @objc func longPressAction(longPressGes: UILongPressGestureRecognizer) {
        
        let point = longPressGes.location(in: self)
        let index = self.indexPathForRow(at: point)
        if let _ = index {
             self.drawWithLongPress(longPressGes: longPressGes, index: index!)
            if let delegate = delegateK{
                delegate.kLineViewDidHandleLong(self, longPressGes: longPressGes, index: index!)
            }
        }
    }
    
    public func drawWithLongPress(longPressGes: UILongPressGestureRecognizer, index: IndexPath) -> () {
        if longPressGes.state == .began{
            self.layoutGuideLine(index: index)
        }else  if (longPressGes.state == .ended) {
            horizontalLineLayer.path = nil
            verticalLineLayer.path = nil
        }else  if (longPressGes.state == .changed) {
            self.layoutGuideLine(index: index)
        }
        
    }
    func layoutGuideLine(index: IndexPath) -> () {
        
        // 当前的cell的位置
        let rect = self.rectForRow(at: index)
        // 找到当前的数据
        let data = KLineVM.sharedInstance.data[index.row]
        // 找到当前中心点的位置
        let x = KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(data.closeprice))
        let y = rect.origin.y + rect.size.height * 0.5

        let horizontalLineLayerPath = UIBezierPath.init()
        horizontalLineLayerPath.move(to: CGPoint.init(x: x, y:self.contentOffset.y))
        horizontalLineLayerPath.addLine(to: CGPoint.init(x: x, y: kLineViewWitdh + self.contentOffset.y))
        horizontalLineLayer.path = horizontalLineLayerPath.cgPath
      
        let verticalLineLayerPath = UIBezierPath.init()
        verticalLineLayerPath.move(to: CGPoint.init(x: 0, y: y))
        verticalLineLayerPath.addLine(to: CGPoint.init(x: kLinePriceViewHeight, y: y))
        verticalLineLayer.path = verticalLineLayerPath.cgPath
    }
    func reloadMark() {

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        maxTextLayer.string = String.init(format:"%.2f",KLineVM.sharedInstance.priceMax)
        minTextLayer.string = String.init(format:"%.2f",KLineVM.sharedInstance.priceMin)
        midTextLayer.string = String.init(format:"%.2f",(KLineVM.sharedInstance.priceMin + KLineVM.sharedInstance.priceMax) * 0.5)
        
        maxTextLayer.frame = CGRect.init(x: 5, y: self.contentOffset.y + kLineViewWitdh - 60, width: 15, height: 60)
        minTextLayer.frame = CGRect.init(x: kLinePriceViewHeight - 20, y: self.contentOffset.y + kLineViewWitdh - 60, width: 15, height: 60)
        midTextLayer.frame = CGRect.init(x: kLinePriceViewHeight * 0.5, y: self.contentOffset.y + kLineViewWitdh - 60, width: 15, height: 60)
        CATransaction.commit()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
        
        // 🔥 为了保证contentOffset生效
        self.estimatedRowHeight = 0;// default is UITableViewAutomaticDimension, set to 0 to disable
        self.estimatedSectionHeaderHeight = 0;// default is UITableViewAutomaticDimension, set to 0 to disable
        self.estimatedSectionFooterHeight = 0; // default is UITableViewAutomaticDimension, set to 0 to disable
        
        self.layer.addSublayer(horizontalLineLayer)
        self.layer.addSublayer(verticalLineLayer)
        self.layer.addSublayer(maxTextLayer)
        self.layer.addSublayer(minTextLayer)
        self.layer.addSublayer(midTextLayer)

        horizontalLineLayer.lineWidth = 1
        verticalLineLayer.lineWidth = 1

        horizontalLineLayer.strokeColor = UIColor.black.cgColor
        verticalLineLayer.strokeColor = UIColor.black.cgColor
        
        maxTextLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(-.pi * 0.5)))
        minTextLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(-.pi * 0.5)))
        midTextLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(-.pi * 0.5)))

        // 添加捏合和长按手势
        let pinchGes = UIPinchGestureRecognizer.init(target: self, action:  #selector(pinchAction(pinchGes:)))
        self.addGestureRecognizer(pinchGes)
        let longPressGes = UILongPressGestureRecognizer.init(target: self, action:  #selector(longPressAction(longPressGes:)))
        self.addGestureRecognizer(longPressGes)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
