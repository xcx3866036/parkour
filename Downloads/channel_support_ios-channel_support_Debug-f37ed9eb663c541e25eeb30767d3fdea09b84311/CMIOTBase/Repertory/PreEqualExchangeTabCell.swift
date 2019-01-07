//
//  PreEqualExchangeTabCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/24.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

// BWSwipeRevealCell

class PreEqualExchangeTabCell: UITableViewCell {
    
    var index: Int = 0
    // type: 0 文本输入  1: 扫码
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
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 10, color: UIColor.white, placeText: "", imageName: "exchange_scan")
        btn.addTarget(self, action: #selector(scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var originNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(159, g: 159, b: 159), placeText: "产品编码")
        return lab
    }()
    
    lazy var newNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(42, g: 42, b: 42), placeText: "67348UY-7686564_34")
        lab.addTapGesture(target: self, action: #selector(noLabTapClick(sender:)))
        return lab
    }()
    
    lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(235, g: 237, b: 243)
        return line
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func scanBtnClick(sender: UIButton) {
        if let click = btnClickBlock {
            click(1,index)
        }
    }
    
    @objc func noLabTapClick(sender: UITapGestureRecognizer){
        if let click = btnClickBlock {
            click(0,index)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = RGB(247, g: 248, b: 251)
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview()
        }
        
        bgView.addSubview(NobgView)
        NobgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(46)
        }
        
        NobgView.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(31)
            make.right.equalToSuperview().offset(-17)
            make.centerY.equalToSuperview()
        }
        
        NobgView.addSubview(originNoLab)
        originNoLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
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
        
        bgView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configPreProductInfo(info:GoodsModel){
        newNoLab.text = info.barCode ?? ""
        
    }
    
    func configEqualExchangeTabCellWith(name: String, NoStr: String) {
        //        let fullNoStr = "  产品编码：" + NoStr
        //        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(255, g: 117, b: 0) ]
        //        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(42, g: 42, b: 42)]
        //
        //        let fullNoAttStr = NSMutableAttributedString.init(string: name, attributes: singleAttribute1)
        //        let subNoAttStr = NSAttributedString.init(string: String(fullNoStr), attributes: singleAttribute2)
        //        fullNoAttStr.append(subNoAttStr)
//        newNoTF.text = NoStr
    }
    
}
