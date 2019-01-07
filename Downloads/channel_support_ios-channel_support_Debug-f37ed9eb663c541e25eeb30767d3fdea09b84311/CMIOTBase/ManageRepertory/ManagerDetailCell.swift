//
//  ManagerDetailCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ManagerDetailCell: UITableViewCell {

    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        bgView.setCornerRadius(radius: 6)
        bgView.addShadow(offset: CGSize.init(width: 0, height: 12), radius: 15, color: RGB(211, g: 220, b: 229), opacity: 1)
        return bgView
    }()
    
    lazy var countLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(255, g: 255, b: 255), placeText: "7\n数量")
        lab.numberOfLines = 2
        lab.textAlignment = .center
        lab.backgroundColor = RGB(6, g: 220, b: 116)
        return lab
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(88, g: 88, b: 88), placeText: "李开家")
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        return lab
    }()
    
    lazy var dateLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(125, g: 125, b: 125), placeText: "2018-09-23")
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
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(80)
            make.top.equalToSuperview().offset(8)
            make.left.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        bgView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.left.top.equalToSuperview().offset(10)
        }
        
        bgView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.height.equalTo(23)
            make.left.equalTo(countLab.snp.right).offset(13)
            make.top.equalToSuperview().offset(19)
            make.right.equalTo(rightView.snp.left)
        }
        
        bgView.addSubview(dateLab)
        dateLab.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(nameLab.snp.left)
            make.top.equalTo(nameLab.snp.bottom).offset(0)
            make.right.equalTo(rightView.snp.left)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configBackDetailInfo(info:EmployeeDimensionReturnListModel){
        let total = info.totalReturn ?? 0
        self.countLab.text = String(total) + "\n数量"
        self.nameLab.text = info.employeeName
        self.dateLab.text = info.operationDate
    }
    
    func configOutDetailInfo(info:EmployeeDimensionReturnListModel){
        let total = info.total ?? 0
        self.countLab.text = String(total) + "\n数量"
        self.nameLab.text = info.employeeName
        self.dateLab.text = info.operationDate
    }

}
