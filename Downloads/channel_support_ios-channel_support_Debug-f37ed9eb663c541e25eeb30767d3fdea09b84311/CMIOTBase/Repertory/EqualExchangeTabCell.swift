//
//  EqualExchangeTabCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class EqualExchangeTabCell: UITableViewCell, UITextFieldDelegate {

    var index: Int = 0
    // type 0: 文本输入 1:扫描
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
    
    lazy var productImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "img_placeholder")
        return imgView
    }()
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 10, color: UIColor.white, placeText: "", imageName: "exchange_scan")
        btn.addTarget(self, action: #selector(scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var markImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "matching_mark")
        return imgView
    }()
    
    lazy var productNameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(61, g: 61, b: 61), placeText: "某品牌路由器")
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        return lab
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(242, g: 130, b: 10), placeText: "李四")
        lab.backgroundColor = RGB(243, g: 243, b: 243)
        lab.textAlignment = .center
        lab.adjustsFontSizeToFitWidth = true
        lab.setCornerRadius(radius: 4)
        return lab
    }()
    
    lazy var newNoTF: UITextField = {
        let TFView = UIFactoryGenerateTextField(fontSize: 14, color: RGB(42, g: 42, b: 42), placeText: "请输入编号")
//        TFView.addTapGesture(target: self, action: #selector(inputTapClick(sender:)))
        TFView.delegate = self
        return TFView
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
    
    @objc func inputTapClick(){
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
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
        }
        
        bgView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(23)
            make.left.equalToSuperview().offset(7)
            make.right.equalToSuperview().offset(-7)
        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLab.snp.bottom).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(61)
            make.left.equalTo(productNameLab.snp.left)
        }
        
        bgView.addSubview(NobgView)
        NobgView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(nameLab.snp.right).offset(10)
            make.top.equalTo(nameLab.snp.top)
            make.right.equalToSuperview().offset(-8)
        }
        
        NobgView.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(31)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        
        NobgView.addSubview(markImgView)
        markImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(12)
            make.left.top.equalToSuperview()
        }
        
        NobgView.addSubview(newNoTF)
        newNoTF.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(scanBtn.snp.left).offset(-4)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
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
    
    func configEqualExchangeTabCellWith(name: String, NoStr: String) {
//        let fullNoStr = "  产品编码：" + NoStr
//        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(255, g: 117, b: 0) ]
//        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(42, g: 42, b: 42)]
//
//        let fullNoAttStr = NSMutableAttributedString.init(string: name, attributes: singleAttribute1)
//        let subNoAttStr = NSAttributedString.init(string: String(fullNoStr), attributes: singleAttribute2)
//        fullNoAttStr.append(subNoAttStr)
        newNoTF.text = NoStr
    }
    
    func configGoodsBackInfo(info:OutGoodsModel){
        productNameLab.text = info.productName ?? ""
        nameLab.text = info.currentHolderName ?? ""
        newNoTF.text = info.barCode ?? ""
        markImgView.isHidden = !(info.isSatisfyBack())
    }
}

//MARK: - UITextFieldDelegate
extension EqualExchangeTabCell {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.inputTapClick()
        return false
    }
}
