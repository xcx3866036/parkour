//
//  ProductInfoCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/28.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ProductInfoCell: UITableViewCell {

    lazy var bgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "home_white_bg")
        return imgView
    }()
    
    lazy var markImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "home_info")
        return imgView
    }()
    
    lazy var mainTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(34, g: 34, b: 34)
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        lab.text = "产品资料"
        return lab
    }()
    
    lazy var subTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(34, g: 34, b: 34)
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.text = "Product Information"
        return lab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(-10)
        }
        
        self.contentView.addSubview(markImgView)
        markImgView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-28)
            make.top.equalToSuperview().offset(7)
            make.width.height.equalTo(60)
        }
        
        self.contentView.addSubview(mainTitle)
        mainTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(28)
            make.top.equalToSuperview().offset(17)
            make.height.equalTo(23)
            make.right.equalTo(markImgView.snp.left)
        }
        
        self.contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(28)
            make.top.equalTo(mainTitle.snp.bottom).offset(2)
            make.height.equalTo(23)
            make.right.equalTo(markImgView.snp.left)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
