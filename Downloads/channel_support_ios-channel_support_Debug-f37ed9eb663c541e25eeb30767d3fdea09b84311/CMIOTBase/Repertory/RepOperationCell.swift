//
//  RepOperationCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class RepOperationCell: UITableViewCell {

    
    lazy var cellBg: UIImageView = {
        let imgView = UIImageView()
//        imgView.image = UIImage.init(named: "rep_operation_bg")
        imgView.backgroundColor = UIColor.white
        return imgView
    }()
    
    lazy var markLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var mainTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(28, g: 28, b: 28)
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        lab.text = "产品佣金/销售技巧"
        return lab
    }()
    
    lazy var subTitle: UILabel = {
        let lab = UILabel()
        lab.textColor = RGB(28, g: 28, b: 28)
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.text = "Commission/Technique"
        return lab
    }()
    
    lazy var markImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init()
        return imgView
    }()
    
    lazy var rightView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "group_rep_right")
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(cellBg)
        cellBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
        }
        
        cellBg.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.width.equalTo(6)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-34)
        }
        
        self.contentView.addSubview(markImgView)
        markImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(31)
            make.height.width.equalTo(80)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(mainTitle)
        mainTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(34)
            make.left.equalTo(markImgView.snp.right).offset(35)
            make.height.equalTo(25)
            make.right.equalTo(rightView.snp.left).offset(-5)
        }
        
        self.contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(mainTitle.snp.bottom).offset(0)
            make.left.equalTo(markImgView.snp.right).offset(35)
            make.height.equalTo(22)
            make.right.equalTo(rightView.snp.left).offset(-5)
        }
        
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configInfoByIndex(index: Int) {
        switch index {
        case 0:
            markLineView.backgroundColor = RGB(255, g: 72, b: 72)
            mainTitle.text = "产品佣金/销售技巧"
            subTitle.text = "Commission/Technique"
            markImgView.image = UIImage.init(named: "rep_skill")
        case 1:
            markLineView.backgroundColor = RGB(0, g: 226, b: 93)
            mainTitle.text = "组内库存查询"
            subTitle.text = "Inventory Query"
            markImgView.image = UIImage.init(named: "rep_search")
        case 2:
            markLineView.backgroundColor = RGB(51, g: 114, b: 255)
            mainTitle.text = "组内换货"
            subTitle.text = "Exchange Goods"
            markImgView.image = UIImage.init(named: "rep_change")
        default:
            markLineView.backgroundColor = UIColor.clear
            mainTitle.text = ""
            subTitle.text = ""
            markImgView.image = UIImage.init()
        }
    }
    
    func configManagerInfoByIndex(index: Int) {
        switch index {
        case 0:
            markLineView.backgroundColor = RGB(255, g: 72, b: 72)
            mainTitle.text = "产品预出"
            subTitle.text = "Product Pre-exit"
            markImgView.image = UIImage.init(named: "manager_pre")
        case 1:
            markLineView.backgroundColor = RGB(0, g: 226, b: 93)
            mainTitle.text = "产品退还"
            subTitle.text = "Product Return"
            markImgView.image = UIImage.init(named: "manager_back")
        default:
            markLineView.backgroundColor = UIColor.clear
            mainTitle.text = ""
            subTitle.text = ""
            markImgView.image = UIImage.init()
        }
    }
}
