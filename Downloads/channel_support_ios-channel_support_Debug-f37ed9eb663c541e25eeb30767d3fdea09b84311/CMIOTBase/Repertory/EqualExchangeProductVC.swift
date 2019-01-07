//
//  EqualExchangeProductVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD

enum InputType {
    case exchangeInputType               // 组内换货
    case preIMWarehousingInputType       // 产品预出
    case salesReturnInputType            // 产品退还
}

class EqualExchangeProductVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NavBarTitleChangeable, BWSwipeRevealCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{

    var inputType: InputType = .exchangeInputType
    var arrCount = 0
    var selPreGoods: ProductModel? = nil
    var preAddedGoods = [GoodsModel]()
    var backAddedGoods = [OutGoodsModel]()
    var exchangeAddedGoods = [OutGoodsModel]()
    
    var preAddedCallback: ((Int,[GoodsModel]) -> ())?
    var preIndex: Int = 0
    var upPreAddedGoogs = [GoodsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = inputType == .exchangeInputType ? "组内换货" : inputType == .preIMWarehousingInputType ? "产品预出" : "产品退还"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        
        if inputType == .preIMWarehousingInputType {
            preAddedGoods += upPreAddedGoogs
        }
        self.configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    

    //MARK: - function
    @objc func commitBtnClick(sender: UIButton) {
        if inputType == .exchangeInputType {
            self.commitExchangeGoodsOwner()
        }
        else if inputType == .preIMWarehousingInputType {
            if preAddedGoods.count > 0{
                if let callBack = self.preAddedCallback {
                    callBack(preIndex,preAddedGoods)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
        else if inputType == .salesReturnInputType {
            self.commitBackGoods()
        }
    }
    
    @objc func scanBtnClick(sender: UIButton) {
        let scanVC = EqualExchangeScanVC()
        scanVC.selIndex = -1
        scanVC.inputCallback = { [unowned self] (contentStr,index) in
            print("input: \(contentStr)")
            if self.inputType == .preIMWarehousingInputType {
                self.queryPreProductInfoByBarCode(codeStr: contentStr, index: index)
            }
            else if self.inputType == .salesReturnInputType{
              self.queryProductInfoByBarCode(codeStr: contentStr,index: index)
            }
            else if self.inputType == .exchangeInputType{
                self.queryProductInfoByBarCode(codeStr: contentStr,index: index)
            }
        }
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    @objc func inputBtnClick(sender: UIButton) {
        let inputVC = EqualExchangeInputVC()
        inputVC.selIndex = -1
        inputVC.inputCallback = { [unowned self] (contentStr,index) in
            print("input: \(contentStr)")
            if self.inputType == .preIMWarehousingInputType {
                self.queryPreProductInfoByBarCode(codeStr: contentStr, index: -1)
            }
            else if self.inputType == .salesReturnInputType{
                self.queryProductInfoByBarCode(codeStr: contentStr,index: -1)
            }
            else if self.inputType == .exchangeInputType{
                self.queryProductInfoByBarCode(codeStr: contentStr,index: index)
            }
        }
        self.navigationController?.pushViewController(inputVC, animated: true)
    }
    
    func backGoodsContainGoods(goods:OutGoodsModel) -> Bool{
        let goodsBarcode = goods.barCode ?? ""
        for item in backAddedGoods {
            let itemBarCode = item.barCode ?? ""
            if itemBarCode == goodsBarcode {
                return true
            }
        }
        return false
    }
    
    func exchangeGoodsContainGoods(goods:OutGoodsModel) -> Bool{
        let goodsBarcode = goods.barCode ?? ""
        for item in exchangeAddedGoods {
            let itemBarCode = item.barCode ?? ""
            if itemBarCode == goodsBarcode {
                return true
            }
        }
        return false
    }
    
    func preStockContainGoods(goods:GoodsModel) -> Bool {
        let goodsBarcode = goods.barCode ?? ""
        for item in preAddedGoods {
            let itemBarCode = item.barCode ?? ""
            if itemBarCode == goodsBarcode {
                return true
            }
        }
        return false
    }
    
    func updateUI(result:BaseModel?){
        var inReserve = [OutGoodsModel]()
        for goods in exchangeAddedGoods {
            if goods.isSatisfyBack(){
                continue
            }
            inReserve.append(goods)
        }
        exchangeAddedGoods = inReserve
        tabView.reloadData()
        NotificationCenter.default.post(name: Notification.Name(kUpdateRepNotification), object: nil)
        let completeVC = CompleteScanRenewVC()
        completeVC.operateType = .equalExchangeGoods
        self.navigationController?.pushViewController(completeVC, animated: true)
    }
    
    func updateBackAddGoodsUI(addedInfo:OutGoodsModel?,index:Int){
        if let goods = addedInfo {
            if inputType == .salesReturnInputType {
                if self.backGoodsContainGoods(goods: goods){
                   SVProgressHUD.showInfo(withStatus: "请勿添加重复产品!")
                }
                else{
                    if index < 0 {
                         backAddedGoods.append(goods)
                    }
                    else{
                        if backAddedGoods.count >= index + 1 {
                            backAddedGoods[index] = goods
                        }
                    }
                }
            }
            else if inputType == .exchangeInputType {
                if self.exchangeGoodsContainGoods(goods: goods){
                     SVProgressHUD.showInfo(withStatus: "请勿添加重复产品!")
                }
                else{
                    if index < 0 {
                        exchangeAddedGoods.append(goods)
                    }
                    else{
                        if exchangeAddedGoods.count >= index + 1 {
                            exchangeAddedGoods[index] = goods
                        }
                    }
                }
            }
        }
        tabView.reloadData()
    }
    
    func updatePreAddGoodsUI(addedInfo:GoodsModel?,index:Int){
        if let goods = addedInfo {
            if self.preStockContainGoods(goods: goods){
                 SVProgressHUD.showInfo(withStatus: "请勿添加重复产品!")
            }
            else{
                if index < 0 {
                    preAddedGoods.append(goods)
                }
                else{
                    if preAddedGoods.count >= index + 1 {
                        preAddedGoods[index] = goods
                    }
                }
            }
        }
        tabView.reloadData()
    }
    
    func updateCommitBackGoodsUI(info: BaseModel?){
        var arr = [OutGoodsModel]()
        for outGoods in backAddedGoods {
            if !outGoods.isSatisfyBack() {
               arr.append(outGoods)
            }
        }
        backAddedGoods = arr
        tabView.reloadData()
        NotificationCenter.default.post(name: Notification.Name(kUpdateManagerRepNotification), object: nil)
        let completeVC = CompleteScanRenewVC()
        completeVC.operateType = .applyForReturnedGoods
        self.navigationController?.pushViewController(completeVC, animated: true)
    }
    
    //MARK: - Network
    func commitExchangeGoodsOwner(){
        self.noNetwork = false
        if exchangeAddedGoods.count <= 0 {
            SVProgressHUD.showInfo(withStatus: "请先添加产品")
            return
        }
        var goodsIds = [Int]()
        for goods in exchangeAddedGoods {
            if goods.isSatisfyBack(){
                goodsIds.append(goods.id ?? 0)
            }
        }
        guard goodsIds.count > 0 else {
            SVProgressHUD.showInfo(withStatus: "请先添加正确的商品")
            return
        }
        ApiLoadingProvider.request(PAPI.exchangeGoods(goodsIds:goodsIds), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateUI(result: result)
            }
        }
    }
    
    // 确认退货
    func commitBackGoods(){
        guard backAddedGoods.count > 0 else {
            SVProgressHUD.showInfo(withStatus: "请先添加产品")
            return
        }
        var parms = [Int]()
        for outGoods in backAddedGoods {
            if outGoods.isSatisfyBack() && outGoods.id != nil{
                parms.append(outGoods.id!)
            }
        }
        guard parms.count > 0 else {
            SVProgressHUD.showInfo(withStatus: "请先添加正确的商品")
            return
        }
        if parms.count <= 0 {
            return
        }
        
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.createReturnRecords(returnRecords: parms), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateCommitBackGoodsUI(info:result)
            }
        }
    }
    
    // 通过二维码获取已出库商品
    func queryProductInfoByBarCode(codeStr:String,index:Int){
        
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.queryOutGoods(barCode:codeStr,productId:-1), model: OutGoodsModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateBackAddGoodsUI(addedInfo: nil,index: index)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateBackAddGoodsUI(addedInfo: result,index: index)
            }
        }
    }
    
    // 通过二维码获取未出库商品
    func queryPreProductInfoByBarCode(codeStr:String,index:Int){
        if codeStr.length > 0 {
            let goods = GoodsModel()
            goods.barCode = codeStr
            self.updatePreAddGoodsUI(addedInfo: goods,index: index)
        }
        
//        self.noNetwork = false
//        ApiLoadingProvider.request(PAPI.queryGoods(barCode: codeStr, productId: selPreGoods?.id ?? 0), model: GoodsModel.self) { (result, resultInfo) in
//            if let codeError = resultInfo.2 {
//                self.noNetwork = codeError.code == 2
//                self.updatePreAddGoodsUI(addedInfo: nil,index: index)
//                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
//            }
//            else{
//                self.updatePreAddGoodsUI(addedInfo: result,index: index)
//            }
//        }
    }
    
    //MARK: - UI
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(EqualExchangeTabCell.classForCoder(), forCellReuseIdentifier: "equalExchangeProductIdentifier")
        tabView.register(PreEqualExchangeTabCell.classForCoder(), forCellReuseIdentifier: "preEqualExchangeProductIdentifier")
        
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    lazy var commitBtn: UIButton = {
        let str = inputType == .salesReturnInputType ? "确认退还" : inputType == .preIMWarehousingInputType ? "添加完成" : "确定换入"
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: str,imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(EqualExchangeProductVC.commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18 * kDrawdownRatioW, color: RGB(255, g: 255, b: 255), placeText: "", imageName: "rep_exchange_scan1")
        btn.addTarget(self, action: #selector(EqualExchangeProductVC.scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var inputBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18 * kDrawdownRatioW, color: RGB(255, g: 255, b: 255), placeText: "", imageName: "rep_exchange_input1")
        btn.addTarget(self, action: #selector(EqualExchangeProductVC.inputBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    func configUI() {
        
        self.view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 30, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        let width = (SCREEN_WIDTH - 15 - 15 - 13) / 2
        self.view.addSubview(inputBtn)
        inputBtn.snp.makeConstraints { (make) in
            make.height.equalTo(41 * kDrawdownRatioW)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(width)
            make.bottom.equalTo(commitBtn.snp.top).offset(-37 * kDrawdownRatioH)
        }
        
        self.view.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.height.equalTo(41 * kDrawdownRatioW)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(width)
            make.bottom.equalTo(commitBtn.snp.top).offset(-37 * kDrawdownRatioH)
        }
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(inputBtn.snp.top).offset(-15)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension EqualExchangeProductVC {
    func numberOfSections(in tableView: UITableView) -> Int {
//        return inputType == .exchangeInputType ? arrCount : 5
        if inputType == .salesReturnInputType{
            return backAddedGoods.count
        }
        else if inputType == .preIMWarehousingInputType {
            return preAddedGoods.count
        }
        else if inputType == .exchangeInputType {
            return exchangeAddedGoods.count
        }
        return arrCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if inputType == .preIMWarehousingInputType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "preEqualExchangeProductIdentifier", for: indexPath) as! PreEqualExchangeTabCell
            cell.selectionStyle = .none
//            cell.delegate = self
//            cell.revealDirection = .right
//            cell.bgViewRightImage = UIImage(named:"rep_cell_delete")
//            cell.bgViewRightColor = UIColor.clear
//            cell.bgViewLeftColor = UIColor.clear
//            cell.type = .slidingDoor
//            cell.backViewbackgroundColor = UIColor.clear
//            cell.bgViewInactiveColor = UIColor.clear
            cell.index = indexPath.section
            cell.configPreProductInfo(info: preAddedGoods[indexPath.section])
            let contentStr = preAddedGoods[indexPath.section].barCode ?? ""
            cell.btnClickBlock = { [unowned self] (type,index) in
                if type == 0 {
                    let inputVC = EqualExchangeInputVC()
                    inputVC.selIndex = indexPath.section
                    inputVC.contentStr = contentStr
                    inputVC.inputCallback = { [unowned self] (contentStr,index) in
                        self.queryPreProductInfoByBarCode(codeStr: contentStr, index: index)
                    }
                    self.navigationController?.pushViewController(inputVC, animated: true)
                }
                else{
                    let scanVC = EqualExchangeScanVC()
                    scanVC.selIndex = indexPath.section
                    scanVC.inputCallback = { [unowned self] (contentStr,index) in
                        self.queryPreProductInfoByBarCode(codeStr: contentStr, index: index)
                    }
                    self.navigationController?.pushViewController(scanVC, animated: true)
                }
            }
            return cell
        }
        else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "equalExchangeProductIdentifier", for: indexPath) as! EqualExchangeTabCell
            var contentStr = ""
            if inputType == .salesReturnInputType{
                cell.configGoodsBackInfo(info: backAddedGoods[indexPath.section])
                contentStr = backAddedGoods[indexPath.section].barCode ?? ""
            }
            else{
                cell.configGoodsBackInfo(info: exchangeAddedGoods[indexPath.section])
                contentStr = exchangeAddedGoods[indexPath.section].barCode ?? ""
            }
            cell.selectionStyle = .none
            cell.index = indexPath.section
            cell.btnClickBlock = { [unowned self] (type,index) in
                if type == 0 {
                    let inputVC = EqualExchangeInputVC()
                    inputVC.selIndex = indexPath.section
                    inputVC.contentStr = contentStr
                    inputVC.inputCallback = { [unowned self] (contentStr,index) in
                        self.queryProductInfoByBarCode(codeStr: contentStr, index: index)
                    }
                    self.navigationController?.pushViewController(inputVC, animated: true)
                }
                else {
                    let scanVC = EqualExchangeScanVC()
                    scanVC.selIndex = indexPath.section
                    scanVC.inputCallback = { [unowned self] (contentStr,index) in
                        print("input: \(contentStr)")
                        self.queryProductInfoByBarCode(codeStr: contentStr,index: index)
                    }
                    self.navigationController?.pushViewController(scanVC, animated: true)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if inputType == .preIMWarehousingInputType{
            return 66
        }
        return 81
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 0)
        headView.backgroundColor = UIColor.clear
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // Edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            if inputType == .exchangeInputType {
                exchangeAddedGoods.remove(at: indexPath.row)
                tabView.reloadData()
            }
            else if inputType == .preIMWarehousingInputType{
                preAddedGoods.remove(at: indexPath.row)
                tableView.reloadData()
            }
            else if inputType == .salesReturnInputType {
                backAddedGoods.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}

// MARK: - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
extension EqualExchangeProductVC {
    
    func image(forEmptyDataSet scrollVie6w: UIScrollView!) -> UIImage! {
        return UIImage.init(named: "rep_exchange_nodata")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "你可以手动或者扫码添加"
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            kCTForegroundColorAttributeName as NSAttributedStringKey: RGB(58, g: 58, b: 58),
            kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 15)]
        return NSAttributedString(string: str, attributes: multipleAttributes)
    }
    
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
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
}

//MARK: - NavBarTitleChangeable
extension EqualExchangeProductVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

//MARK: - BWSwipeRevealCellDelegate
extension EqualExchangeProductVC {
    func swipeCellActivatedAction(_ cell: BWSwipeCell, isActionLeft: Bool){
        let indexPath = tabView.indexPath(for: cell)
        print("delete index" + String(indexPath?.section ?? 0))
    }
}

