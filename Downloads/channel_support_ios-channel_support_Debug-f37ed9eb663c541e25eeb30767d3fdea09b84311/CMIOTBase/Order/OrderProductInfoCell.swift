//
//  OrderProductInfoCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class OrderProductInfoCell: UITableViewCell {

    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(61, g: 61, b: 61), placeText: "")
        return lab
    }()
    
    lazy var noLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 12, color: RGB(105, g: 105, b: 105), placeText: "")
        return lab
    }()
    
    lazy var priceLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(255, g: 75, b: 75), placeText: "")
        return lab
    }()
    
    lazy var productImgView: UIImageView = {
        let bgView = UIFactoryGenerateImgView(imageName: "img_placeholder")
        return bgView
    }()
    
    var selIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        bgView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(90)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.height.equalTo(23)
            make.left.equalTo(productImgView.snp.right).offset(7)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(productImgView.snp.top).offset(4)
        }
        
        bgView.addSubview(noLab)
        noLab.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.right.equalToSuperview().offset(-8)
            make.left.equalTo(productImgView.snp.right).offset(7)
            make.top.equalTo(nameLab.snp.bottom).offset(7)
        }
        
        bgView.addSubview(priceLab)
        priceLab.snp.makeConstraints { (make) in
            make.height.equalTo(21)
            make.right.equalToSuperview().offset(-8)
            make.left.equalTo(productImgView.snp.right).offset(7)
            make.top.equalTo(noLab.snp.bottom).offset(13)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configProductInfo(infoModel:OrderDetailProductModel?){
        if let info = infoModel{
            nameLab.text = info.productName
            noLab.text = "产品编码：" + (info.barCode ?? "")
            priceLab.text = "¥" + String.init(format: "%.2f", info.price ?? 0.0)
            let subPath = info.picturePath ?? ""
            if subPath.length > 0 {
                let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
                 productImgView.setImageUrl(imageFullPath, placeholder: UIImage.init(named: "img_placeholder"))
            }
        }
    }
    
    func configInfoByIndex(index: Int) {
       let imageName = "image_" + String(selIndex + 1)
        self.productImgView.image = UIImage.init(named: imageName)
    }
    
}
