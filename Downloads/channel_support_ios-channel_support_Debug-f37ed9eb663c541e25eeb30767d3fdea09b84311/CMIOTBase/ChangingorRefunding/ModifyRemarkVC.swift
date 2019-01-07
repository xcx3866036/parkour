//
//  ModifyRemarkVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/25.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SVProgressHUD

class ModifyRemarkVC: UIViewController,UITextViewDelegate {
    
    let kMaxLength:Int = 256
    var operateType: Int = 0       // 0: 订单   1：服务单
    var selOrder: OrderInofListItemModel?
    var selChangingOrRefundingItem:AfterSaleServiceInfofListItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改备注"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
    }
    
    func configUI(){
        
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        
        bgView.addSubview(inputTV)
        inputTV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(135 )
        }
        
        bgView.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45)
            make.top.equalTo(inputTV.snp.bottom).offset(80)
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 50, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        bgView.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45)
            make.top.equalTo(commitBtn.snp.bottom).offset(16)
        }
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
//        let completeVC = CompleteScanRenewVC()
//        completeVC.operateType = self.operateType
//        self.navigationController?.pushViewController(completeVC, animated: true)
        self.modifyOrderRemark()
    }
    
    @objc func cancelBtnClick(sender: UIButton){
        self.popVC()
    }
    
    //MARK: - network
    // 修改订单备注
    func modifyOrderRemark(){
        let remark = inputTV.text.trimmed()
        guard remark.length > 0 else {
            SVProgressHUD.showInfo(withStatus: "请添加备注！")
            return
        }
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.modifyOrderRemark(id: selOrder?.id ?? 0,remark: remark), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                let result = self.backToSpecificVC(VCName: "OrderManagerVC")
                if result == false {
                    let _ = self.backToSpecificVC(VCName: "ChangingOrRefundingVC")
                }
            }
        }
    }
    
    // MARK: - UI属性
    lazy var cancleBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(120, g: 153, b: 255), placeText: "取消",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(cancelBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        btn.setCornerRadius(radius: 6)
        btn.addBorder(width: 1, color: RGB(133, g: 163, b: 255))
        return btn
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = RGB(255, g: 255, b: 255)
        return bgView
    }()
    
    lazy var inputTV: KMPlaceholderTextView = {
        let input = KMPlaceholderTextView()
        input.font = UIFont.systemFont(ofSize: 15)
        input.textColor = RGB(88, g: 88, b: 88)
        input.placeholderColor = RGB(148, g: 148, b: 148)
        input.placeholder = "输入备注信息(选填)"
        input.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        input.addBorder(width: 0.5, color: RGB(216, g: 216, b: 216))
        input.delegate = self
        return input
    }()
    
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "保存修改",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
}

extension ModifyRemarkVC {
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
