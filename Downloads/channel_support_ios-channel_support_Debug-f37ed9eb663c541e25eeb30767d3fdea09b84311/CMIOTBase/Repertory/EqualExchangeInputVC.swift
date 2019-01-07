//
//  EqualExchangeInputVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet

class EqualExchangeInputVC: UIViewController,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    let kMaxLength:Int = 64
    var inputCallback: ((String,Int) -> ())?
    var selIndex: Int = -1
    var contentStr: String = ""
    
    var inputType: Int = 0       // 0:默认 1:扫码安装
    var selProduct: OrderDetailProductModel?
    var productsArr = [ProductStockDetailsItemModel]()
    var dataArr = [ProductStockDetailsItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手动输入编码"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        if inputType == 1 {
            self.fetchProductStockDetails(isRefresh: true)
        }
    }

    // MARK: - function
    @objc func commitBtnClick(sender: UIButton) {
        let textStr = inputTF.text?.trimmed() ?? ""
        guard textStr.length > 0 else {
            SVProgressHUD.showInfo(withStatus: "请输入编码")
            return
        }
        let index = selIndex
        if let callback = self.inputCallback{
            callback(textStr,index)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: NetWork
    func fetchProductStockDetails(isRefresh: Bool){
        self.noNetwork = false
        let queryCondition = ["pageNum":1,"pageSize":kPageSize]
        ApiLoadingProvider.request(PAPI.queryProductStockDetails(productId:selProduct?.productId ?? 0,
                                                                 goodsStatus:-1,
                                                                 queryCondition:queryCondition), model: ProductStockDetailsModel.self) { (result, resultInfo) in
                    if let codeError = resultInfo.2 {
                        self.noNetwork = codeError.code == 2
                        self.updateUI(infoModel: nil,isRefresh: isRefresh)
                        SVProgressHUD.showError(withStatus: codeError.localizedDescription)
                    }
                    else{
                       self.updateUI(infoModel: result,isRefresh: isRefresh)
                    }
        }
    }
    
    //MARK:
    func filterProductByBarCode(barcode:String) {
        var filteredArr = [ProductStockDetailsItemModel]()
        for product in productsArr {
            if let productBarcode = product.barCode,productBarcode.contains(barcode, compareOption: .caseInsensitive){
                filteredArr.append(product)
            }
        }
        dataArr = barcode.length <= 0 ? productsArr : filteredArr
        matchingLab.isHidden = dataArr.count <= 0
        self.tabView.reloadData()
    }
    func updateUI(infoModel:ProductStockDetailsModel?,isRefresh: Bool){
        if let info = infoModel {
            let fetechedArr = info.list ?? []
            productsArr = fetechedArr
        }
       self.filterProductByBarCode(barcode: "")
    }
    
    //MARK: - UI
    lazy var markView: UIView = {
        let view = UIView()
        view.backgroundColor = RGB(25, g: 81, b: 255)
        return view
    }()
    
    lazy var markLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 16, color: RGB(33, g: 33, b: 33), placeText: "产品编码")
        return lab
    }()
    
    
    lazy var inputTF: UITextField = {
        let TFView = UIFactoryGenerateTextField(fontSize: 16, color: RGB(33, g: 33, b: 33), placeText: "请输入")
        TFView.backgroundColor = UIColor.white
        TFView.addBorder(width: 1, color: RGB(230, g: 230, b: 230))
        TFView.setCornerRadius(radius: 6)
        TFView.leftViewMode = .always
        TFView.text = contentStr
        TFView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let spaceView = UIView.init(x: 0, y: 0, w: 10, h: 46)
        spaceView.backgroundColor = UIColor.clear
        TFView.leftView = spaceView
        TFView.keyboardType = .default
        return TFView
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "确认",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(EqualExchangeInputVC.commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    lazy var matchingLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(88, g: 88, b: 88), placeText: "编码匹配(请仔细核对产品编码)")
        return lab
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(GroupStaffRepProductCell.classForCoder(), forCellReuseIdentifier: "inputcCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    func configUI() {
        self.view.addSubview(markView)
        markView.snp.makeConstraints { (make) in
            make.width.equalTo(3)
            make.height.equalTo(12)
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
        }
        
        self.view.addSubview(markLab)
        markLab.snp.makeConstraints { (make) in
            make.left.equalTo(markView.snp.right).offset(10)
            make.top.equalToSuperview().offset(14)
            make.height.equalTo(23)
            make.right.equalToSuperview()
        }
        
        self.view.addSubview(inputTF)
        inputTF.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(markView.snp.bottom).offset(8)
            make.height.equalTo(46)
        }
        
        self.view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(inputTF.snp.bottom).offset(26)
            make.height.equalTo(45)
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 30, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        self.view.addSubview(matchingLab)
        matchingLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.top.equalTo(commitBtn.snp.bottom).offset(25)
            make.height.equalTo(30)
        }
        matchingLab.isHidden = true
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(commitBtn.snp.bottom).offset(55)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension EqualExchangeInputVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return inputType == 1 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inputcCellIdentifier", for: indexPath) as! GroupStaffRepProductCell
        cell.selectionStyle = .none
        cell.configInputProductInfo(info: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 0))
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goods = dataArr[indexPath.row]
        let barcode = goods.barCode ?? ""
        inputTF.text = barcode
        self.filterProductByBarCode(barcode: barcode)
    }
}

// MARK: - UIScrollViewDelegate
extension EqualExchangeInputVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputTF.resignFirstResponder()
    }
}

extension EqualExchangeInputVC {
    func image(forEmptyDataSet scrollVie6w: UIScrollView!) -> UIImage! {
        if inputType == 1 {
            let imageName = self.noNetwork ? "nonetwork" : "nodata"
            return UIImage.init(named: imageName)
        }
        return nil
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var titleStr = self.noNetwork ? "网络出错了，请检查链接" : "暂时没有数据记录"
        titleStr = inputType == 1 ? titleStr : ""
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            kCTForegroundColorAttributeName as NSAttributedStringKey: RGB(0, g: 0, b: 0),
            kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 12)]
        return NSAttributedString(string: titleStr, attributes: multipleAttributes)
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> UIImage! {
        return nil
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 17
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        if inputType == 1 && self.noNetwork {
            let multipleAttributes: [NSAttributedStringKey : Any] = [
                kCTForegroundColorAttributeName as NSAttributedStringKey: RGB(0, g: 124, b: 255),
                kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 15)]
            return NSAttributedString(string: "点击刷新", attributes: multipleAttributes)
        }
        else{
            return nil
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if inputType == 1  && self.noNetwork {
            self.fetchProductStockDetails(isRefresh: true)
        }
    }
}


// MARK: - UITextFieldDelegate
extension EqualExchangeInputVC {
    @objc func textFieldDidChange(_ textFieldView: UITextField) {
        let lang = textInputMode?.primaryLanguage
        let content = textFieldView.text ?? ""
        if lang == "zh-Hans" {
            let range = textFieldView.markedTextRange
            if range == nil {
                if content.count >= kMaxLength {
                    let endLocation = content.index(content.startIndex, offsetBy: kMaxLength)
                    textFieldView.text = String(content[content.startIndex..<endLocation])
                }
            }
        }
        else {
            if content.count >= kMaxLength {
                let endLocation = content.index(content.startIndex, offsetBy: kMaxLength)
                textFieldView.text = String(content[content.startIndex..<endLocation])
            }
        }
        if let content = textFieldView.text, content.length > 0 {
            self.filterProductByBarCode(barcode: content)
        }
        else{
            self.filterProductByBarCode(barcode: "")
        }
    }
}

