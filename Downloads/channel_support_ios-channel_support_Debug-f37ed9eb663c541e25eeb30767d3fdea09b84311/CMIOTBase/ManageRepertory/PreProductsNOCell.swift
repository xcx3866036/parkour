//
//  PreProductsNOCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class PreProductsNOCell: UITableViewCell {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.isHidden =  true
        return bgView
    }()
    
    lazy var markView: UIView = {
        let bgView = UIView.init()
        bgView.backgroundColor = RGB(216, g: 216, b: 216)
        bgView.setCornerRadius(radius: 2.5)
        return bgView
    }()
    
    lazy var productTitleLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: UIColor.black, placeText: "产品编号：")
        return lab
    }()
    
    lazy var productNOLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 11, color: RGB(33, g: 33, b: 33), placeText: "CPBH-234522234234")
        lab.numberOfLines = 0
        return lab
    }()
    
    lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(235, g: 237, b: 243)
        return line
    }()
    
    lazy var detailBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "服务详情", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(detailBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var cellClickBlock: ((Int) -> ())?
    var index: Int = 0
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
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        self.contentView.addSubview(detailBtn)
        detailBtn.snp.makeConstraints { (make) in
            make.width.equalTo(62)
            make.height.equalTo(21)
            make.right.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(markView)
        markView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(31)
            make.width.height.equalTo(5)
            make.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(productTitleLab)
        productTitleLab.snp.makeConstraints { (make) in
           make.left.equalTo(markView.snp.right).offset(8)
           make.bottom.top.equalToSuperview()
           make.width.equalTo(80)
        }
        
        self.contentView.addSubview(productNOLab)
        productNOLab.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLab.snp.right).offset(0)
            make.bottom.top.right.equalToSuperview()
        }
        
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        detailBtn.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detailBtnClick(sender:UIButton){
        if let click = cellClickBlock {
            click(index)
        }
    }
    
    func configGroupStaffRepInfo(type: ReperttoryType, count: Int) {
        
    }
    
    func configOrderInfoByInfo(info: OrderInofListItemModel,index:Int){
        
        self.backgroundColor = UIColor.clear
        bgView.isHidden = false
        bottomLine.isHidden = true
        let amount = info.amount ?? 0
        let amountStr = String.init(format: "%.2f", amount)
        let payType = info.payWay ?? 0
        var payTypeStr = ""
        if payType == 2 {
            payTypeStr = "支付宝支付"
        }
        else if payType == 3{
            payTypeStr = "微信支付"
        }
        else if payType == 6{
            payTypeStr = "银联支付"
        }
        let mainArr = [(RGB(255, g: 140, b: 86),"商品合计：","¥" + amountStr),
                       (RGB(86, g: 187, b: 255),"订单编号：",info.orderNo ?? ""),
                       (RGB(121, g: 159, b: 255),"下单时间：",info.createTime ?? ""),
                       (RGB(96, g: 255, b: 199),"支付时间：",info.payTime ?? ""),
                       (RGB(241, g: 209, b: 20),"支付方式：",payTypeStr)]
        markView.backgroundColor = mainArr[index].0
        
        let mainStr = ""
        let subStr = mainArr[index].2
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(69, g: 69, b: 69),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let mainAttStr = NSMutableAttributedString.init(string: mainStr, attributes: singleAttribute3)
        let subAttStr = NSAttributedString.init(string: subStr, attributes: singleAttribute4)
        mainAttStr.append(subAttStr)
        productTitleLab.text = mainArr[index].1
        productNOLab.attributedText = mainAttStr
    }
    
    func configOrderChangingOrTrfundingInfo(info:OrderDetailModel?,index:Int){
        
        productNOLab.snp.remakeConstraints { (make) in
            make.left.equalTo(productTitleLab.snp.right).offset(0)
            make.bottom.top.equalToSuperview()
            make.right.equalTo(detailBtn.snp.left).offset(-5)
        }
        
        self.backgroundColor = UIColor.clear
        bgView.isHidden = false
        bottomLine.isHidden = true
        
        let infoStr = info?.serviceNo ?? ""
        let mainStr = ""
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(69, g: 69, b: 69),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let mainAttStr = NSMutableAttributedString.init(string: mainStr, attributes: singleAttribute3)
        let subAttStr = NSAttributedString.init(string: infoStr, attributes: singleAttribute4)
        mainAttStr.append(subAttStr)
        productTitleLab.text = "服务单号："
        productNOLab.attributedText = mainAttStr
        markView.backgroundColor = RGB(86, g: 187, b: 255)
    }
    
    func configChangingOrTrfundingInfoByIndex(afterSalesInfo: AfterSaleServiceInfofListItemModel,
                                              detail:AfterSaleServiceInfoModel?,
                                              index:Int){
        
        self.backgroundColor = UIColor.clear
        bgView.isHidden = false
        bottomLine.isHidden = true
        
        let afterSales = afterSalesInfo.configAfterSalesStatusInfo()
        
        let mainArr: [(UIColor,String,String)] =
            [(RGB(255, g: 140, b: 86),"服务类型：",afterSales.listStatusStr),
            (RGB(86, g: 187, b: 255),"服务单编号：",detail?.serviceNo ?? ""),
            (RGB(121, g: 159, b: 255),"申请时间：",detail?.createTime ?? ""),
            (RGB(96, g: 255, b: 199),"退款时间：",detail?.refundTime ?? ""),
            (RGB(241, g: 209, b: 20),"退换数量：",String(detail?.goodsCount ?? 0)),
            (RGB(241, g: 209, b: 20),"原订单编号：",detail?.orderNo ?? "")]
        
        markView.backgroundColor = mainArr[index].0
        
        let mainStr = ""
        let subStr = mainArr[index].2
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(69, g: 69, b: 69),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let mainAttStr = NSMutableAttributedString.init(string: mainStr, attributes: singleAttribute3)
        let subAttStr = NSAttributedString.init(string: subStr, attributes: singleAttribute4)
        mainAttStr.append(subAttStr)
        productTitleLab.text = mainArr[index].1
        productNOLab.attributedText = mainAttStr
    }
    
    func configOrderChangingOrTrfundingInfoByIndex(info:AfterSaleServiceInfoModel?,index:Int){
        productNOLab.snp.remakeConstraints { (make) in
            make.left.equalTo(productTitleLab.snp.right).offset(0)
            make.bottom.top.equalToSuperview()
            make.right.equalTo(detailBtn.snp.left).offset(-5)
        }
        
        
        self.backgroundColor = UIColor.clear
        bgView.isHidden = false
        bottomLine.isHidden = true
         markView.backgroundColor = RGB(86, g: 187, b: 255)
        
        detailBtn.setTitle("查看订单", for: .normal)
        let orderNo = info?.order?.orderNo ?? ""
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: UIColor.black,
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(69, g: 69, b: 69),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        let mainAttStr = NSMutableAttributedString.init(string: "", attributes: singleAttribute3)
        let subAttStr = NSAttributedString.init(string: orderNo, attributes: singleAttribute4)
        mainAttStr.append(subAttStr)
        productTitleLab.text = "原订单编号："
        productNOLab.attributedText = mainAttStr
    }
    
    func configPreGoodsInfo(info:GoodsModel){
        productTitleLab.text = "产品编号："
        productNOLab.text = info.barCode ?? ""
    }
}
