//
//  CommitAddRemarkVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/25.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SVProgressHUD

let kCancleAfterSalesNotification = "cancleAfterSalesNotification"       // 取消售后
//let kCancleOrderSuccessNotification = "cancleOrderSuccessNotification"   // 取消订单
//let kApplyForReturningNotification = "applyForReturningNotification"     // 申请售后 - 退货
//let kApplyForExchangingNotification = "applyForExchangingNotification"   // 申请售后 - 换货


class CommitAddRemarkVC: UIViewController,UITextViewDelegate {
    
    let kMaxLength:Int = 256
    var operateType: CompleteOperaateType = .exchangeGoods
    var selOrder: OrderInofListItemModel?
    var selChangingOrRefundingItem:AfterSaleServiceInfofListItemModel?
    var afterSaleType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        self.updateUI()
    }
    
    func updateUI(){
        var titleStr = ""
        var successStr = ""
        var placeStr = ""
        var imageName = ""
        switch operateType {
        case .applyForReturningGoods:
            titleStr = "申请退货"
            successStr = "确认退货？"
            placeStr = "输入退货原因(选填)"
            imageName = "commit_back_goods"
        case .applyForExchangingGoods:
            titleStr = "申请换货"
            successStr = "确认换货？"
            placeStr = "输入换货原因(选填)"
             imageName = "commit_exchange_goods"
        case .cancleAfterSales:
            titleStr = "取消售后"
            successStr = "确认取消售后？"
            placeStr = "输入取消订单原因(选填)"
            imageName = "commit_cancle_aftersales"
        case .cancleOrder:
            titleStr = "取消订单"
            successStr = "确认取消订单？"
            placeStr = "输入取消订单原因(选填)"
            imageName = "commit_cancel_order"
        case .refuseReturnGoods:
            titleStr = "拒绝退货"
            successStr = "确认拒绝退货？"
            placeStr = "输入拒绝退货原因(选填)"
            imageName = "commit_refuse_back"
        default:
            titleStr = ""
            successStr = ""
            placeStr = ""
            imageName = ""
       }
        
        self.title = titleStr
        self.successLab.text = successStr
        self.inputTV.placeholder = placeStr
        self.successImgView.image = UIImage.init(named: imageName)
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
        if self.operateType == .cancleOrder{
            self.cancelOrderInIndex()
        }
        else if self.operateType == .cancleAfterSales{
            self.commitCancelAfterSale()
        }
        else if self.operateType == .applyForReturningGoods || self.operateType == .applyForExchangingGoods {
            self.commitApplyAfterSale(id: selOrder?.id ?? 0, type: afterSaleType)
        }
        else if self.operateType == .refuseReturnGoods {
            self.refuseAfterSales()
        }
    }
    
    @objc func cancelBtnClick(sender: UIButton){
        self.popVC()
    }
    
    //MARK: - network
    // 取消售后
    func commitCancelAfterSale(){
        self.noNetwork = false
        let remark = inputTV.text ?? ""
        ApiLoadingProvider.request(PAPI.cancelAfterSale(id:selChangingOrRefundingItem?.id ?? 0,remark: remark), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                let completeVC = CompleteScanRenewVC()
                completeVC.operateType = self.operateType
                self.navigationController?.pushViewController(completeVC, animated: true)
                 NotificationCenter.default.post(name: Notification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
            }
        }
    }
    
    // 申请退货、换货 -- Type 1:换货  2:退货退款
    func commitApplyAfterSale(id:Int, type:Int){
        self.noNetwork = false
        let remark = inputTV.text ?? ""
        ApiLoadingProvider.request(PAPI.applyAfterSale(id: id, type: type, remark:remark), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                let completeVC = CompleteScanRenewVC()
                completeVC.operateType = self.operateType
                self.navigationController?.pushViewController(completeVC, animated: true)
                if type == 1 {
                   NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
                }
                else{
                    NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
                }
            }
        }
    }
    
    // 取消订单
    func cancelOrderInIndex(){
        self.noNetwork = false
         let remark = inputTV.text ?? ""
        ApiLoadingProvider.request(PAPI.cancelOrder(id: selOrder?.id ?? 0, remark: remark), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
               let completeVC = CompleteScanRenewVC()
                completeVC.operateType = self.operateType
                self.navigationController?.pushViewController(completeVC, animated: true)
              NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
            }
        }
    }
    
    // 拒绝售后
    func refuseAfterSales(){
        self.noNetwork = false
        let remark = inputTV.text ?? ""
        ApiLoadingProvider.request(PAPI.refuseAfterSale(id: selChangingOrRefundingItem?.id ?? 0, remark: remark), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                let completeVC = CompleteScanRenewVC()
                completeVC.operateType = self.operateType
                self.navigationController?.pushViewController(completeVC, animated: true)
                NotificationCenter.default.post(name: Notification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
            }
        }
    }
    
    // MARK: - UI
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
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "确认",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(120, g: 153, b: 255), placeText: "取消",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        btn.setCornerRadius(radius: 6)
        btn.addBorder(width: 1, color: RGB(133, g: 163, b: 255))
        return btn
    }()
    
    func configUI(){
        
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-45)
        }
        
        bgView.addSubview(successImgView)
        successImgView.snp.makeConstraints { (make) in
            make.width.equalTo(108 * kDrawdownRatioW)
            make.height.equalTo(108 * kDrawdownRatioW)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(33 * kDrawdownRatioW)
        }
        
        bgView.addSubview(successLab)
        successLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(successImgView.snp.bottom).offset(12)
        }
        
        bgView.addSubview(inputTV)
        inputTV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(successLab.snp.bottom).offset(53 * kDrawdownRatioW)
            make.height.equalTo(135 * kDrawdownRatioW)
        }
        
        bgView.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        bgView.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45)
            make.bottom.equalTo(cancleBtn.snp.top).offset(-16)
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 50, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
    }
}

extension CommitAddRemarkVC {
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

