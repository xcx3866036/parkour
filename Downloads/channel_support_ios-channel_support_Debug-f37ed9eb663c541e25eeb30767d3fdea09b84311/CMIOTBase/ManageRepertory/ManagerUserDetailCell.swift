//
//  ManagerUserDetailCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ManagerUserDetailCell: UITableViewCell {
    
    lazy var userNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 185, color: RGB(34, g: 34, b: 34), placeText: "产品名称IGFG_989")
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        return lab
    }()
    
    lazy var userNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 185, color: RGB(108, g: 108, b: 108), placeText: "产品编号： 848474823434")
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
        self.contentView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(userNameLab)
        userNameLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(9)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(rightView.snp.left).offset(-5)
        }
        
        self.contentView.addSubview(userNoLab)
        userNoLab.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLab.snp.bottom)
            make.height.equalTo(17)
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
    
    func configManagerUserDetailInfo(type: ReperttoryType, infoStr: String) {
        
    }
    
    //
    func configBackDetailInfo(info:ReturnEmployeeDetailsListModel){
        userNameLab.text = "产品名称： " + (info.productName ?? "")
        userNoLab.text = "产品编号： " + (info.barCode ?? "")
        rightView.isHidden = (info.isBad ?? 0) == 0
    }
    
    func configOutDetailInfo(info:EmployeeDimensionOutListModel){
        userNameLab.text = "产品名称： " + (info.productName ?? "")
        userNoLab.text = "产品编号： " + (info.barCode ?? "")
        rightView.isHidden = (info.isBad ?? 0) == 0
    }
    
}
