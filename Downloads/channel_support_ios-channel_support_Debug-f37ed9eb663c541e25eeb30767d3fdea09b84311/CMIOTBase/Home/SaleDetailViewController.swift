//
//  SaleDetailViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import PPBadgeViewSwift
import DZNEmptyDataSet
import SVProgressHUD
class SaleDetailViewController: UIViewController {

    @IBOutlet weak var imageCollection: UICollectionView!
    

    @IBOutlet weak var leftCarView: UIView!
    @IBOutlet weak var addCarBt: UIButton!
    @IBOutlet weak var okBt: UIButton!
    @IBOutlet weak var carTab: UITableView!
    @IBOutlet weak var carView: UIView!
    var titleName:String?
    @IBOutlet weak var carImage: UIImageView!
    var centerImageArr:[String] = []
    var model:ProductModel?
    var showImage :UIImage?
    
    var isShow:Bool!
    var productNum:Int = 0 //当前产品数量
    var carArr:[CartItemListItemModel] = []
    var dataArr:[(CGFloat, UIImage)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        isShow = false
        self.title = titleName
        
        let shareBar = UIBarButtonItem.init(image: UIImage.init(named: "product_share"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(shareProduct(sender:)))
        self.navigationItem.rightBarButtonItem = shareBar
        
        self.loadData()
        self.loadCarData()
        
        self.view.backgroundColor = UIColor.colorWithHexString(hex: "#F4FAFF")
        carImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showCar))
        carImage.addGestureRecognizer(gesture)
        
        
        let user = UserModel.read()
        let app_xiaosou = user?.app_xiaosou ?? 0
        if(app_xiaosou != 1){
            leftCarView.isHidden = true
            addCarBt.isHidden = true
            okBt.isHidden = true
            
            self.imageCollection.snp.makeConstraints { (make) in
                make.height.equalToSuperview()
            }
            
        }else{
            leftCarView.isHidden = false
            addCarBt.isHidden = false
            okBt.isHidden = false
        }
    }
    

    
    func loadData(){
        ApiLoadingProvider.request(PAPI.queryProductDetail(id: (model?.id)!), model: ProductModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.centerImageArr = (result?.pictureList)!
//                self.imageCollection.reloadData()
                self.loadIamges()
            }
        }
    }
    
    func loadIamges() {
        SVProgressHUD.show()
        for picPath in self.centerImageArr {
            let imageFullPath = picPath.creatProdcutFullUrlString(imageType: 0)
            dataArr.append(calNetWorkImageHeight(urlStr: imageFullPath))
        }
        SVProgressHUD.dismiss()
        self.imageCollection.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
       // okBt.addGradientLayerWithColors(bounds: okBt.bounds)
    }
    
    
    @IBAction func clearBt(_ sender: Any) {
        
        if(carArr.count <= 0){
            SVProgressHUD.showError(withStatus: "当前购物车无商品")
            return
        }
        
        self.productNum = 0
        ApiLoadingProvider.request(PAPI.deleteCartItem(), model: BaseModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.loadCarData()
            }
        }
    
    }
    @IBAction func addCar(_ sender: Any) {
        for model in carArr{
            if( model.productId == self.model?.id){
                self.productNum = model.productCount!
            }
        }
        self.productNum += 1

        ApiLoadingProvider.request(PAPI.modifyCartItem(productId: (model?.id)!, productCount: self.productNum, amount: (model?.salePrice)!), model: BaseModel.self) { (reslute, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.loadCarData()
            }
        }
    }
    
    @objc func showCar(){
        weak var weakSelf = self
        if self.isShow {
            
            isShow = false
            UIView.animate(withDuration: 0.3) {
                
                weakSelf!.carView.isHidden = true
                
            }
        }else{
            isShow = true
            UIView.animate(withDuration: 0.3) {
                
                weakSelf!.carView.isHidden = false
            }
        }
        
    }
    
    func loadCarData(){
        ApiLoadingProvider.request(PAPI.queryCartItemList(), model: CartItemListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                
                self.carArr = (result?.list)!
                var num:Int = 0
                for model in self.carArr{
                    num += model.productCount!
                }
                self.productNum = num
                self.carImage.pp.addBadge(number: num)
                self.carTab.reloadData()
            }
        }
    }
    
    @IBAction func saleBt(_ sender: Any) {

        ApiLoadingProvider.request(PAPI.queryCartItemList(), model: CartItemListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                
                if((result?.list?.count)! > 0){
                    self.performSegue(withIdentifier: "GoSubmitOrderViewController", sender: nil)
                }else{
                    SVProgressHUD.showError(withStatus: "请添加商品")
                }
            }
        }
    }
    
    /// 分享产品
    @objc func shareProduct(sender:UIBarButtonItem){
        var images = [UIImage]()
        for imgaeInfo in dataArr {
            let height = imgaeInfo.0
            if height > 0 {
                images.append(imgaeInfo.1)
            }
            else{
                images.removeAll()
                break
            }
        }
        guard images.count > 0 else {
            SVProgressHUD.showError(withStatus: "图片获取失败，无法分享")
            return
        }
        let shareImage = UIImage.combinImages(images: images)
        UMSocialUIManager.showShareMenuViewInWindow { (platformType, info) in
            if platformType.rawValue == 1001 {
                self.saveProductIamges(image: shareImage)
            }
            else {
                self.shareProductsImages(platForm: platformType, image: shareImage)
            }
        }
    }
    
    /// 下载图片 - 存储到相册
    func saveProductIamges(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(saveImage(image:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var showMessage = ""
        if error != nil{
            showMessage = "保存失败"
        }
        else{
            showMessage = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showMessage)
    }
    
    /// 分享图片
    func shareProductsImages(platForm:UMSocialPlatformType,image:UIImage){
        let shareObject = UMShareImageObject.shareObject(withTitle: self.titleName,
                                                         descr: "产品详情",
                                                         thumImage: nil)
        shareObject?.shareImage = image
        let shareMessage = UMSocialMessageObject.init(mediaObject: shareObject)
        UMSocialManager.default()?.share(to: platForm,
                                         messageObject: shareMessage,
                                         currentViewController: self,
                                         completion: { (result, shareError) in
                                            if let error = shareError {
                                                SVProgressHUD.showError(withStatus: error.localizedDescription)
                                            }
                                            else{
                                                SVProgressHUD.showSuccess(withStatus: "分享成功")
                                            }
        })
    }
}


extension SaleDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return centerImageArr.count
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCollection", for: indexPath) as! detailCollection
        let row:Int = indexPath.row
        cell.centerImage.image = dataArr[row].1
//        let imageFullPath = centerImageArr[row].creatProdcutFullUrlString(imageType: 0)
//        cell.centerImage.setImageUrl(imageFullPath)
        return cell
    }
}


extension SaleDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell" ) as! CarTableViewCell
        cell.selectionStyle = .none
        cell.carActionBlock = { (num) -> () in
            ApiLoadingProvider.request(PAPI.modifyCartItem(productId: self.carArr[indexPath.row].productId!, productCount: num, amount: self.carArr[indexPath.row].amount!), model: BaseModel.self, completion: { (reslute, info) in
                if let codeError = info.2 {
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    
                    self.loadCarData()
                }
            })
        }

        let subPath = carArr[indexPath.row].picturePath!
        if subPath.length > 0 {
            let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
            cell.leftImage.setImageUrl(imageFullPath)
        }
       
        cell.nameLabel.text = carArr[indexPath.row].productName
        cell.numLabel.text = "\(carArr[indexPath.row].productCount!)"
        cell.priceLabel.text = String(format: "￥%.2f",carArr[indexPath.row].amount!)
    
        return cell
    }
}


extension SaleDetailViewController:UICollectionViewDelegateFlowLayout{
    
    // section整体的inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = dataArr[indexPath.row].0
        return CGSize(width: self.view.frame.width, height: height)
        
    }
    
    // InteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // LineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
        
    }
    // footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
        
    }
    
    
}

extension SaleDetailViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        okBt.setBackgroundImage(UIImage.init(named: "orderCommitBG"), for: .normal)
        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    
}


extension SaleDetailViewController:DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "购物车暂无商品"
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: CGFloat(16.0)),
                          NSAttributedStringKey.foregroundColor: UIColor.black]
        return NSAttributedString(string: text, attributes: attributes as [NSAttributedStringKey : Any])

    }
}
