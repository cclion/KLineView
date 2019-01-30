//
//  KLinePriceCell.swift
//  CCSwift
//
//  Created by job on 2019/1/22.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit
import SnapKit

class KLinePriceCell: UITableViewCell {
    
    let maxLabel = UILabel.init()
    let minLabel = UILabel.init()
    
    var index: Int? {
        didSet{
            let data = KLineVM.sharedInstance.data[index!]
            currData = data
        }
    }
    var currData: KLineModel? {
        didSet{
            // 如果极大值为0 说明当前最大值还没有计算出来 不需要渲染了
            if KLineVM.sharedInstance.priceMax == 0 {
                return
            }
            self.layoutSubViews()
        }
    }
    /// K线柱
    lazy var pillarLayer = CAShapeLayer.init()
    /// K线最高最低幅度
    lazy var lineLayer = CAShapeLayer.init()
    /// 均线MA5
    lazy var MA5Layer = CAShapeLayer.init()
    /// 均线MA10
    lazy var MA10Layer = CAShapeLayer.init()
    /// 均线MA20
    lazy var MA20Layer = CAShapeLayer.init()
    
    /// 左边界线
    lazy var borderLeftLayer = CAShapeLayer.init()
    /// 右边界线
    lazy var borderRightLayer = CAShapeLayer.init()
    
    /// 根据数据差异性渲染布局
    @objc func layoutSubViews() {
        
        if currData == nil{
            return
        }
        
        //K线柱业务
        
        let pillarLayerPath = UIBezierPath.init(rect: KLineVM.sharedInstance.getKLinePriceRect(currData!))
        pillarLayer.path = pillarLayerPath.cgPath
        
        let lineLayerPath = UIBezierPath.init()
        lineLayerPath.move(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.highestprice)), y: KLineVM.sharedInstance.cellHeight / 2))
        lineLayerPath.addLine(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.lowestprice)), y: KLineVM.sharedInstance.cellHeight / 2))
        lineLayer.path = lineLayerPath.cgPath
        
        // color
        if currData!.closeprice >= currData!.openprice {
            pillarLayer.fillColor = UIColor.white.cgColor
            pillarLayer.strokeColor = kLinePriceUpColor.cgColor
            lineLayer.strokeColor = kLinePriceUpColor.cgColor
        }else{
            pillarLayer.fillColor = kLinePriceDownColor.cgColor
            lineLayer.strokeColor = kLinePriceDownColor.cgColor
        }
        
        //均线业务
        // 先找到有无上一个数据 如index == 0，则无上一个数据
        let MA5LayerPath = UIBezierPath.init()
        let MA10LayerPath = UIBezierPath.init()
        let MA20LayerPath = UIBezierPath.init()

        if index! > 0 {
           // 上一个数据
            let lastData = KLineVM.sharedInstance.data[index! - 1]
            MA5LayerPath.move(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat((currData!.avg_5 + lastData.avg_5) * 0.5)), y: 0))
            MA5LayerPath.addLine(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.avg_5)), y: KLineVM.sharedInstance.cellHeight / 2))
            
            MA10LayerPath.move(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat((currData!.avg_10 + lastData.avg_10) * 0.5)), y: 0))
            MA10LayerPath.addLine(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.avg_10)), y: KLineVM.sharedInstance.cellHeight / 2))
            
            MA20LayerPath.move(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat((currData!.avg_20 + lastData.avg_20) * 0.5)), y: 0))
            MA20LayerPath.addLine(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.avg_20)), y: KLineVM.sharedInstance.cellHeight / 2))
        }else{
             MA5LayerPath.move(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.avg_5)), y: KLineVM.sharedInstance.cellHeight / 2))
            
            MA10LayerPath.move(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.avg_10)), y: KLineVM.sharedInstance.cellHeight / 2))
            
             MA20LayerPath.move(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat(currData!.avg_20)), y: KLineVM.sharedInstance.cellHeight / 2))
        }
        
        if index! + 1 < KLineVM.sharedInstance.data.count{
            
            let nextData = KLineVM.sharedInstance.data[index! + 1]
            MA5LayerPath.addLine(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat((currData!.avg_5 + nextData.avg_5) * 0.5)), y: KLineVM.sharedInstance.cellHeight))
            
            MA10LayerPath.addLine(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat((currData!.avg_10 + nextData.avg_10) * 0.5)), y: KLineVM.sharedInstance.cellHeight))
            
            MA20LayerPath.addLine(to: CGPoint.init(x: KLineVM.sharedInstance.getKLinePriceTopDis(CGFloat((currData!.avg_20 + nextData.avg_20) * 0.5)), y: KLineVM.sharedInstance.cellHeight))
        }
        
        MA5Layer.path = MA5LayerPath.cgPath
        
        MA10Layer.path = MA10LayerPath.cgPath

        MA20Layer.path = MA20LayerPath.cgPath

        
    }
    
    /// 配置子视图
    func configerSubViews() {
        
        lineLayer.lineWidth = 1

        self.contentView.layer.addSublayer(lineLayer)
        self.contentView.layer.addSublayer(pillarLayer)
        self.contentView.layer.addSublayer(MA5Layer)
        self.contentView.layer.addSublayer(MA10Layer)
        self.contentView.layer.addSublayer(MA20Layer)
        
        self.contentView.layer.addSublayer(borderLeftLayer)
        self.contentView.layer.addSublayer(borderRightLayer)

        MA5Layer.strokeColor = kLineMA5Color.cgColor
        MA5Layer.fillColor = UIColor.clear.cgColor

        MA10Layer.strokeColor = kLineMA10Color.cgColor
        MA10Layer.fillColor = UIColor.clear.cgColor

        MA20Layer.strokeColor = kLineMA20Color.cgColor
        MA20Layer.fillColor = UIColor.clear.cgColor

        borderLeftLayer.fillColor = kLineBorderColor.cgColor
        borderRightLayer.fillColor = kLineBorderColor.cgColor

        borderLeftLayer.path = UIBezierPath.init(rect: CGRect.init(x: 10, y: 0, width: 1, height: KLineVM.sharedInstance.cellHeight)).cgPath
        borderRightLayer.path = UIBezierPath.init(rect: CGRect.init(x: kLinePriceViewHeight - 10, y: 0, width: 1, height: KLineVM.sharedInstance.cellHeight)).cgPath
    
        // debug
        self.addSubview(maxLabel)
        self.addSubview(minLabel)
        maxLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 20)
        maxLabel.textColor = UIColor.red
        minLabel.frame = CGRect.init(x: 100, y: 0, width: 100, height: 20)
        minLabel.textColor = UIColor.red
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    
        let notificationName = Notification.Name(rawValue: KLinePriceExtremumChangeNotification)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(layoutSubViews),
                                               name: notificationName, object: nil)
        
        self.configerSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
