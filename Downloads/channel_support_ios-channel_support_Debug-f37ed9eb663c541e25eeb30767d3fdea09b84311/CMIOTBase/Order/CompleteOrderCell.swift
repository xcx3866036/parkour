//
//  CompleteOrderCell.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class CompleteOrderCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource{

    var index: Int = 0
    var productImages = [String]()
    var btnClickBlock: ((_ type:Int,_ index:Int) -> ())?
    var collectionClickBlock: ((_ index:Int) -> ())?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    lazy var statusLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(31, g: 121, b: 255), placeText: "已完成")
        lab.font = UIFont.boldSystemFont(ofSize: 14)
        lab.textAlignment = .right
        return lab
    }()
    
    lazy var orderNoLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(28, g: 28, b: 28), placeText: "订单号：173563477283")
        return lab
    }()
    
    lazy var goodsCountLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 12, color: RGB(28, g: 28, b: 28), placeText: "商品数量")
        return lab
    }()
    
    lazy var sumLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 12, color: RGB(28, g: 28, b: 28), placeText: "实付款")
        return lab
    }()
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "扫码安装", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(scanBtnClick(sender:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "取消订单", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(cancleBtnClick(sender:)), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = RGB(236, g: 236, b: 236)
        return line
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let itemWidth = 70
        
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        
        let collectionView = UICollectionView.init(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView.register(OrderProductImgCell.classForCoder(), forCellWithReuseIdentifier: "completeOrderIdentifier")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
       collectionView.addTapGesture(target: self, action: #selector(collectionClick))
        return collectionView
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
        self.selectionStyle = .none
        
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        bgView.addSubview(statusLab)
        statusLab.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        bgView.addSubview(orderNoLab)
        orderNoLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(statusLab.snp.left)
        }
        
        bgView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(70)
            make.top.equalTo(orderNoLab.snp.bottom).offset(13)
        }
        
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(collectionView.snp.bottom).offset(13)
        }
        
        bgView.addSubview(goodsCountLab)
        goodsCountLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(17)
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
        
        bgView.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-9)
           make.top.equalTo(lineView.snp.bottom).offset(29)
        }
        
        bgView.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.right.equalTo(scanBtn.snp.left).offset(-10)
            make.top.equalTo(lineView.snp.bottom).offset(29)
        }
        
        bgView.addSubview(sumLab)
        sumLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalTo(cancleBtn.snp.left).offset(-4)
            make.height.equalTo(21)
            make.top.equalTo(goodsCountLab.snp.bottom).offset(7)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    @objc func scanBtnClick(sender: UIButton){
        print("scan")
        if let click = self.btnClickBlock {
            click(1,index)
        }
    }
    
    @objc func cancleBtnClick(sender: UIButton){
        print("cancel")
        if let click = self.btnClickBlock {
            click(0,index)
        }
    }
    
    @objc func collectionClick(sender: UITapGestureRecognizer){
        print("cancel")
        if let click = self.collectionClickBlock {
            click(index)
        }
    }
    
    func configOderListInfo(info: OrderInofListItemModel){
        self.orderNoLab.text = "订单号：" + (info.orderNo ?? "")
        self.configCompleteOrderCellGoodsInfo(count: info.goodsCount ?? 0, sumPrice: info.amount ?? 0.0)
        
        let resultInfo = info.configOrderStatusInfo()
        let btnTitle = resultInfo.btnStr
        cancleBtn.isHidden = resultInfo.isHidenCancle
        scanBtn.isHidden = false
        scanBtn.setTitle(btnTitle, for: .normal)
        statusLab.text = resultInfo.listStatusStr
        productImages = info.picturePaths ?? [String]()
        if btnTitle.length <= 0 {
            scanBtn.isHidden = true
        }
        collectionView.reloadData()
    }
    
    func configCompleteOrderCellGoodsInfo(count: Int, sumPrice: Double){
        let countStr = "商品数量 "
        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(36, g: 36, b: 36) ]
        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(30, g: 107, b: 255)]
        
        let countAttStr = NSMutableAttributedString.init(string: countStr, attributes: singleAttribute1)
        let subCountAttStr = NSAttributedString.init(string: String(count), attributes: singleAttribute2)
        countAttStr.append(subCountAttStr)
        
        goodsCountLab.attributedText = countAttStr
        
        let sumStr = "实付款"
        let sumPriceStr = "￥" + String(sumPrice)
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: RGB(36, g: 36, b: 36),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(255, g: 75, b: 75),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        let sumAttStr = NSMutableAttributedString.init(string: sumStr, attributes: singleAttribute3)
        let subSumAttStr = NSAttributedString.init(string: sumPriceStr, attributes: singleAttribute4)
        sumAttStr.append(subSumAttStr)
        
        sumLab.attributedText = sumAttStr
    }
}

// MARK: - CollectionViewDelegate  CollectionViewDataSource
extension CompleteOrderCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "completeOrderIdentifier", for: indexPath) as! OrderProductImgCell
        let subPath = productImages[indexPath.row]
        if subPath.length > 0 {
            let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
            cell.productImgView.setImageUrl(imageFullPath, placeholder: UIImage.init(named: "img_placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
