//
//  ScanRenewCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/12.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class ScanRenewCell: UITableViewCell,UITextFieldDelegate {

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
    
    lazy var nameLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(61, g: 61, b: 61), placeText: "某品牌路由器")
        lab.font = UIFont.boldSystemFont(ofSize: 16)
        return lab
    }()
    
    lazy var originNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 12, color: RGB(109, g: 109, b: 109), placeText: "原编码 12132423")
        return lab
    }()
    
    lazy var newNoTF: UITextField = {
        let TFView = UIFactoryGenerateTextField(fontSize: 14, color: RGB(42, g: 42, b: 42), placeText: "请输入编号")
        TFView.delegate = self
//        TFView.addTapGesture(target: self, action: #selector(inputTapClick(sender:)))
        return TFView
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
        
        bgView.addSubview(productImgView)
        productImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(90)
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(productImgView.snp.right).offset(5)
            make.top.equalTo(productImgView.snp.top)
            make.height.equalTo(23)
            make.right.equalToSuperview()
        }
        
        bgView.addSubview(originNoLab)
        originNoLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.left)
            make.top.equalTo(nameLab.snp.bottom).offset(0)
            make.height.equalTo(17)
            make.right.equalTo(nameLab.snp.right)
        }
        
        bgView.addSubview(NobgView)
        NobgView.snp.makeConstraints { (make) in
            make.height.equalTo(46)
            make.left.equalTo(nameLab.snp.left)
            make.bottom.equalTo(productImgView.snp.bottom)
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
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(scanBtn.snp.left).offset(-4)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
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
    
    @objc func inputTapClick(){
        if let click = btnClickBlock {
            click(0,index)
        }
    }
    
    func configRenewInfo(info:OutGoodsModel){
        let fullPath = (info.picturePath ?? "").creatProdcutFullUrlString(imageType: 1)
        nameLab.text = info.productName
        originNoLab.text = "原编码 " + (info.barCode ?? "")
        productImgView.setImageUrl(fullPath, placeholder: UIImage.init(named: "img_placeholder"))
        newNoTF.text = info.exchangeOutGoods?.barCode
        markImgView.isHidden = !(info.exchangeOutGoods?.isSatisfyExchangeNew() ?? false)
    }
}

//MARK: - UITextFieldDelegate
extension ScanRenewCell {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        self.inputTapClick()
        return false
    }
}
