//
//  GroupStaffRepProductCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class GroupStaffRepProductCell: UITableViewCell {

    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = UIColor.white
        return bgview
    }()
    
    lazy var userNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 185, color: RGB(34, g: 34, b: 34), placeText: "")
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        return lab
    }()
    
    lazy var rightView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "rep_mark_bad")
        return imgView
    }()
    
    lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(216, g: 216, b: 216)
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
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        bgView.isHidden = true
        
        self.contentView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(userNameLab)
        userNameLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(rightView.snp.left).offset(-5)
        }
        
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configGroupStaffRepProductInfo(type: ReperttoryType, info: ProductStockDetailsItemModel){
        let infoStr =  type == .MyReperttoryType ? info.barCode ?? "" : info.createUserName ?? ""
        self.configGroupStaffRepProductInfo(type: type, infoStr: infoStr)
        rightView.isHidden = (info.isBad ?? 0) == 0
    }
    
    func configInputProductInfo(info: ProductStockDetailsItemModel){
        bgView.isHidden = false
        userNameLab.font = UIFont.systemFont(ofSize: 14)
        userNameLab.textColor = RGB(34, g: 34, b: 34)
        rightView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-26)
        }
        userNameLab.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(27)
            make.right.equalTo(rightView.snp.left).offset(-5)
        }
        bottomLine.snp.remakeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        
        let infoStr =  info.barCode ?? ""
        self.configGroupStaffRepProductInfo(type: .MyReperttoryType, infoStr: infoStr)
        rightView.isHidden = (info.isBad ?? 0) == 0
    }
    
    
    func configGroupStaffRepProductInfo(type: ReperttoryType, infoStr: String) {
        let titleStr = type == .MyReperttoryType ? "产品编号：" : "员工姓名："
        let fullInfo = titleStr + infoStr
        userNameLab.text = fullInfo
    }
    
}
