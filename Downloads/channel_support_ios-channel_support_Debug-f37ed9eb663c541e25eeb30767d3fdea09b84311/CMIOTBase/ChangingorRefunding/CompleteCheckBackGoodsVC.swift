//
//  CompleteCheckBackGoodsVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/12.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class CompleteCheckBackGoodsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "退货退款"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
    }
    
    override func backToUpVC() {
        let result = self.backToSpecificVC(VCName: "ChangingOrRefundingVC")
        if result == false {
            NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
            let _ = self.backToSpecificVC(VCName: "OrderManagerVC")
        }
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
        let result = self.backToSpecificVC(VCName: "ChangingOrRefundingVC")
        if result == false{
            NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
            let _ = self.backToSpecificVC(VCName: "OrderManagerVC")
        }
    }
    
    //MARK: - UI
    lazy var stepBgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = UIColor.clear
        return bgview
    }()
    
    lazy var stepIndicatorView: StepIndicatorView = {
        let stepIndicatorView = UIFactoryGenerateStepIndicatorView()
        stepIndicatorView.stepMarks = ["退货检查","扫码回收","退款"]
        stepIndicatorView.direction = .customCenter
        stepIndicatorView.numberOfSteps = 3
        stepIndicatorView.currentStep = 2
        stepIndicatorView.stepWith = 60
        stepIndicatorView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 15 - 15, height: 72)
        return stepIndicatorView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = RGB(255, g: 255, b: 255)
        return bgView
    }()
    
    lazy var successImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "renew_success")
        return imgView
    }()
    
    lazy var successLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 21, color: RGB(88, g: 88, b: 88), placeText: "退货成功")
        lab.font = UIFont.boldSystemFont(ofSize: 21 * kDrawdownRatioH)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var successTipsLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(125, g: 125, b: 125), placeText: "等待后台退款")
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var inputTV: KMPlaceholderTextView = {
        let input = KMPlaceholderTextView()
        input.font = UIFont.systemFont(ofSize: 15)
        input.textColor = RGB(88, g: 88, b: 88)
        input.placeholderColor = RGB(148, g: 148, b: 148)
        input.placeholder = "输入备注信息(选填)"
        input.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        input.addBorder(width: 0.5, color: RGB(216, g: 216, b: 216))
        return input
    }()
    
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(25, g: 81, b: 255), placeText: "确认并返回",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        btn.setCornerRadius(radius: 6)
        btn.addBorder(width: 1, color: RGB(25, g: 81, b: 255))
        return btn
    }()
    
    func configUI(){
        
        self.view.addSubview(stepBgView)
        stepBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(125)
        }
//        stepBgView.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 125))
        stepBgView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "step_head_bg")!)
        stepBgView.addSubview(stepIndicatorView)
        
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(96)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(314 * kDrawdownRatioH)
        }
        
        bgView.addSubview(successImgView)
        successImgView.snp.makeConstraints { (make) in
            make.width.equalTo(81 * kDrawdownRatioH)
            make.height.equalTo(102 * kDrawdownRatioH)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(26 * kDrawdownRatioH)
        }
        
        bgView.addSubview(successLab)
        successLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(30 * kDrawdownRatioH)
            make.top.equalTo(successImgView.snp.bottom).offset(16 * kDrawdownRatioH)
        }
        
        bgView.addSubview(successTipsLab)
        successTipsLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(23)
            make.top.equalTo(successLab.snp.bottom).offset(0)
        }
        
        bgView.addSubview(inputTV)
        inputTV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(successLab.snp.bottom).offset(53 * kDrawdownRatioH)
            //            make.height.equalTo(135 * kDrawdownRatioH)
            make.height.equalTo(0 * kDrawdownRatioH)
        }
        
        bgView.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-16 * kDrawdownRatioH)
        }
        inputTV.isHidden = true
    }
    
    
}
