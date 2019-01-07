//
//  moduleColCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/28.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SnapKit

class ModuleColCell: UICollectionViewCell {
    
    lazy var moduleImgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    lazy var authorityImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "home_suspend")
        return imgView
    }()
    
    lazy var moduleNameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.textColor = RGB(81, g: 81, b: 81)
        nameLab.textAlignment = .center
        nameLab.font = UIFont.boldSystemFont(ofSize: 15)
        return nameLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setCornerRadius(radius: 0)
        
        self.contentView.addSubview(moduleImgView)
        moduleImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(23)
            make.width.height.equalTo(47)
        }
        
        self.contentView.addSubview(moduleNameLab)
        moduleNameLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(moduleImgView.snp.bottom).offset(13)
            make.height.equalTo(21)
        }
        
        self.contentView.addSubview(authorityImgView)
        authorityImgView.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(24)
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configModuleInfoByIndex(index: Int) {
        let info = self.moduleInfoWithIndex(index: index)
        moduleImgView.image = UIImage.init(named: info.imageName)
        moduleNameLab.text = info.name
    }
    
    
    func moduleInfoWithIndex(index: Int) -> (imageName: String, name: String) {
        switch index {
        case 0:
            return ("home_sell", "销售下单")
        case 1:
            return ("home_order", "订单管理")
        case 2:
            return ("home_back", "退换货处理")
        case 3:
            return ("home_reward", "我的酬金")
        case 4:
            return ("home_repertory", "我的库存")
        case 5:
            return ("home_repertory_manager", "库存管理")
        default:
            return ("", "")
        }
    }
}
