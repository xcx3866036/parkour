//
//  OrderRemarksCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class OrderRemarksCell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
   
    lazy var remarksLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: RGB(69, g: 69, b: 69), placeText: "")
        lab.numberOfLines = 0
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
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        bgView.addSubview(remarksLab)
        remarksLab.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configRemarksStr(remarks: String) {
        remarksLab.text = remarks
    }
    
}
