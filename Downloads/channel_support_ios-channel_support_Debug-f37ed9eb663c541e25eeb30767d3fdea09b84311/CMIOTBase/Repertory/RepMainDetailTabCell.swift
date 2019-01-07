//
//  RepMainDetailTabCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/30.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class RepMainDetailTabCell: UITableViewCell {

    lazy var titleBtn: UIButton = {
        let btn = UIButton()
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(RGB(28, g: 28, b: 28), for: .normal)
        btn.setTitleColor(RGB(25, g: 81, b: 255), for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleBtn)
        titleBtn.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configInfo(title: String, isSelected: Bool) {
        titleBtn.setTitle(title, for: .normal)
        titleBtn.isSelected = isSelected
    }
}
