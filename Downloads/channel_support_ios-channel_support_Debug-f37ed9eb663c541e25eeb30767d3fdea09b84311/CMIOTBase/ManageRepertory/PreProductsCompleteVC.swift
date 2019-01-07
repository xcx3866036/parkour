//
//  PreProductsCompleteVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class PreProductsCompleteVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "预出库"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
    }
    
    override func backToUpVC() {
       let _ = self.backToSpecificVC(VCName: "ManagerRepertoryVC")
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
       let _ = self.backToSpecificVC(VCName: "ManagerRepertoryVC")
    }
    
    //MARK:- UI
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
        let lab = UIFactoryGenerateLab(fontSize: 21, color: RGB(88, g: 88, b: 88), placeText: "预出库成功")
        lab.font = UIFont.boldSystemFont(ofSize: 21)
        lab.textAlignment = .center
        return lab
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
            make.height.equalTo(237)
        }
        
        bgView.addSubview(successImgView)
        successImgView.snp.makeConstraints { (make) in
            make.width.equalTo(81)
            make.height.equalTo(102)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-43)
        }
        
        bgView.addSubview(successLab)
        successLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(successImgView.snp.bottom).offset(16)
        }
        
        
        bgView.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
}

