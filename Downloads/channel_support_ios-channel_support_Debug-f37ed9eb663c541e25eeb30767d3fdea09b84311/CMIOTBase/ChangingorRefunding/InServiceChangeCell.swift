//
//  InServiceChangeCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class InServiceChangeCell: UITableViewCell {
    
    var index: Int = 0
    var btnClickBlock: ((_ type:Int,_ index:Int) -> ())?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    lazy var statusLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(31, g: 121, b: 255), placeText: "处理中")
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var stepBgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = UIColor.clear
        return bgview
    }()
    
    lazy var stepIndicatorView: StepIndicatorView = {
        let stepIndicatorView = UIFactoryGenerateStepIndicatorView()
        stepIndicatorView.stepMarks = ["扫码回收","扫码换新"]
        stepIndicatorView.direction = .customCenter
        stepIndicatorView.numberOfSteps = 2
        stepIndicatorView.currentStep = 0
        stepIndicatorView.stepWith = 60
        stepIndicatorView.frame = CGRect(x: 12, y: 0, width: SCREEN_WIDTH - 34 - 34, height: 72)
        return stepIndicatorView
    }()
    
    lazy var orderNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(28, g: 28, b: 28), placeText: "换货")
        return lab
    }()
    
    lazy var originNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: RGB(69, g: 69, b: 69), placeText: "原订单号：173563477283")
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
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "扫码回收", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "取消售后", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(cancleBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
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
        
        bgView.addSubview(stepBgView)
        stepBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(45 + 5)
            make.height.equalTo(72)
        }
//        stepBgView.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 23 - 23, h: 72))
        stepBgView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "step_bg")!)
        stepBgView.addSubview(stepIndicatorView)
        
        let labs = [originNoLab,serviceNoLab,applyTimeLab,refundedCountLab]
        let colors = [RGB(3, g: 230, b: 106),
                      RGB(250, g: 140, b: 86),
                      RGB(86, g: 187, b: 255),
                      RGB(121, g: 159, b: 255)]
        for (index, lab) in labs.enumerated() {
            let markView = UIView()
            markView.setCornerRadius(radius: 3)
            markView.backgroundColor = colors[index]
            bgView.addSubview(markView)
            markView.snp.makeConstraints { (make) in
                make.width.height.equalTo(6)
                make.left.equalToSuperview().offset(14)
                make.top.equalTo(orderNoLab.snp.bottom).offset(103 + index * 18)
            }
            
            bgView.addSubview(lab)
            lab.snp.makeConstraints { (make) in
                make.height.equalTo(19)
                make.right.equalToSuperview()
                make.left.equalTo(markView.snp.right).offset(5)
                make.centerY.equalTo(markView.snp.centerY)
            }
        }
        
        bgView.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-9)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        bgView.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.right.equalTo(scanBtn.snp.left).offset(-10)
            make.bottom.equalToSuperview().offset(-14)
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
    
    //
    @objc func scanBtnClick(sender: UIButton){
        print("scan")
        if let click = self.btnClickBlock {
            click(1,index)
        }
    }
    
    @objc func cancleBtnClick(sender: UIButton){
        print("cancel")
        if let click = self.btnClickBlock {
            click(0,index)
        }
    }
    
    func configServiceChangeInfo(infoModel:AfterSaleServiceInfofListItemModel){
        
//        let info = infoModel.configAfterSalesStatusInfo()
//        let scanBtnTitle = info.btnStr
//        
//        scanBtn.setTitle(scanBtnTitle, for: .normal)
//        stepIndicatorView.currentStep =  info.step
//        statusLab.text = info.listMarkStr
//        orderNoLab.text = info.listStatusStr
//        cancleBtn.isHidden = info.isHiddenCancel
        
        originNoLab.text = "原订单号：" + (infoModel.orderNo ?? "")
        serviceNoLab.text = "服务单号：" + (infoModel.serviceNo ?? "")
        applyTimeLab.text = "申请时间：" + (infoModel.createTime ?? "")
        refundedCountLab.text = "退换数量：" + String(infoModel.goodsAmount ?? 0)
    }
    
}
