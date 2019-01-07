//
//  SelectProductGroupCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/30.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class SelectProductGroupCell: UITableViewCell {
    
    lazy var groupNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(255, g: 255, b: 255), placeText: "")
        lab.textAlignment = .center
        lab.adjustsFontSizeToFitWidth = true
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
        self.contentView.addSubview(groupNameLab)
        groupNameLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-17)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
