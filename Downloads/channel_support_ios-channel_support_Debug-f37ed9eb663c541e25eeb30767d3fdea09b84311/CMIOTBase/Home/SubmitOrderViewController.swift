//
//  SubmitOrderViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class SubmitOrderViewController: UIViewController {

    @IBOutlet weak var okBt: UIButton!
    @IBOutlet weak var subTab: UITableView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carTab: UITableView!
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var addImage: UIImageView!

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    var carArr:[CartItemListItemModel] = []
    var model:CustomerInfoListItemModel?
    var currentId:Int = 0 //生成订单id
    var isShow:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        isShow = false
        view.backgroundColor = kBackgroundColor
        self.title = "填写订单"
//        okBt.addGradientLayerWithColors(bounds: okBt.bounds)
        self.topView.contentMode = .scaleToFill
        topView.layer.contents = UIImage.init(named: "Group 4")?.cgImage
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addAddress))
        self.addImage.isUserInteractionEnabled = true
        self.addImage.addGestureRecognizer(gesture)
        
        self.topView.isUserInteractionEnabled = true
        self.topView.addGestureRecognizer(gesture)
        
        carImage.isUserInteractionEnabled = true
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(showCar))
        carImage.addGestureRecognizer(gesture1)

        self.loadCarData()
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
                self.totalLabel.attributedText = attr
                self.carTab.reloadData()
                self.subTab.reloadData()
            }
        }
    }
    
    
    @objc func showCar(){
        weak var weakSelf = self
        if self.isShow {
            
            isShow = false
            UIView.animate(withDuration: 0.3) {
                
                weakSelf!.showView.isHidden = true
                
            }
        }else{
            isShow = true
            UIView.animate(withDuration: 0.3) {
                
                weakSelf!.showView.isHidden = false
            }
        }
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoAddAddressViewController" {
            let vc:AddAddressViewController = segue.destination as! AddAddressViewController
            if let model = self.model{
                vc.currentCustomer = model
            }
            
            vc.black = { (_ model:CustomerInfoListItemModel) -> () in
                self.topView.removeSubviews()
                self.model = model
                self.showAddress(name: model.customerName!, phone: model.cellphone! , address: String(format: "%@ %@ %@ %@", model.provinceCode!,model.cityCode!,model.countyCode!,model.address!))
            }
        }else if(segue.identifier == "GoShowResultViewController"){
            let vc:ShowResultViewController = segue.destination as! ShowResultViewController
            vc.currentId = self.currentId
        }

    }
    
    func showAddress(name:String,phone:String,address:String) -> Void {
        let cuName = UILabel()
        let cuIphone = UILabel()
        let cuAdress = UILabel()
        
        cuName.textColor = kDefaultColor
        cuIphone.textColor = kDefaultColor
        cuAdress.textColor = kGayColor
        
        cuName.font = UIFont.boldSystemFont(ofSize: 18)
        cuIphone.font = UIFont.systemFont(ofSize: 18)
        cuAdress.font = UIFont.systemFont(ofSize: 12)
        
        cuName.text = name
        cuIphone.text = phone
        cuAdress.text = address
        
        cuName.text = name
        cuIphone.text = phone
        cuAdress.text = address
        
        topView.addSubview(cuAdress)
        topView.addSubview(cuName)
        topView.addSubview(cuIphone)
        
        cuName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        cuIphone.snp.makeConstraints { (make) in
            make.left.equalTo(cuName.snp.right).offset(5)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        cuAdress.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.top.equalTo(cuName.snp.bottom).offset(5)
            make.height.equalTo(37)
        }
        
        
        
    }
    
    @objc func addAddress(){
        if(self.isShow){
            showCar()
        }
        self.performSegue(withIdentifier: "GoAddAddressViewController", sender: nil)
    }
    
    
    @IBAction func submitBt(_ sender: Any) {
        if (self.model?.customerName == "" || self.model == nil) {
            SVProgressHUD.showError(withStatus: "请填写购买人信息")
            return
        }else{
            
            
            ApiLoadingProvider.request(PAPI.queryCartItemList(), model: CartItemListModel.self) { (result, info) in
                if let codeError = info.2 {
                    self.noNetwork = codeError.code == 2
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    
                    if((result?.list?.count)! > 0){
                        self.subOrderClick()
                    }else{
                        SVProgressHUD.showError(withStatus: "请添加商品")
                    }
                }
            }
        }
    }
    
    func subOrderClick(){        
        ApiLoadingProvider.request(PAPI.createOrderInfo(customer: (self.model?.id)!, orderDetails: carArr), model: CreateOrderInfoModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.currentId = (result?.id)!
                self.performSegue(withIdentifier: "GoShowResultViewController", sender: nil)
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if(self.isShow){
//            showCar()
//        }
    }
}

extension SubmitOrderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return carArr.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == carTab {
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
            cell.priceLabel.text = String(format: "￥%.2f", carArr[indexPath.row].amount!)
            cell.numLabel.text = "\(carArr[indexPath.row].productCount!)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitOrderTableViewCell" ) as! submitOrderTableViewCell
            cell.selectionStyle = .none
            let subPath = carArr[indexPath.row].picturePath!
            if subPath.length > 0 {
                let imageFullPath = subPath.creatProdcutFullUrlString(imageType: 1)
                cell.leftImage.setImageUrl(imageFullPath)
            }
            
            cell.nameLabel.text = carArr[indexPath.row].productName
            cell.numLabel.text = String(format: "x%@", "\(carArr[indexPath.row].productCount!)")
            
            cell.priceLabel.text = String(format: "￥%.2f", carArr[indexPath.row].amount!)
            return cell
           
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == carTab {
            return 60
        }else{
            return 110
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == carTab {
            return nil
        }else{
            let view = UIView()
            view.backgroundColor = UIColor.white
            
            let leftLabel = UILabel()
            
            leftLabel.font = UIFont.systemFont(ofSize: 14)
            leftLabel.textColor = UIColor.colorWithHexString(hex: "#585858")
            leftLabel.text = "待付款产品"
            view.addSubview(leftLabel)
            
            let viewWidth = self.view.frame.width
            view.snp.makeConstraints { (make) in
                make.width.equalTo(viewWidth)
                make.height.equalTo(20)
            }
            
            leftLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(9)
                
                make.centerY.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(20)
            }
            return view
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == carTab {
            return 0.001
        }else{
            return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if(self.isShow){
            showCar()
        }

    }
}

extension SubmitOrderViewController:NavBarTitleChangeable{
    
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
    
    override func backToUpVC() {
        self.popToRootVC()
    }
}
