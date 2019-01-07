//
//  SelectUserInGroupCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class SelectUserInGroupCell: UITableViewCell {

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
        
        self.contentView.addSubview(lastNameLab)
        lastNameLab.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview().offset(15)
        }
        
        self.contentView.addSubview(markBtn)
        markBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.right.equalToSuperview().offset(-14)
            make.centerY.equalTo(lastNameLab.snp.centerY)
        }
        
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(lastNameLab.snp.right).offset(8)
            make.centerY.equalTo(lastNameLab.snp.centerY)
            make.height.equalTo(20)
            make.right.equalTo(markBtn.snp.left).offset(4)
        }
        
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSelectUserInfo(info:UserModel,isSelected: Bool){
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
