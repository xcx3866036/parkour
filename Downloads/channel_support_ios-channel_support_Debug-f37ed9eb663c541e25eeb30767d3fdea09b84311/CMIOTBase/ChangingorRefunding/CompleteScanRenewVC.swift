//
//  CompleteScanRenewVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/12.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

enum CompleteOperaateType {
    case exchangeGoods             // 扫码换新 - 换货成功
    case recycleGoods              //  扫码回收 - 换货成功
    case applyForReturnedGoods      //  退货成功
    case applyForReturningGoods     //  申请退货
    case applyForExchangingGoods    //  申请换货
    case cancleOrder               //  取消订单
    case cancleAfterSales          //  取消售后
    case refuseReturnGoods         //  拒绝售后
    case equalExchangeGoods        //  组内换货
}

class CompleteScanRenewVC: UIViewController,UITextViewDelegate {
    
    let kMaxLength:Int = 256
    var operateType: CompleteOperaateType = .exchangeGoods
    var backToVC:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        self.updateUI()
        self.delayPopVC()
    }
    
    func updateUI(){
        var titleStr = ""
        var successStr = ""
        var placeStr = ""
        switch operateType {
        case .exchangeGoods:
            titleStr = "换货成功"
            successStr = "换货成功"
            placeStr = "输入备注信息(选填)"
            backToVC = "ChangingOrRefundingVC"
        case .recycleGoods:
            titleStr = "扫码回收"
            successStr = "回收成功"
            placeStr = "输入备注信息(选填)"
            backToVC = "ChangingOrRefundingVC"
        case .applyForReturnedGoods:
            titleStr = "退货成功"
            successStr = "退货成功"
            placeStr = "输入退货原因(选填)"
            backToVC = "ManagerRepertoryVC"
        case .applyForReturningGoods:
            titleStr = "申请退货成功"
            successStr = "申请退货成功"
            placeStr = "输入退货原因(选填)"
            backToVC = "OrderManagerVC"
        case .applyForExchangingGoods:
            titleStr = "申请换货成功"
            successStr = "申请换货成功"
            placeStr = "输入换货成功原因(选填)"
            backToVC = "OrderManagerVC"
        case .cancleOrder:
            titleStr = "取消订单成功"
            successStr = "订单取消成功"
            placeStr = "输入订单取消原因(选填)"
            backToVC = "OrderManagerVC"
        case .cancleAfterSales:
            titleStr = "取消售后成功"
            successStr = "售后取消成功"
            placeStr = "输入取消售后原因(选填)"
            backToVC = "ChangingOrRefundingVC"
        case .refuseReturnGoods:
            titleStr = "拒绝退货成功"
            successStr = "拒绝退货成功"
            placeStr = "输入拒绝退货原因(选填)"
            backToVC = "ChangingOrRefundingVC"
        case .equalExchangeGoods:
            titleStr = "组内换货成功"
            successStr = "组内换货成功"
            placeStr = ""
            backToVC = "ChannelRepertoryVC"
        }
        
        self.title = titleStr
        self.successLab.text = successStr
        self.inputTV.placeholder = placeStr
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
        if backToVC.length > 0 {
           let result = self.backToSpecificVC(VCName: backToVC)
            if result == false{
                if backToVC == "ChangingOrRefundingVC"{
                    NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
                    let _ = self.backToSpecificVC(VCName: "OrderManagerVC")
                }
                else{
                    self.popToRootVC()
                }
            }
        }
//        self.popToRootVC()
    }
    
    func delayPopVC(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:{
                if self.backToVC.length > 0 {
                    let result = self.backToSpecificVC(VCName: self.backToVC)
                    if result == false {
                        if self.backToVC == "ChangingOrRefundingVC"{
                            NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
                            let _ = self.backToSpecificVC(VCName: "OrderManagerVC")
                        }
                        else{
                            self.popToRootVC()
                        }
                    }
                }
        })
    }
    
    override func backToUpVC() {
        if backToVC.length > 0 {
            let result = self.backToSpecificVC(VCName: backToVC)
            if result == false {
                if backToVC == "ChangingOrRefundingVC"{
                    NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
                    let _ = self.backToSpecificVC(VCName: "OrderManagerVC")
                }
                else{
                    self.popToRootVC()
                }
            }
        }
    }
    
    //MARK: - UI
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
        let lab = UIFactoryGenerateLab(fontSize: 21, color: RGB(88, g: 88, b: 88), placeText: "")
        lab.font = UIFont.boldSystemFont(ofSize: 21)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var inputTV: KMPlaceholderTextView = {
        let input = KMPlaceholderTextView()
        input.font = UIFont.systemFont(ofSize: 15)
        input.textColor = RGB(88, g: 88, b: 88)
        input.placeholderColor = RGB(148, g: 148, b: 148)
        input.placeholder = ""
        input.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        input.addBorder(width: 0.5, color: RGB(216, g: 216, b: 216))
        input.delegate = self
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
        
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(65)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            //            make.height.equalTo(371)
            make.height.equalTo(288)
        }
        
        bgView.addSubview(successImgView)
        successImgView.snp.makeConstraints { (make) in
            make.width.equalTo(81)
            make.height.equalTo(102)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(67)
        }
        
        bgView.addSubview(successLab)
        successLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(successImgView.snp.bottom).offset(16)
        }
        
        bgView.addSubview(inputTV)
        inputTV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(successLab.snp.bottom).offset(53)
            //            make.height.equalTo(135)
            make.height.equalTo(0)
        }
        
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            }
        }
        
        inputTV.isHidden = true
        commitBtn.isHidden = true
    }
}

extension CompleteScanRenewVC {
    func textViewDidChange(_ textView: UITextView) {
        let lang = textInputMode?.primaryLanguage
        let content = textView.text ?? ""
        if lang == "zh-Hans" {
            let range = textView.markedTextRange
            if range == nil {
                if content.count >= kMaxLength {
                   let endLocation = content.index(content.startIndex, offsetBy: kMaxLength)
                    textView.text = String(content[content.startIndex..<endLocation])
                }
            }
        }
        else {
            if content.count >= kMaxLength {
                let endLocation = content.index(content.startIndex, offsetBy: kMaxLength)
                textView.text = String(content[content.startIndex..<endLocation])
            }
        }
    }
}
