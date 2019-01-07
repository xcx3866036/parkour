//
//  GroupStaffRepDetailCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class GroupStaffRepDetailCell: UITableViewCell {

    var index = 0
    var cellClickBlock: ((Int) -> ())?
    
    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        bgView.setCornerRadius(radius: 6)
        bgView.addShadow(offset: CGSize.init(width: 0, height: 12), radius: 15, color: RGB(211, g: 220, b: 229), opacity: 1)
        return bgView
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "明")
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        lab.backgroundColor = RGB(250, g: 114, b: 114)
        lab.setCornerRadius(radius: 20)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var userNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(34, g: 34, b: 34), placeText: "王小明")
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        return lab
    }()
    
    lazy var useTelLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(0, g: 109, b: 238), placeText: "")
        lab.textAlignment = .center
        lab.addTapGesture(target: self, action: #selector(callPhoneNumber(seder:)))
        return lab
    }()
    
    lazy var useTelImg: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "rep_call")
        imgView.addTapGesture(target: self, action: #selector(callPhoneNumber(seder:)))
        return imgView
    }()
    
    lazy var productCountLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(36, g: 100, b: 247), placeText: "")
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var rightView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "group_rep_right")
        return imgView
    }()
    
    let colorS = [RGB(250, g: 114, b: 114),RGB(78, g: 225, b: 106),RGB(239, g: 206, b: 73),
                  RGB(104, g: 185, b: 244),RGB(71, g: 229, b: 187),RGB(235, g: 97, b: 211)]
    
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
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(65)
        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(12)
        }
        
        bgView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bgView.addSubview(userNameLab)
        userNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(12)
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(80)
        }
        
        bgView.addSubview(useTelLab)
        useTelLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(12)
            make.top.equalTo(userNameLab.snp.bottom).offset(3)
            make.height.equalTo(21)
            make.width.equalTo(100)
        }
        
        bgView.addSubview(useTelImg)
        useTelImg.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.height.equalTo(14)
            make.left.equalTo(useTelLab.snp.right).offset(7)
            make.top.equalTo(useTelLab.snp.top).offset(4)
        }
        
        bgView.addSubview(productCountLab)
        productCountLab.snp.makeConstraints { (make) in
            make.left.equalTo(userNameLab.snp.right)
            make.centerY.equalToSuperview()
//            make.right.equalTo(rightView.snp.left).offset(-15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(21)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func callPhoneNumber(seder: UITapGestureRecognizer){
        if let click = cellClickBlock {
            click(index)
        }
    }
    func configGroupStaffRep(infoModel:GroupStockDetailsItemModel, index: Int){
        let count = infoModel.stockCount ?? 0
        let phoneStr = infoModel.cellphone ?? ""
        let name = infoModel.employeeName ?? " "
        self.nameLab.text = String(name.suffix(1))
        self.userNameLab.text = name
        self.configGroupStaffRepInfo(count: count, index: index,phoneStr:phoneStr)
    }
    
    
    func configGroupStaffRepInfo(count: Int, index: Int,phoneStr:String) {
        
        let colorCount = colorS.count
        let colorIndex = index % colorCount
        nameLab.backgroundColor = colorS[colorIndex]
        
        let countStr = "储量  "
        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(34, g: 34, b: 34) ]
        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(35, g: 35, b: 35)]
        
        let countAttStr = NSMutableAttributedString.init(string: countStr, attributes: singleAttribute1)
        let subCountAttStr = NSAttributedString.init(string: String(count), attributes: singleAttribute2)
        countAttStr.append(subCountAttStr)
        
        productCountLab.attributedText = countAttStr
        
        let singleAttribute3 = [NSAttributedStringKey.underlineColor: RGB(0, g: 109, b: 238),
                                 NSAttributedStringKey.underlineStyle: 1] as [NSAttributedStringKey : Any]
        
        let phoneAttStr = NSMutableAttributedString.init(string: phoneStr, attributes: singleAttribute3)
        useTelLab.attributedText = phoneAttStr
    }
}
