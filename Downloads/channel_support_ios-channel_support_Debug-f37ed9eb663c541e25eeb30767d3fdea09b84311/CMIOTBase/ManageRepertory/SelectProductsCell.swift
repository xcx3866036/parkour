//
//  SelectProductsCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class SelectProductsCell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var productImgView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.image = UIImage.init(named: "img_placeholder")
        return imgView
    }()
    
    lazy var productNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(34, g: 34, b: 34), placeText: "某物品名称JUI-86 ¥%……DDF…")
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var countLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(255, g: 255, b: 255), placeText: "9")
        lab.textAlignment = .center
        lab.backgroundColor = RGB(255, g: 79, b: 0)
        lab.setCornerRadius(radius: 9)
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    lazy var rightView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "group_rep_right")
        return imgView
    }()
    
    lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(235, g: 237, b: 243)
        return line
    }()
    
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
        
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
        }
        
        bgView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(65)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(6)
        }
        
        bgView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-32)
        }
        
        bgView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.right.equalTo(rightView.snp.left).offset(-9)
        }
        
        bgView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView.snp.right).offset(16)
            make.bottom.top.equalToSuperview()
            make.right.equalTo(countLab.snp.left).offset(-16)
        }
        
        bgView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configGroupStaffRepInfo(type: ReperttoryType, count: Int) {
        
//        let countStr = type == .MyReperttoryType ? "个人存储量  " : "数量  "
//        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(34, g: 34, b: 34) ]
//        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(36, g: 100, b: 249)]
//
//        let countAttStr = NSMutableAttributedString.init(string: countStr, attributes: singleAttribute1)
//        let subCountAttStr = NSAttributedString.init(string: String(count), attributes: singleAttribute2)
//        countAttStr.append(subCountAttStr)
//
//        productCountLab.attributedText = countAttStr
    }
    
    func configGroupProductInfo(info:ProductModel,count:Int){
        let path = info.picturePath?.creatProdcutFullUrlString(imageType: 1) ?? ""
        productImgView.setImageUrl(path, placeholder: UIImage.init(named: "img_placeholder"))
        productNameLab.text = info.productName
        countLab.text = String(count)
        countLab.isHidden = count <= 0
    }
}
