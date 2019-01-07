//
//  UserInfoHeadCell.swift
//  EntranceGuardV2.0
//
//  Created by 杜鹏 on 2017/7/14.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit

class UserInfoHeadCell: UITableViewCell {
     var headClick: (() -> Void)?
    var  imageV:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.frame = CGRect(x:30*kRatioToIP6W, y:
            contentView.centerY - 7, width: 120,height:14)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.textLabel?.textColor = RGB(68, g: 68, b: 68)
        self.textLabel?.font = UIFont.systemFont(ofSize: 15)
//        self.accessoryType = .none
//        self.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "-e-箭头1"))

        imageV = UIImageView.init(frame: CGRect.init(x:SCREEN_WIDTH -  45.5 * kRatioToIP6W - 50, y: 12.5, w: 50 , h: 50))
        imageV.image = nil
        imageV.layer.cornerRadius = 25
        imageV.layer.masksToBounds = true
        contentView.addSubview(imageV)
        
        imageV.addTapGesture { (tap:UITapGestureRecognizer) in
            self.headClick?()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
