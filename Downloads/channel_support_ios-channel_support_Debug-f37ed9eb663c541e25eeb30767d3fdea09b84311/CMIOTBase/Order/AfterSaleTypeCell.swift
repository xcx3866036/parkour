//
//  AfterSaleTypeCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class AfterSaleTypeCell: UITableViewCell {

    
    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        bgView.setCornerRadius(radius: 6)
        bgView.addShadow(offset: CGSize.init(width: 0, height: 12), radius: 15, color: RGB(211, g: 220, b: 229), opacity: 1)
        return bgView
    }()
    
    lazy var markLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 21, color: UIColor.white, placeText: "")
        lab.font = UIFont.boldSystemFont(ofSize: 21)
        lab.numberOfLines = 0
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var tipsLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 17, color: RGB(135, g: 135, b: 135), placeText: "")
        return lab
    }()
    
    lazy var markImgView: UIImageView = {
        let bgView = UIFactoryGenerateImgView(imageName: "img_placeholder")
        return bgView
    }()
    
    lazy var rightView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "group_rep_right")
        return imgView
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
            make.height.equalTo(100)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(8)
        }
        
        bgView.addSubview(markImgView)
        markImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.left.top.equalToSuperview()
        }
        
        markImgView.addSubview(markLab)
        markLab.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        bgView.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        bgView.addSubview(tipsLab)
        tipsLab.snp.makeConstraints { (make) in
            make.left.equalTo(markImgView.snp.right).offset(15)
            make.right.equalTo(rightView.snp.left).offset(-5)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configInfoByIndex(index: Int, goodsDays: Int) {
        let imgName = index == 0 ? "aftersale_type1" : "aftersale_type2"
        var tipsStr = ""
        let markStr = index == 0 ? "换货" : "退货\n退款"
        if index == 0 {
            tipsStr = goodsDays <= 0 ? "不支持质保换货" : String(goodsDays) + "天内支持质保换货"
        }
        else {
            tipsStr = goodsDays <= 0 ? "不支持退货退款" : String(goodsDays) + "天内支持退货退款"
        }
        markImgView.image = UIImage.init(named: imgName)
        tipsLab.text = tipsStr
        markLab.text = markStr
    }
    
}
