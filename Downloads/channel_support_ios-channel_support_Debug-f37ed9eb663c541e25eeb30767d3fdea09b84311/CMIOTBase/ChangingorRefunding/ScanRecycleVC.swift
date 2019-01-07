//
//  ScanRecycleVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet

enum RecycleType {
    case forRecycle
    case forReturn
}

class ScanRecycleVC: UIViewController,NavBarTitleChangeable,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    var type: RecycleType = .forRecycle
    var selChangingOrRefundingItem:AfterSaleServiceInfofListItemModel?
    var recyleAddedGoods = [OutGoodsModel]()
    var backAddedGoods = [OutGoodsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = type == .forRecycle ? "扫码回收" : "退货回收"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        if type == .forReturn {
            self.querySaledProductInfoByBarCode(codeStr: "", index: -1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    override func backToUpVC() {
        if type == .forReturn {
            let result = self.backToSpecificVC(VCName: "ChangingOrRefundingVC")
            if result == false{
                NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
                let _ = self.backToSpecificVC(VCName: "OrderManagerVC")
            }
        }
        else{
            self.popVC()
        }
    }
    
    
    func updateRecyleAddGoodsUI(addedInfo:SaledGoodsModel?,index:Int){
        if let addedGoodsInfo = addedInfo {
            if addedGoodsInfo.list?.count ?? 0 <= 0 {
                if index >= 0 {
                     SVProgressHUD.showInfo(withStatus: "请输入正确的编码")
                }
            }
            if type == .forRecycle{
                let goodsInfo = addedGoodsInfo.list?.first
                if let goods = goodsInfo {
                    if self.recyleGoodsContainGoods(goods: goods){
                         SVProgressHUD.showInfo(withStatus: "请勿添加重复产品!")
                    }
                    else{
                        if index < 0 {
                            recyleAddedGoods.append(goods)
                        }
                        else{
                            if recyleAddedGoods.count >= index + 1 {
                                recyleAddedGoods[index] = goods
                            }
                        }
                    }
                }
            }
            else if type == .forReturn {
                if let goodsList = addedGoodsInfo.list {
                    if index < 0 {
                        backAddedGoods = goodsList
                    }
                    else {
                        if backAddedGoods.count >= index + 1 {
                            backAddedGoods[index].exchangeOutGoods = goodsList.first ?? OutGoodsModel()
                        }
                    }
                }
            }
        }
        tabView.reloadData()
    }
    
    func clearUI(){
        if type == .forRecycle {
            var inReserve = [OutGoodsModel]()
            for goods in recyleAddedGoods {
                if goods.isSatisfyRecyle() {
                    continue
                }
                inReserve.append(goods)
            }
            self.recyleAddedGoods = inReserve
            tabView.reloadData()
            let renewVC = ScanRenewVC()
            renewVC.selChangingOrRefundingItem = self.selChangingOrRefundingItem
            self.navigationController?.pushViewController(renewVC, animated: true)
             NotificationCenter.default.post(name: Notification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
        }
        else if type == .forReturn {
            let completeCheckVC = CompleteCheckBackGoodsVC()
            self.navigationController?.pushViewController(completeCheckVC, animated: true)
            NotificationCenter.default.post(name: Notification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
        }
    }
   
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
        if type == .forRecycle{
            if recyleAddedGoods.count <= 0 {
                SVProgressHUD.showInfo(withStatus: "请先添加商品")
                return
            }
            self.commitReturnGoods()
        }
        else if type == .forReturn {
            if backAddedGoods.count <= 0 {
                SVProgressHUD.showInfo(withStatus: "请先添加商品")
                return
            }
            self.commitBackReturnGoods()
        }
    }
    
    @objc func scanBtnClick(sender: UIButton) {
        let scanVC = EqualExchangeScanVC()
        scanVC.selIndex = -1
        scanVC.inputCallback = { [unowned self] (contentStr,index) in
            print("input: \(contentStr)")
            self.querySaledProductInfoByBarCode(codeStr: contentStr, index: -1)
        }
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
    @objc func inputBtnClick(sender: UIButton) {
        let inputVC = EqualExchangeInputVC()
        inputVC.selIndex = -1
        inputVC.inputCallback = { [unowned self] (contentStr,index) in
            print("input: \(contentStr)")
            self.querySaledProductInfoByBarCode(codeStr: contentStr, index: -1)
        }
        self.navigationController?.pushViewController(inputVC, animated: true)
    }
    
    func recyleGoodsContainGoods(goods:OutGoodsModel) -> Bool{
        let goodsBarcode = goods.barCode ?? ""
        for item in recyleAddedGoods {
            let itemBarCode = item.barCode ?? ""
            if itemBarCode == goodsBarcode {
                return true
            }
        }
        return false
    }
    
    //MARK: - Network
    // 通过二维码获取已售出商品信息
    func querySaledProductInfoByBarCode(codeStr:String,index:Int){
        self.noNetwork = false
        let barCodes = codeStr.length > 0 ? [codeStr] : []
        ApiLoadingProvider.request(PAPI.querySaledGoods(inBarCodes: barCodes, orderId: selChangingOrRefundingItem?.orderId ?? 0, inCurrentStatuses: [3,7]), model: SaledGoodsModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateRecyleAddGoodsUI(addedInfo: nil,index: index)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateRecyleAddGoodsUI(addedInfo: result,index: index)
            }
        }
    }
    
    ///换货扫码回收
    func commitReturnGoods(){
        self.noNetwork = false
        var goodsList = [Int]()
        for goods in recyleAddedGoods{
            if goods.isSatisfyRecyle(){
               goodsList.append((goods.id ?? 0))
            }
        }
        guard goodsList.count > 0 else {
            SVProgressHUD.showInfo(withStatus: "请添加正确的商品")
            return
        }
        ApiLoadingProvider.request(PAPI.returnGoods(id:selChangingOrRefundingItem?.id ?? 0 , goodsList: goodsList), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                self.clearUI()
            }
        }
    }
    
    ///退货扫码回收
    func commitBackReturnGoods(){
        self.noNetwork = false
        var goodsList = [Int]()
        for goods in backAddedGoods{
            if let barCode = goods.barCode, barCode.length > 0 {
                if barCode == (goods.exchangeOutGoods?.barCode ?? ""){
                     goodsList.append((goods.id ?? 0))
                }
                else{
                    SVProgressHUD.showInfo(withStatus: "请添加正确的商品")
                    return
                }
            }
        }
        guard goodsList.count > 0 else {
             SVProgressHUD.showInfo(withStatus: "请添加商品")
             return
        }
        ApiLoadingProvider.request(PAPI.backGoods(id:selChangingOrRefundingItem?.id ?? 0 , goodsList: goodsList), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                SVProgressHUD.showSuccess(withStatus: resultInfo.1)
                self.clearUI()
            }
        }
    }
    
    //MARK: - UI
    lazy var stepBgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = UIColor.clear
        return bgview
    }()
    
    lazy var stepIndicatorView: StepIndicatorView = {
        let stepIndicatorView = UIFactoryGenerateStepIndicatorView()
        let arr = type == .forRecycle ? ["扫码回收","扫码换新"] : ["退货回收","扫码换新"]
        stepIndicatorView.stepMarks = arr
        stepIndicatorView.direction = .customCenter
        stepIndicatorView.numberOfSteps = 2
        stepIndicatorView.currentStep = 0
        stepIndicatorView.stepWith = 60
        stepIndicatorView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 15 - 15, height: 72)
        return stepIndicatorView
    }()
    
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(ScanRecyleCell.classForCoder(), forCellReuseIdentifier: "scanRecyleCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18 * kDrawdownRatioW, color: RGB(255, g: 255, b: 255), placeText: "", imageName: "rep_exchange_scan1")
        btn.addTarget(self, action: #selector(ScanRecycleVC.scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var inputBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18 * kDrawdownRatioW, color: RGB(255, g: 255, b: 255), placeText: "", imageName: "rep_exchange_input1")
        btn.addTarget(self, action: #selector(ScanRecycleVC.inputBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "换货回收完成",imageName:"")
        let btnStr = type == .forRecycle ? "换货回收完成" : "退货回收完成"
        btn.addAttTitle(mainTitle: btnStr, subTitle: "（下一步）")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        return btn
    }()
    
    func configUI(){
        
        self.view.addSubview(stepBgView)
        stepBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(125)
        }
//        stepBgView.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 125))
        stepBgView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "step_head_bg")!)
        stepBgView.addSubview(stepIndicatorView)
        
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
            make.bottom.equalTo(commitBtn.snp.top).offset(-18 * kDrawdownRatioH)
        }
        
        self.view.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.height.equalTo(41 * kDrawdownRatioW)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(width)
            make.bottom.equalTo(commitBtn.snp.top).offset(-18 * kDrawdownRatioH)
        }
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalTo(scanBtn.snp.top).offset(-15)
            make.top.equalToSuperview().offset(91)
        }
        
        if type == .forReturn {
            inputBtn.isHidden = true
            scanBtn.isHidden = true
        }
    }
}

//MARK: - BWSwipeRevealCellDelegate
extension ScanRecycleVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ScanRecycleVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .forRecycle {
            return recyleAddedGoods.count
        }
        else if type == .forReturn {
            return backAddedGoods.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanRecyleCellIdentifier", for: indexPath) as! ScanRecyleCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        var contentStr = ""
        if type == .forRecycle {
           cell.configRecyleGoodsInfo(info: recyleAddedGoods[indexPath.row],isReturn: false)
            contentStr = recyleAddedGoods[indexPath.row].barCode ?? ""
        }
        else if type == .forReturn {
             cell.configRecyleGoodsInfo(info: backAddedGoods[indexPath.row],isReturn: true)
            contentStr = backAddedGoods[indexPath.row].exchangeOutGoods?.barCode ?? ""
        }
        cell.btnClickBlock = { [unowned self] (type,index) in
            if type == 0 {
                let inputVC = EqualExchangeInputVC()
                inputVC.selIndex = indexPath.row
                inputVC.contentStr = contentStr
                inputVC.inputCallback = { [unowned self] (contentStr,index) in
                    print("input: \(contentStr)")
                    self.querySaledProductInfoByBarCode(codeStr: contentStr, index: index)
                }
                self.navigationController?.pushViewController(inputVC, animated: true)
            }
            else{
                let scanVC = EqualExchangeScanVC()
                scanVC.selIndex = indexPath.row
                scanVC.inputCallback = { [unowned self] (contentStr,index) in
                    print("input: \(contentStr)")
                    self.querySaledProductInfoByBarCode(codeStr: contentStr, index: index)
                }
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        if type == .forRecycle {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            if type == .forRecycle {
                recyleAddedGoods.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
}

// MARK: - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
extension ScanRecycleVC {
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
