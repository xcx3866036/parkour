//
//  CheckBackGoodsVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/12.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class CheckBackGoodsVC: UIViewController {
    
    var selectedIndex: Int = 0
    var selChangingOrRefundingItem:AfterSaleServiceInfofListItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "退货检查"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
    }
    
    func updateUI(){
        let btn0 = bgView.viewWithTag(5000 + 0) as? UIButton
        let btn1 = bgView.viewWithTag(5000 + 1) as? UIButton
        let btn2 = bgView.viewWithTag(5000 + 2) as? UIButton
        btn0?.isSelected = selectedIndex == 0
        btn1?.isSelected = selectedIndex == 1
        btn2?.isSelected = selectedIndex == 2
        refuseBtn.isHidden = selectedIndex == 0 || selectedIndex == 1
        commitBtn.isHidden = selectedIndex == 2
    }
    
    func updateCheckSuccessUI(){
        let scanVC = ScanRecycleVC()
        scanVC.type = .forReturn
        scanVC.selChangingOrRefundingItem = self.selChangingOrRefundingItem
        self.navigationController?.pushViewController(scanVC, animated: true)
         NotificationCenter.default.post(name: Notification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
        self.commitAgreeReturnGoods()
    }
    
    @objc func refuseBtnClick(sender: UIButton){
        let commitVC = CommitAddRemarkVC()
        commitVC.operateType = .refuseReturnGoods
        commitVC.selChangingOrRefundingItem = self.selChangingOrRefundingItem
        self.navigationController?.pushViewController(commitVC, animated: true)
    }
    
    @objc func qualityBtnClick(sender: UIButton) {
        let tag = sender.tag - 5000
        selectedIndex = tag
        updateUI()
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
        stepIndicatorView.currentStep = 1
        stepIndicatorView.stepWith = 60
        stepIndicatorView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 15 - 15, height: 72)
        return stepIndicatorView
    }()
    
    lazy var bgView: UIScrollView = {
        let bgView = UIScrollView()
        bgView.contentSize = CGSize.init(width: SCREEN_WIDTH - 15 - 15, height: 329)
        bgView.backgroundColor = RGB(255, g: 255, b: 255)
        bgView.alwaysBounceVertical = false
        return bgView
    }()
    
    
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "确认满足退货条件",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    lazy var refuseBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(25, g: 81, b: 255), placeText: "拒绝退货",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(refuseBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(255, g: 255, b: 255)
        btn.setCornerRadius(radius: 6)
        btn.addBorder(width: 1, color: RGB(25, g: 81, b: 255))
        btn.isHidden = true
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
        
        self.view.addSubview(refuseBtn)
        refuseBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
            }
        }
        
        self.view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 30, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(commitBtn.snp.top).offset(-45)
            make.top.equalToSuperview().offset(96)
        }
        
        let checks = ["请确认产品包装、配件、吊牌等是否完好",
                      "非质量问题时不得影响二次销售",
                      "非质量问题退货需扣除相应上门服务费用"]
        let checkColors = [RGB(255, g: 140, b: 86),
                           RGB(86, g: 187, b: 255),
                           RGB(121, g: 159, b: 255)]
        
        let checkTitleLab = UIFactoryGenerateLab(fontSize: 15, color: RGB(28, g: 28, b: 28), placeText: "退货检查")
        checkTitleLab.font = UIFont.boldSystemFont(ofSize: 15)
        bgView.addSubview(checkTitleLab)
        checkTitleLab.snp.makeConstraints { (make) in
            make.height.equalTo(21)
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
        }
        
        for(index, color) in checkColors.enumerated() {
            let markView = UIView()
            markView.backgroundColor = color
            markView.setCornerRadius(radius: 3)
            bgView.addSubview(markView)
            markView.snp.makeConstraints { (make) in
                make.height.width.equalTo(6)
                make.left.equalToSuperview().offset(19)
                make.top.equalTo(checkTitleLab.snp.bottom).offset(index * 19 + index * 6 + 21)
            }
            
            let markLab = UIFactoryGenerateLab(fontSize: 15 * kDrawdownRatioW, color: RGB(125, g: 125, b: 125), placeText: checks[index])
            bgView.addSubview(markLab)
            markLab.snp.makeConstraints { (make) in
                make.height.equalTo(21)
                make.left.equalTo(markView.snp.right).offset(5)
                make.right.equalToSuperview()
                make.centerY.equalTo(markView.snp.centerY)
            }
        }
        
        let lineView = UIView()
        lineView.backgroundColor = RGB(210, g: 210, b: 210)
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(checkTitleLab.snp.bottom).offset(115)
        }
        
        let qualitys = [" 产品包装、配件、吊牌等有质量问题",
                        " 产品无质量问题，且不影响二次销售",
                        " 产品无质量问题，影响二次销售"]
        
        let qualityTitleLab = UIFactoryGenerateLab(fontSize: 15, color: RGB(28, g: 28, b: 28), placeText: "质量评估")
        qualityTitleLab.font = UIFont.boldSystemFont(ofSize: 15)
        bgView.addSubview(qualityTitleLab)
        qualityTitleLab.snp.makeConstraints { (make) in
            make.height.equalTo(21)
            make.top.equalTo(lineView.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
        }
        
        for(index,qualityStr) in qualitys.enumerated() {
            let btn = UIFactoryGenerateBtn(fontSize: 15 * kDrawdownRatioW, color: RGB(28, g: 28, b: 28), placeText: qualityStr, imageName: "step_normal")
            btn.setImage(UIImage.init(named: "step_selected"), for: .selected)
            btn.isSelected = index == selectedIndex
            btn.tag = 5000 + index
            btn.addTarget(self, action: #selector(qualityBtnClick(sender:)), for: .touchUpInside)
            btn.contentHorizontalAlignment = .left
            bgView.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.height.equalTo(21)
                make.left.equalToSuperview().offset(25)
                make.right.equalToSuperview()
                make.top.equalTo(qualityTitleLab.snp.bottom).offset(index * 20 + index * 21 + 18)
            }
        }
    }
    
}

//MARK: Network
extension CheckBackGoodsVC {
   
    func commitAgreeReturnGoods(){
        self.noNetwork = false
        let operationType = self.selectedIndex == 0 ? 1 : 2
        ApiLoadingProvider.request(PAPI.agreeReturnGoods(id: selChangingOrRefundingItem?.id ?? 0, operationType: operationType), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                self.updateCheckSuccessUI()
            }
        }
    }
}
