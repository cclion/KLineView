
//
//  KLineVolumeCell.swift
//  CCSwift
//
//  Created by job on 2019/1/24.
//  Copyright © 2019 我是花轮. All rights reserved.
//

import UIKit

class KLineVolumeCell: UITableViewCell {

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
    
    lazy var pillarLayer = CAShapeLayer.init()

    
    @objc func layoutSubViews() {
        
        if currData == nil{
            return
        }
        let pillarLayerPath = UIBezierPath.init(rect: KLineVM.sharedInstance.getKLineVolumeRect(currData!))
        pillarLayer.path = pillarLayerPath.cgPath

        // color
        if currData!.closeprice >= currData!.openprice {
            pillarLayer.fillColor = UIColor.white.cgColor
            pillarLayer.strokeColor = kLinePriceUpColor.cgColor
        }else{
            pillarLayer.fillColor = kLinePriceDownColor.cgColor
        }
        
    }
    
    func configerSubViews() {

        self.contentView.layer.addSublayer(pillarLayer)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let notificationName = Notification.Name(rawValue: KLineVolumeExtremumChangeNotification)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(layoutSubViews),
                                               name: notificationName, object: nil)
        
        self.configerSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
