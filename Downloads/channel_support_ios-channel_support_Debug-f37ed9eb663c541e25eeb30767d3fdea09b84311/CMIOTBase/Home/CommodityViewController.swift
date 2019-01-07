//
//  CommodityViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import  SVProgressHUD
import Kingfisher
class CommodityViewController: UIViewController {
    var model:ProductGroupModel?
    var dataArr:[ProductModel] = []
    var currentModel : ProductModel?
    @IBOutlet weak var mainCollection: UICollectionView!
    private let edgeMargin : CGFloat = 8
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollection.delegate = self
        mainCollection.dataSource = self
        loadData()
    }
    
    func loadData(){
        ApiLoadingProvider.request(PAPI.queryGroupProductList(groupId: (model?.id)!), model: ProductListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.dataArr = (result?.list)!
                self.mainCollection.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc:SaleDetailViewController = segue.destination as! SaleDetailViewController
        vc.titleName = currentModel?.productName
        vc.model = currentModel
    }
}

extension CommodityViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let row:Int = indexPath.row
        cell.productName.text = dataArr[row].productName
        let subPath = dataArr[row].picturePath!
        if subPath.length > 0 {
            let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
            cell.productPhoto.setImageUrl(imageFullPath)
        }
        cell.new_price.text = String(format: "￥%.2f", (dataArr[row].salePrice!))
        
        let attr = NSMutableAttributedString(string:String(format: "¥%.2f", (dataArr[row].linePrice!)) )
        attr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11),
                            NSAttributedStringKey.strikethroughStyle: 1],
                           range: NSRange(location: 0, length: String(format: "¥%.2f", (dataArr[row].linePrice!)).count))
 
        cell.old_price.attributedText = attr
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentModel = dataArr[indexPath.row]
        self.performSegue(withIdentifier: "GoSaleDetailViewController", sender:nil )
    }
}

extension CommodityViewController: UICollectionViewDelegateFlowLayout{
    
    // section整体的inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (self.view.frame.width - edgeMargin) / 2, height: 240)

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

extension CommodityViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        loadData()
        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    
}
