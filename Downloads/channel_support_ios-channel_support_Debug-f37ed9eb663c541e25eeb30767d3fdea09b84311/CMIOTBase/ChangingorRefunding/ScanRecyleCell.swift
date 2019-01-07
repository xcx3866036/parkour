//
//  ScanRecyleCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/24.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ScanRecyleCell: UITableViewCell {
    
    var index: Int = 0
    var btnClickBlock: ((_ type:Int,_ index:Int) -> ())?
    
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = UIColor.white
        return bgview
    }()
    
    lazy var NobgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.addBorder(width: 0.5, color: RGB(230, g: 230, b: 230))
        view.setCornerRadius(radius: 4)
        return view
    }()
    
    lazy var matchingImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "matching_mark")
        return imgView
    }()
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 10, color: UIColor.white, placeText: "", imageName: "exchange_scan")
        btn.addTarget(self, action: #selector(scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 15, color: RGB(176, g: 176, b: 176), placeText: "某品牌路由器")
        return lab
    }()
    
    lazy var originNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(159, g: 159, b: 159), placeText: "产品编码")
        return lab
    }()
    
    lazy var newNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(42, g: 42, b: 42), placeText: "67348UY-7686564_34")
        lab.addTapGesture(target: self, action: #selector(inputTapClick(sender:)))
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
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview()
        }
        
        bgView.addSubview(NobgView)
        NobgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(40)
        }
        
        NobgView.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(31)
            make.right.equalToSuperview().offset(-17)
            make.centerY.equalToSuperview()
        }
        
        
        NobgView.addSubview(matchingImgView)
        matchingImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.left.top.equalToSuperview()
        }
        
        NobgView.addSubview(originNoLab)
        originNoLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(58)
        }
        
        NobgView.addSubview(newNoLab)
        newNoLab.snp.makeConstraints { (make) in
            make.left.equalTo(originNoLab.snp.right).offset(9)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.right.equalTo(scanBtn.snp.left).offset(-4)
        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.top.equalTo(NobgView.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
    }
    
    func configRecyleGoodsInfo(info:OutGoodsModel,isReturn:Bool){
        matchingImgView.isHidden = true
        nameLab.text = info.productName
        if isReturn {
            if let barCode = info.barCode, barCode.length > 0 {
                matchingImgView.isHidden = !(barCode == (info.exchangeOutGoods?.barCode ?? ""))
            }
            if let newbarCode = info.exchangeOutGoods?.barCode, newbarCode.length > 0{
                newNoLab.text = newbarCode
                newNoLab.textColor = RGB(42, g: 42, b: 42)
            }
            else{
                newNoLab.text = "请输入产品编码"
                newNoLab.textColor = RGB(159, g: 159, b: 159)
            }
        }
        else {
             matchingImgView.isHidden = !info.isSatisfyRecyle()
             newNoLab.text = info.barCode
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func scanBtnClick(sender: UIButton) {
        if let click = btnClickBlock {
            click(1,index)
        }
    }
    
    @objc func inputTapClick(sender: UITapGestureRecognizer){
        if let click = btnClickBlock {
            click(0,index)
        }
    }
    
}
