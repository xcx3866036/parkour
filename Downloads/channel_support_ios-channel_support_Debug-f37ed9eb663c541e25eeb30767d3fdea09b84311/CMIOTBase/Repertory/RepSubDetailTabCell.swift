//
//  RepSubDetailTabCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/30.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class RepSubDetailTabCell: UITableViewCell {

    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(34, g: 34, b: 34)
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.text = "某物品名称"
        
        return lab
    }()
    
    lazy var markImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "rep_mark_bad")
        return imgView
    }()
    
    lazy var noLab: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(34, g: 34, b: 34)
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.text = "产品编号：848348437"
        
        return lab
    }()
    
    lazy var typeLab: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(34, g: 34, b: 34)
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.text = "退货退回"
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var dateLab: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(34, g: 34, b: 34)
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.text = "2018-09-17"
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var bottomLineView: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(216, g: 216, b: 216)
        return line
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = RGB(247, g: 248, b: 251)
        self.contentView.addSubview(typeLab)
        typeLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(dateLab)
        dateLab.snp.makeConstraints { (make) in
            make.top.lessThanOrEqualTo(typeLab.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(17)
            make.height.equalTo(21)
            make.right.equalTo(typeLab.snp.left).offset(-15 - 2 - 2)
        }
        
        self.contentView.addSubview(markImgView)
        markImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.centerY.equalTo(nameLab.snp.centerY)
            make.left.equalTo(nameLab.snp.right).offset(2)
        }
        
        self.contentView.addSubview(noLab)
        noLab.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(17)
            make.height.equalTo(17)
            make.right.equalTo(dateLab.snp.left)
        }
        
        self.contentView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.bottom.right.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configRepetoryDetailInfo(info:ProductStockDetailsItemModel){
        nameLab.text = info.productName
        noLab.text = "产品编号：" + (info.barCode ?? "")
        dateLab.text = info.operationDate ?? ""
        typeLab.text = info.getCurrentStatusStr()
        markImgView.isHidden = (info.isBad ?? 0) == 0
    }

}
