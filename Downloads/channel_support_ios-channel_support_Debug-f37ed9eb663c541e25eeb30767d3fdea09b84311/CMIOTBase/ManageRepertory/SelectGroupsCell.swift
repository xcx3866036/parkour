//
//  SelectGroupsCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class SelectGroupsCell: UITableViewCell {

    lazy var topLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(235, g: 237, b: 243)
        return line
    }()
    
    lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(235, g: 237, b: 243)
        return line
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(35, g: 35, b: 35), placeText: "组装3组")
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.adjustsFontSizeToFitWidth = true
        return lab
    }()
    
    lazy var groupImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "group_mark")
        return imgView
    }()
    
    lazy var countLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: RGB(127, g: 127, b: 127), placeText: "20人")
        return lab
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
        
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-31)
            make.top.equalToSuperview().offset(10)
        }
        self.contentView.addSubview(groupImgView)
        groupImgView.snp.makeConstraints { (make) in
            make.width.equalTo(11)
            make.height.equalTo(12)
            make.top.equalTo(nameLab.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(33)
        }
        
        self.contentView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.top.equalTo(nameLab.snp.bottom).offset(2)
            make.left.equalTo(groupImgView.snp.right).offset(5)
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configGroupListInfo(info:EmployeeGroupModel){
        nameLab.text = info.groupName ?? ""
        countLab.text = String(info.employeeCount ?? 0) + "人"
    }
}
