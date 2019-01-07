//
//  ChangedProductsCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ChangedProductsCell: UITableViewCell {
    
    var index: Int = 0
    var cellClickBlock: ((Int,Int) -> ())?
    
    lazy var bgView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.white
        bgView.setCornerRadius(radius: 6)
        bgView.addShadow(offset: CGSize.init(width: 0, height: 12), radius: 15, color: RGB(211, g: 220, b: 229), opacity: 1)
        return bgView
    }()
    
    lazy var productImgView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.image = UIImage.init(named: "img_placeholder")
        return imgView
    }()
    
    lazy var productNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(61, g: 61, b: 61), placeText: "某物品名称JUI-86 ¥%……DDF…")
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var priceLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(255, g: 75, b: 75), placeText: "¥199.00")
        return lab
    }()
    
    lazy var countLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(25, g: 81, b: 255), placeText: "× 0")
        return lab
    }()
    
    lazy var decrementButton: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 10, color: UIColor.white, placeText: "", imageName: "goods_reduce")
        return btn
    }()
    
    lazy var incrementButton: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 10, color: UIColor.white, placeText: "", imageName: "goods_add")
        return btn
    }()
    
    lazy var countingLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: RGB(47, g: 47, b: 47), placeText: "0")
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var stepView: KWStepper = {
        let stepper = KWStepper(decrementButton: decrementButton, incrementButton: incrementButton)
        stepper.autoRepeat = false
        stepper.autoRepeatInterval = 0.10
        stepper.wraps = false
        stepper.minimumValue = 0
        stepper.maximumValue = 100
        stepper.value = 0
        stepper.incrementStepValue = 1
        stepper.decrementStepValue = 1
        return stepper
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
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        
        bgView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(90)
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview().offset(17)
        }
        
        bgView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(productImgView.snp.right).offset(5)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
        bgView.addSubview(priceLab)
        priceLab.snp.makeConstraints { (make) in
            make.height.equalTo(21)
            make.left.equalTo(productNameLab.snp.left)
            make.right.equalTo(productNameLab.snp.right)
            make.top.equalTo(productNameLab.snp.bottom).offset(8)
        }
        
        bgView.addSubview(incrementButton)
        incrementButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        bgView.addSubview(countingLab)
        countingLab.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-17)
            make.right.equalTo(incrementButton.snp.left)
        }
        
        bgView.addSubview(decrementButton)
        decrementButton.snp.makeConstraints { (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-17)
            make.right.equalTo(countingLab.snp.left)
        }
        
        bgView.addSubview(countLab)
        countLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-17)
            make.height.equalTo(22)
            make.left.equalTo(productNameLab.snp.left)
            make.right.equalTo(decrementButton.snp.left).offset(-10)
        }
        
        stepView
            .maximumValue(100)
            .valueChanged { [unowned self] stepper in
                let stepValue = String(format: "%.f", stepper.value)
                self.countLab.text = "× " + stepValue
                self.countingLab.text = String(format: "%.f", stepper.value)
                if let click = self.cellClickBlock {
                    click(self.index, Int(stepper.value))
                }
            }
            .valueClamped { [unowned self] stepper in
//                self.presentValueClampedAlert()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configGroupStaffRepInfo(type: ReperttoryType, count: Int) {
        
        //        let countStr = type == .MyReperttoryType ? "个人存储量  " : "数量  "
        //        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(34, g: 34, b: 34) ]
        //        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(36, g: 100, b: 249)]
        //
        //        let countAttStr = NSMutableAttributedString.init(string: countStr, attributes: singleAttribute1)
        //        let subCountAttStr = NSAttributedString.init(string: String(count), attributes: singleAttribute2)
        //        countAttStr.append(subCountAttStr)
        //
        //        productCountLab.attributedText = countAttStr
    }
}
