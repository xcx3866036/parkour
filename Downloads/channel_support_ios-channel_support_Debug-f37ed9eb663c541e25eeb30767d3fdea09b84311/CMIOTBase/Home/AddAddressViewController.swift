//
//  AddAddressViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVProgressHUD
class AddAddressViewController: UIViewController {

    @IBOutlet weak var okBt: UIButton!
    @IBOutlet weak var addressTableview: UITableView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var areaTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var iphoneTF: UITextField!
    var addressArr:[CustomerInfoListItemModel] = []
    var currentCustomer:CustomerInfoListItemModel?
    var province:String? = ""//省
    var city:String? = ""//市
    var county:String? = ""//区

    var loading:MBProgressHUD?
    typealias saveSuccess = (_ customer:CustomerInfoListItemModel)->()
    var black:saveSuccess?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买人信息"
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeLoading), name: NSNotification.Name.init(rawValue: "closeLoading"), object: nil)
        okBt.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, width: okBt.frame.width+30, height: okBt.frame.height))
        self.view.backgroundColor = kBackgroundColor
        addressTableview.delegate = self
        addressTableview.dataSource = self
        //addressTableview.isScrollEnabled = false
        areaTF.delegate = self
       // areaTF.isUserInteractionEnabled = true

        loading = MBProgressHUD.init()
        self.view.addSubview(loading!)
        loading?.dimBackground = true
        loading?.labelText = "加载位置信息"
        
        
        if(currentCustomer?.customerName != "" && currentCustomer != nil){
            self.province = currentCustomer!.provinceCode
            self.city = currentCustomer!.cityCode
            self.county = currentCustomer!.countyCode
            self.nameTF.text = currentCustomer!.customerName
            self.iphoneTF.text = currentCustomer!.cellphone
            self.areaTF.text = String(format: "%@ %@ %@", currentCustomer!.provinceCode!,currentCustomer!.cityCode!,currentCustomer!.countyCode!)
            self.addressTF.text = currentCustomer!.address
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func closeLoading(){
        self.loading?.hide(animated: true)
        SVProgressHUD.showError(withStatus: "获取定位信息失败")
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        let result = self.verifyPhoneNumber(phoneStr: self.iphoneTF.text?.trimmed())
        guard result else { return } 

        if((self.nameTF.text?.count)! <= 0){
            SVProgressHUD.showError(withStatus: "未输入购买人姓名")
            return
        }
        
        if((self.areaTF.text?.count)! <= 0){
            SVProgressHUD.showError(withStatus: "未选择所在区域")
            return
        }
        
        if((self.addressTF.text?.count)! <= 0){
            SVProgressHUD.showError(withStatus: "未输入详细地址")
            return
        }
        if let customer = self.currentCustomer, customer.customerName?.length ?? 0 > 0 {
            self.currentCustomer!.address = self.addressTF.text
            self.currentCustomer!.provinceCode = self.province
            self.currentCustomer!.countyCode = self.county
            self.currentCustomer!.cityCode = self.city
            self.currentCustomer!.customerName = self.nameTF.text
            self.currentCustomer!.cellphone = self.iphoneTF.text
            ApiLoadingProvider.request(PAPI.modifyCustomerInfo(id: (currentCustomer?.id)!, customerName: (currentCustomer?.customerName)!, cellphone: (currentCustomer?.cellphone)!, provinceCode: (currentCustomer?.provinceCode)!, cityCode: (currentCustomer?.cityCode)!, countyCode: (currentCustomer?.countyCode)!, address: (currentCustomer?.address)!), model: CustomerInfo.self) { (result, info) in
                if let codeError = info.2 {
                    self.noNetwork = codeError.code == 2
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    if let block  =  self.black {
                        block(self.currentCustomer!)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        else{
            ApiLoadingProvider.request(PAPI.createCustomerInfo(customerName: nameTF.text!,
                                                               cellphone: iphoneTF.text!,
                                                               provinceCode: self.province!,
                                                               cityCode: self.city!,
                                                               countyCode: self.county! ,
                                                               address: self.addressTF.text!),
                                       model: CustomerInfo.self) { (result, info) in
                                        if let codeError = info.2 {
                                            self.noNetwork = codeError.code == 2
                                            SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                                        }
                                        else{
                                            let model:CustomerInfoListItemModel = CustomerInfoListItemModel()
                                            model.address = self.addressTF.text
                                            model.id = result?.id
                                            model.provinceCode = self.province
                                            model.countyCode = self.county
                                            model.cityCode = self.city
                                            model.customerName = self.nameTF.text
                                            model.cellphone = self.iphoneTF.text
                                            if let block  =  self.black {
                                                block(model)
                                            }
                                            self.navigationController?.popViewController(animated: true)
                                        }
            }
        }
//        if(self.currentCustomer?.customerName == "" && (self.currentCustomer == nil)){
//            ApiLoadingProvider.request(PAPI.createCustomerInfo(customerName: nameTF.text!,
//                                                               cellphone: iphoneTF.text!,
//                                                               provinceCode: self.province!,
//                                                               cityCode: self.city!,
//                                                               countyCode: self.county! ,
//                                                               address: self.addressTF.text!),
//                                       model: CustomerInfo.self) { (result, info) in
//                if let codeError = info.2 {
//                    self.noNetwork = codeError.code == 2
//                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
//                }
//                else{
//                    let model:CustomerInfoListItemModel = CustomerInfoListItemModel()
//                    model.address = self.addressTF.text
//                    model.id = result?.id
//                    model.provinceCode = self.province
//                    model.countyCode = self.county
//                    model.cityCode = self.city
//                    model.customerName = self.nameTF.text
//                    model.cellphone = self.iphoneTF.text
//                    if let block  =  self.black {
//                        block(model)
//                    }
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//        }else{
//            self.currentCustomer!.address = self.addressTF.text
//            self.currentCustomer!.provinceCode = self.province
//            self.currentCustomer!.countyCode = self.county
//            self.currentCustomer!.cityCode = self.city
//            self.currentCustomer!.customerName = self.nameTF.text
//            self.currentCustomer!.cellphone = self.iphoneTF.text
//            ApiLoadingProvider.request(PAPI.modifyCustomerInfo(id: (currentCustomer?.id)!, customerName: (currentCustomer?.customerName)!, cellphone: (currentCustomer?.cellphone)!, provinceCode: (currentCustomer?.provinceCode)!, cityCode: (currentCustomer?.cityCode)!, countyCode: (currentCustomer?.countyCode)!, address: (currentCustomer?.address)!), model: CustomerInfo.self) { (result, info) in
//                if let codeError = info.2 {
//                    self.noNetwork = codeError.code == 2
//                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
//                }
//                else{
//                    if let block  =  self.black {
//                        block(self.currentCustomer!)
//                    }
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//
//        }
    }
    
    /// 验证手机号长度和格式
    func verifyPhoneNumber(phoneStr: String?) -> Bool {
        guard let nam = phoneStr, nam.length > 0 else {
            SVProgressHUD.showError(withStatus: "未输入手机号")
            return false
        }
        guard nam =~ phonePattern else {
            SVProgressHUD.showError(withStatus: "请输入正确的11位手机号")
            return false
        }
        return true
    }
    
    @IBAction func areaAction(_ sender: Any) {
        self.showAddressPick()
    }
    
    @IBAction func addressAction(_ sender: Any) {
        loading?.show(animated: true)
        
        LocationUtil.share.getCurrentLocation(isOnce: true) { (loc, errorMsg) -> () in
            if errorMsg == nil {
                self.loading?.hide(animated: true)
                self.addressTF.text = String(format: "%@", (loc?.name)!)
                let locality = loc?.locality ?? ""
                let subLocality = loc?.subLocality ?? ""
                let administrativeArea = loc?.administrativeArea ?? ""
                let locationStr = administrativeArea + " " + locality + " " + subLocality
                self.province = administrativeArea
                self.city = locality
                self.county = subLocality
                self.areaTF.text = locationStr
            }
        }
    }
    
    func showAddressPick() {
        let piker:DXLAddressPickView = DXLAddressPickView.init()
        let province = self.province ?? ""
        let city = self.city ?? ""
        let county = self.county ?? ""
        piker.show(withProvince:province,city:city,county:county)
        piker.determineBtnBlock = { ( provinceID,cityID,areaId,provinceName,cityName,areaName ) -> ()  in
            self.province = provinceName!
            self.city = cityName!
            self.county = areaName!
            self.areaTF.text = String(format: "%@ %@ %@", provinceName!,cityName!,areaName!)
        }
    }
}
extension AddAddressViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.addressArr.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell" ) as! AddressTableViewCell

        cell.nameLabel.text = self.addressArr[indexPath.row].customerName
        cell.phone.text = self.addressArr[indexPath.row].cellphone
        cell.adressLabel.text = String(format: "%@ %@ %@ %@", self.addressArr[indexPath.row].provinceCode!,self.addressArr[indexPath.row].cityCode!,self.addressArr[indexPath.row].countyCode!,self.addressArr[indexPath.row].address!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        
        let leftLabel = UILabel()
        
        leftLabel.font = UIFont.systemFont(ofSize: 14)
        leftLabel.textColor = UIColor.colorWithHexString(hex: "#585858")
        leftLabel.text = "联系人匹配"
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.province = addressArr[indexPath.row].provinceCode
        self.city = addressArr[indexPath.row].cityCode
        self.county = addressArr[indexPath.row].countyCode
        self.currentCustomer = addressArr[indexPath.row]
        self.nameTF.text = self.addressArr[indexPath.row].customerName
        self.iphoneTF.text = self.addressArr[indexPath.row].cellphone
        self.areaTF.text = String(format: "%@ %@ %@", self.addressArr[indexPath.row].provinceCode!,self.addressArr[indexPath.row].cityCode!,self.addressArr[indexPath.row].countyCode!)
        self.addressTF.text = self.addressArr[indexPath.row].address
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddAddressViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text != "" && (textField.text?.count == 11)){
            self.currentCustomer?.customerName = ""
            ApiLoadingProvider.request(PAPI.queryCustomerInfoList(likeCellphone: textField.text!), model: CustomerInfoListModel.self) { (result, info) in
                if let codeError = info.2 {
                    self.noNetwork = codeError.code == 2
                    SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                }
                else{
                    
                    self.addressArr = (result?.list)!
                    if(self.addressArr.count == 0){
                        
                        self.addressTableview.isHidden = true
                    }else{
                        self.addressTableview.isHidden = false
                        self.addressTableview.reloadData()
                    }
                }
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == areaTF){
            self.showAddressPick()
            return false
        }
        return true
    }
}

extension AddAddressViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        appDelegate!.changeNavigationBarDefaultInVC(rootVC: self)
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    
}
