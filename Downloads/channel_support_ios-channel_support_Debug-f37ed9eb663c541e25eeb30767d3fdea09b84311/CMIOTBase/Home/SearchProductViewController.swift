//
//  SearchProductViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/17.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class SearchProductViewController: UIViewController {

    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var carTable: UITableView!
    @IBOutlet weak var okBt: UIButton!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var serchTab: UITableView!
    var carArr:[CartItemListItemModel] = []
    var dataArr:[ProductModel] = []
    
    lazy var searchBar: UISearchBar = {
        let tempSearchBar = UISearchBar(frame:CGRect(x: 100, y: 64, width: self.view.bounds.size.width * 0.8, height: 40))
       // tempSearchBar.backgroundColor = UIColor.lightGray
        let searField:UITextField = tempSearchBar.value(forKey: "searchField") as! UITextField



        
        let image = imageFromColor(color: UIColor.colorWithHexString(hex: "#F5F5F5"), viewSize: tempSearchBar.size)
        tempSearchBar.setSearchFieldBackgroundImage(image, for: .normal)
        tempSearchBar.placeholder = "请输入搜索关键字"
        tempSearchBar.showsCancelButton = false
        tempSearchBar.delegate = self
        searField.layer.masksToBounds = true
        searField.layer.cornerRadius  = 14
        return tempSearchBar
        }()
    
    var isShow:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        isShow = false
//        okBt.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH/2, height: okBt.frame.height))
        // okBt.addGradientLayerWithColors(bounds: okBt.bounds)
        self.view.backgroundColor = kBackgroundColor
        
        carImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showCar))
        carImage.addGestureRecognizer(gesture)
        
        let leftNavBarButton = UIBarButtonItem(customView:self.searchBar)
        self.navigationItem.leftBarButtonItems?.append(leftNavBarButton)
        
        self.loadCarData()

    }

    
    
    @IBAction func clearBt(_ sender: Any) {
        if(carArr.count <= 0){
            SVProgressHUD.showError(withStatus: "当前购物车无商品")
            return
        }
        
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
    
    func loadCarData(){
        ApiLoadingProvider.request(PAPI.queryCartItemList(), model: CartItemListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                
                self.carArr = (result?.list)!
                var num:Int = 0
                var total:Double = 0.00
                for model in self.carArr{
                    num += model.productCount!
                    total += (model.amount! * Double(model.productCount!))
                }
                self.carImage.pp.addBadge(number: num)
                
                let str = String(format: "合计:￥%.2f", total)
                let attr = NSMutableAttributedString(string: str)
                
                attr.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], range: NSMakeRange(0, 3))
                attr.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.red], range: NSMakeRange(3, (str.length - 3)))
                self.priceLabel.attributedText = attr
                self.carTable.reloadData()
                self.serchTab.reloadData()
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
    
    func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        
        context.fill(rect)
        
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsGetCurrentContext()
        
        return image!
        
    }

}

extension SearchProductViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == carTable ? carArr.count : dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return tableView == carTable ? 60 : 79
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == serchTab {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell" ) as! SearchTableViewCell
            cell.searchActionBlock = { (num) -> () in
                ApiLoadingProvider.request(PAPI.modifyCartItem(productId: self.dataArr[indexPath.row].id!, productCount: num, amount: self.dataArr[indexPath.row].salePrice!), model: BaseModel.self, completion: { (reslute, info) in
                    if let codeError = info.2 {
                        SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                    }
                    else{
                        self.loadCarData()
                    }
                })
            }
            let subPath = dataArr[indexPath.row].picturePath!
            if subPath.length > 0 {
                let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
                cell.leftImage.setImageUrl(imageFullPath)
            }
            
            cell.nameLabel.text = dataArr[indexPath.row].productName
            cell.priceLabel.text = String(format: "￥%.2f",dataArr[indexPath.row].salePrice!)
            cell.numLabel.text = "0"
            for model in self.carArr{
                if ( model.productId == dataArr[indexPath.row].id){
                    cell.numLabel.text = String(format: "%d", model.productCount!)
                }
            }
            
            return cell
        }else{
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
            cell.num = carArr[indexPath.row].productCount!
            cell.nameLabel.text = carArr[indexPath.row].productName
            cell.priceLabel.text = String(format: "￥%.2f",carArr[indexPath.row].amount!)
            cell.numLabel.text = "\(carArr[indexPath.row].productCount!)"
            
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}


extension SearchProductViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.isShow){
            showCar()
        }
    }
}


extension SearchProductViewController:UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if(self.isShow){
            showCar()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("222")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ApiLoadingProvider.request(PAPI.queryProductList(likeProductName: searchBar.text!), model: ProductListModel.self) { (reslut, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.dataArr = (reslut?.list)!
                if(self.dataArr.count == 0){
                    self.serchTab.isHidden = true
                }else{
                    self.serchTab.isHidden = false
                    self.serchTab.reloadData()
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }


}
