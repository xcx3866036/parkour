//
//  OrderInfoView.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/28.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SnapKit

class OrderInfoView: UIView {

    lazy var infoNoBtn: CSButton = {
        let Nobtn = CSButton.init(frame: CGRect.init())
        Nobtn.imagePositionMode = .left
        Nobtn.setTitleColor(RGB(45, g: 80, b: 255), for: .normal)
        Nobtn.titleLabel?.font = UIFont.systemFont(ofSize: 23)
        Nobtn.isUserInteractionEnabled = false
        return Nobtn
    }()
    
    lazy var infoLab: UILabel = {
        let infoLab = UILabel.init(x: 0, y: 0, w: 0, h: 0, fontSize: 13)
        infoLab.textColor = RGB(32, g: 32, b: 32)
        infoLab.textAlignment = .center
        return infoLab
    }()

    func configInfo(imgaeName: String?, infoNoStr:String, infoStr:String) {
        if let imageNameStr = imgaeName {
            infoNoBtn.setImage(UIImage.init(named: imageNameStr), for: .normal)
            
        }
        infoNoBtn.setTitle(infoNoStr, for: .normal)
        infoLab.text = infoStr
       
        self.addSubview(infoNoBtn)
        self.addSubview(infoLab)
        
        infoNoBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.height.equalTo(28)
            make.left.right.equalToSuperview()
        }
        
        infoLab.snp.makeConstraints { (make) in
            make.top.equalTo(infoNoBtn.snp.bottom).offset(2)
            make.height.equalTo(20)
            make.left.right.equalToSuperview()
        }
    }
    
    // TODO: - 重建约束
    func reloadInfo(imgaeName: String?, infoNoStr:String, infoStr:String){
        
    }
}
