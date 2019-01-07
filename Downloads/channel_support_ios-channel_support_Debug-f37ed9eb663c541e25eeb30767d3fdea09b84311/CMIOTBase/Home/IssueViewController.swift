//
//  IssueViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVProgressHUD
class IssueViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var okBt: UIButton!
    @IBOutlet weak var clearBt: UIButton!
    @IBOutlet weak var carView: UIView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var leftTableView: UITableView!

    @IBOutlet weak var showTableview: UITableView!
    @IBOutlet weak var carImage: UIImageView!
    var isShow:Bool!
    var dataArr:[ProductGroupModel] = [] //左table 数据
    var carArr:[CartItemListItemModel] = []
    var rightDataArr:[ProductModel] = [] //l右 tableview 数据
    var productNum:Int = 0 //当前产品数量
    
    var selectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedRow = 0
        isShow = false
        self.title = "销售下单"
        okBt.setBackgroundImage(UIImage.init(named: "orderCommitBG"), for: .normal)
        self.view.backgroundColor = kBackgroundColor

        leftTableView.separatorStyle = .none
        rightTableView.separatorStyle = .none
        rightTableView.addTapGesture { (ges) in
            if(self.isShow){
                self.showCar()
            }
        }
        leftTableView.backgroundColor = kBackgroundColor
        
        carImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showCar))
        carImage.addGestureRecognizer(gesture)
        
        let item=UIBarButtonItem(image: UIImage(named: "find"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(findAction))
        self.navigationItem.rightBarButtonItem=item
        
    }
    
    
    ///左边试图
    func loadData(){
        ApiLoadingProvider.request(PAPI.queryProductGroupList(), model: ProductGroupListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.dataArr = result?.list ?? []
                self.leftTableView.reloadData()
                if(self.dataArr.count != 0){
                    self.loadRightData(groupId: self.dataArr[0].id!)
                }
            }
        }
    }
    ///购物车
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
                
                self.view.setNeedsLayout()
                self.showTableview.reloadData()
            }
        }
    }
    ///右边试图
    func loadRightData(groupId:Int){
        ApiLoadingProvider.request(PAPI.queryGroupProductList(groupId: groupId), model: ProductListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.rightDataArr = (result?.list)!
                self.rightTableView.reloadData()
            }
        }
    }
    
    @objc func findAction(){
        self.performSegue(withIdentifier: "GoSearchProductViewController", sender: nil)
    }
    

    @IBAction func clickClearBt(_ sender: Any) {
        self.productNum = 0
        
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
                self.loadData()
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
    
}

extension IssueViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return dataArr.count
        }else if(tableView == rightTableView){

                return rightDataArr.count

        }else{

            return carArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == showTableview {
            return 60
        }
        return tableView == leftTableView ? 55 : 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.textAlignment = .center
                
            }
            cell?.textLabel?.text = dataArr[indexPath.row].groupName
            
            cell?.textLabel?.textColor = indexPath.row == selectedRow ? kScrollLineColor : UIColor.black
            cell?.backgroundColor = indexPath.row == selectedRow ? UIColor.white : tableView.backgroundColor
            return cell!
        }else if tableView == rightTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "IssueTableViewCell", for: indexPath) as! IssueTableViewCell
                cell.selectionStyle = .none
            cell.issueActionBlock = { (type) -> () in

                self.loadCarData()
                
            }
            
            
            
            cell.model = rightDataArr[indexPath.row]

            let subPath = rightDataArr[indexPath.row].picturePath!
            if subPath.length > 0 {
                let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
                cell.leftImage.setImageUrl(imageFullPath)
            }
            cell.nameLabel.text = rightDataArr[indexPath.row].productName
            cell.currentMoney.text = String(format: "￥%.2f", rightDataArr[indexPath.row].salePrice!)
            cell.numLabel.text = "0"
            for model in self.carArr{
                if ( model.productId == rightDataArr[indexPath.row].id){
                    cell.numLabel.text = String(format: "%d", model.productCount!)
                }
            }
            
            

            let attr = NSMutableAttributedString(string: String(format: "¥%.2f", rightDataArr[indexPath.row].linePrice!))
            attr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13),
                                NSAttributedStringKey.strikethroughStyle: 1],
                               range: NSRange(location: 0, length: String(format: "¥%.2f", rightDataArr[indexPath.row].linePrice!).count))
            cell.oldMoney.attributedText = attr
            
            return cell


        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell" ) as! CarTableViewCell
            cell.selectionStyle = .none
            cell.carActionBlock = { (num) -> () in
                ApiLoadingProvider.request(PAPI.modifyCartItem(productId: self.carArr[indexPath.row].productId!, productCount: num, amount: self.carArr[indexPath.row].amount!), model: BaseModel.self, completion: { (reslute, info) in
                    if let codeError = info.2 {
                        SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                    }
                    else{
                        self.loadData()
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
            cell.num = carArr[indexPath.row].productCount!
            cell.priceLabel.text = String(format: "￥%.2f", (carArr[indexPath.row].amount!))
            cell.numLabel.text = "\(carArr[indexPath.row].productCount!)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
       
        if tableView == leftTableView {
            selectedRow = indexPath.row
            
            leftTableView.reloadData()
            if(self.isShow){
                showCar()
            }
            print("\(self.dataArr[indexPath.row].id!)")
            
            self.loadRightData(groupId: self.dataArr[indexPath.row].id!)
        }else if(tableView == rightTableView){

            if(self.isShow){
                showCar()
            }
        }
    }
}

extension IssueViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        loadData()
        self.loadCarData()
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    

    
    
    
}
