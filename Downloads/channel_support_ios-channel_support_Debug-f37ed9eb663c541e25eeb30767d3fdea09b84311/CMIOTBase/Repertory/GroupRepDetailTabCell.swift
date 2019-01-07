//
//  GroupRepDetailTabCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class GroupRepDetailTabCell: UITableViewCell {

    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        bgView.setCornerRadius(radius: 6)
        bgView.addShadow(offset: CGSize.init(width: 0, height: 12), radius: 15, color: RGB(211, g: 220, b: 229), opacity: 1)
        return bgView
    }()
    
    lazy var productImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "img_placeholder")
        imgView.backgroundColor = UIColor.clear
        return imgView
    }()
    
    lazy var productNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(34, g: 34, b: 34), placeText: "某物品名称")
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        return lab
    }()
    
    lazy var productCountLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(36, g: 100, b: 247), placeText: "")
        return lab
    }()
    
    lazy var rightView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "group_rep_right")
        return imgView
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
        self.backgroundColor = RGB(247, g: 248, b: 251)
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(105)
        }
        
        bgView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(75)
            make.left.equalToSuperview().offset(11)
            make.top.equalToSuperview().offset(15)
        }
        
        bgView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bgView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView.snp.right).offset(12)
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(28)
            make.right.equalTo(rightView.snp.left)
        }
        
        bgView.addSubview(productCountLab)
        productCountLab.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLab.snp.left)
            make.top.equalTo(productNameLab.snp.bottom).offset(3)
            make.height.equalTo(21)
            make.right.equalTo(rightView.snp.left)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configGroupStaffRepInfo(type: ReperttoryType, infoModel: ProductDimensionStockItemModel){
        productNameLab.text = infoModel.productName
        let count = infoModel.stockCount ?? 0
        self.configGroupStaffRepInfo(type: type, count: count,index:0)
        productNameLab.text = infoModel.productName ?? ""
        let imagePath = infoModel.picturePath ?? ""
        let fullPath = imagePath.creatProdcutFullUrlString(imageType: 1)
        productImgView.setImageUrl(fullPath, placeholder: UIImage.init(named: "img_placeholder"))
    }
    
    func configGroupStaffRepInfo(type: ReperttoryType, count: Int, index:Int) {
    
        let countStr = type == .MyReperttoryType ? "个人存储量  " : "数量  "
        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(34, g: 34, b: 34) ]
        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(36, g: 100, b: 249)]
        
        let countAttStr = NSMutableAttributedString.init(string: countStr, attributes: singleAttribute1)
        let subCountAttStr = NSAttributedString.init(string: String(count), attributes: singleAttribute2)
        countAttStr.append(subCountAttStr)
        
        productCountLab.attributedText = countAttStr
    }
}
