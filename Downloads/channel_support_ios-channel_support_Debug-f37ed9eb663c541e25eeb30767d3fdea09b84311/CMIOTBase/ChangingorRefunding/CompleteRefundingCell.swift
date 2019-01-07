//
//  CompleteRefundingCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class CompleteRefundingCell: UITableViewCell {

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    lazy var statusLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(31, g: 121, b: 255), placeText: "已完成")
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var orderNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(28, g: 28, b: 28), placeText: "")
        return lab
    }()
    
    lazy var serviceNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: RGB(69, g: 69, b: 69), placeText: "服务单号：173563477283")
        return lab
    }()
    
    lazy var applyTimeLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: RGB(69, g: 69, b: 69), placeText: "申请时间：2018-09-23 23:34:54")
        return lab
    }()
    
    lazy var refundedCountLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: RGB(69, g: 69, b: 69), placeText: "退换数量：2")
        return lab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        bgView.addSubview(statusLab)
        statusLab.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        bgView.addSubview(orderNoLab)
        orderNoLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(statusLab.snp.left)
        }
        
        let labs = [serviceNoLab,applyTimeLab,refundedCountLab]
        let colors = [RGB(250, g: 140, b: 86),RGB(86, g: 187, b: 255),RGB(121, g: 159, b: 255)]
        for (index, lab) in labs.enumerated() {
            let markView = UIView()
            markView.setCornerRadius(radius: 3)
            markView.backgroundColor = colors[index]
            bgView.addSubview(markView)
            markView.snp.makeConstraints { (make) in
                make.width.height.equalTo(6)
                make.left.equalToSuperview().offset(14)
                make.top.equalTo(orderNoLab.snp.bottom).offset(28 + index * 18)
            }
            
            bgView.addSubview(lab)
            lab.snp.makeConstraints { (make) in
                make.height.equalTo(19)
                make.right.equalToSuperview()
                make.left.equalTo(markView.snp.right).offset(5)
                make.centerY.equalTo(markView.snp.centerY)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configServiceChangeInfo(infoModel:AfterSaleServiceInfofListItemModel){
        self.statusLab.text = infoModel.configAfterSalesStatusInfo().listMarkStr
        self.orderNoLab.text = infoModel.configAfterSalesStatusInfo().listStatusStr
        serviceNoLab.text = "服务单号：" + (infoModel.serviceNo ?? "")
        applyTimeLab.text = "申请时间：" + (infoModel.createTime ?? "")
        refundedCountLab.text = "退换数量：" + String(infoModel.goodsAmount ?? 0)
    }
}
