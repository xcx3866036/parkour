//
//  HistoryGroupUsersCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class HistoryGroupUsersCell: UICollectionViewCell {
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = RGB(247, g: 248, b: 251)
        view.setCornerRadius(radius: 22.5)
        return view
    }()
    
    lazy var lastNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 17, color: UIColor.white, placeText: "锤")
        lab.textAlignment = .center
        lab.setCornerRadius(radius: 17.5)
        lab.backgroundColor = RGB(68, g: 158, b: 248)
        return lab
    }()
    
    lazy var markBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 10, color: UIColor.white, placeText: "", imageName: "step_normal")
        btn.setImage(UIImage.init(named: "step_selected"), for: .selected)
        btn.isUserInteractionEnabled  = false
        return btn
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 17, color: UIColor.white, placeText: "")
        return lab
    }()
    
    lazy var topLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(235, g: 237, b: 243)
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(45)
            make.right.equalToSuperview().offset(-12)
        }
        
        bgView.addSubview(lastNameLab)
        lastNameLab.snp.makeConstraints { (make) in
            make.width.height.equalTo(33)
            make.left.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
        }
        
//        self.contentView.addSubview(markBtn)
//        markBtn.snp.makeConstraints { (make) in
//            make.width.height.equalTo(20)
//            make.right.equalToSuperview().offset(-14)
//            make.centerY.equalTo(lastNameLab.snp.centerY)
//        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(lastNameLab.snp.right).offset(4)
            make.centerY.equalTo(lastNameLab.snp.centerY)
            make.height.equalTo(20)
            make.right.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHistoryUserInfo(info:UserModel,isSelected: Bool){
        let userName = info.employeeName ?? ""
        if userName.length > 0 {
            self.lastNameLab.text = String(userName.last ?? " ")
        }
        else{
            self.lastNameLab.text = ""
        }
        
        self.configSelectUserName(userName: userName, groupName: info.groupName ?? "", isSelected: isSelected)
    }
    
    func configSelectUserName(userName: String, groupName: String, isSelected: Bool) {
        
        let groupNameStr = " (" + groupName + ")"
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: RGB(46, g: 46, b: 46),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(200, g: 200, b: 200),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        
        let userNameAttStr = NSMutableAttributedString.init(string: userName, attributes: singleAttribute3)
        let groupAttStr = NSAttributedString.init(string: groupNameStr, attributes: singleAttribute4)
        userNameAttStr.append(groupAttStr)
        nameLab.attributedText = userNameAttStr
        
        markBtn.isSelected = isSelected
    }
}
