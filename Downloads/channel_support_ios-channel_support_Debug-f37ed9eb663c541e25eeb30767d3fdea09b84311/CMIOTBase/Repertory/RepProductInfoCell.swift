//
//  RepProductInfoCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/10.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class RepProductInfoCell: UICollectionViewCell {
    lazy var productImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "img_placeholder")
        return imgView
    }()
    
    lazy var productNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(61, g: 61, b: 61), placeText: "某品牌路由器")
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        return lab
    }()
    
    lazy var moneyLab: UILabel = {
         let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(61, g: 61, b: 61), placeText: "")
        return lab
    }()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        let itemWidth = (SCREEN_WIDTH - 4) / 2
        
        self.contentView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(itemWidth)
            make.left.top.equalToSuperview()
        }
        self.contentView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.top.equalTo(productImgView.snp.bottom).offset(7)
            make.height.equalTo(23)
            make.right.equalToSuperview().offset(-8)
        }
        
        self.contentView.addSubview(moneyLab)
        moneyLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.top.equalTo(productNameLab.snp.bottom).offset(2)
            make.height.equalTo(21)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configRepProductInfo(infoModel:ProductCommissionDetailsModel){
        let fullPath = (infoModel.picturePath ?? "").creatProdcutFullUrlString(imageType: 1)
        self.productImgView.setImageUrl(fullPath, placeholder: UIImage.init(named: "img_placeholder"))
        self.productNameLab.text = infoModel.productName ?? ""
        self.configRepProdunctInfoByPrice(price: infoModel.salePrice ?? 0.0, commission: infoModel.commission?.commission ?? 0.0)
    }
    
    func configRepProdunctInfoByPrice(price: Double,commission: Double){
        let priceStr = String.init(format: "%.2f", price)
        let commissionStr = String.init(format: "%.2f", commission)
        let priceFullStr = "￥" + priceStr + "  "
        let commissionFullStr = "佣金" + commissionStr
        
        let singleAttribute1 = [NSAttributedStringKey.foregroundColor: RGB(23, g: 97, b: 255),
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        let singleAttribute2 = [NSAttributedStringKey.foregroundColor: RGB(255, g: 75, b: 75),
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let countAttStr = NSMutableAttributedString.init(string: priceFullStr, attributes: singleAttribute1)
        let subCountAttStr = NSAttributedString.init(string: String(commissionFullStr), attributes: singleAttribute2)
        countAttStr.append(subCountAttStr)
        self.moneyLab.attributedText = countAttStr
    }
}
