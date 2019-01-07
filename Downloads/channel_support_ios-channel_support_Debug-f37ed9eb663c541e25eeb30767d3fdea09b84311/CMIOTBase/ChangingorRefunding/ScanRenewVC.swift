//
//  ScanRenewVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/12.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD

class ScanRenewVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NavBarTitleChangeable,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{

    var renewAddedGoods = [OutGoodsModel]()
    var selChangingOrRefundingItem:AfterSaleServiceInfofListItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "扫码换新"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        self.fetchExchangeBackGoodsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    override func backToUpVC() {
        let result = self.backToSpecificVC(VCName: "ChangingOrRefundingVC")
        if result == false {
            NotificationCenter.default.post(name: Notification.Name(kNeedUpdateOrderListNotification), object: nil)
            let _ = self.backToSpecificVC(VCName: "OrderManagerVC")
        }
    }
    
    func updateExchangeBackGoodsList(addedInfo:SaledGoodsModel?){
        if let info = addedInfo {
            renewAddedGoods = info.list ?? []
        }
        tabView.reloadData()
    }
    
    func updatePreAddGoodsUI(addedInfo:OutGoodsModel?,index:Int){
        if let goods = addedInfo {
            let isBad = goods.isBad ?? 0
            if isBad == 1 {
                SVProgressHUD.showInfo(withStatus: "商品已损坏,请重新添加！")
                return
            }
            if index < 0 {
                renewAddedGoods.append(goods)
            }
            else{
                if renewAddedGoods.count >= index + 1 {
                    renewAddedGoods[index].exchangeOutGoods = goods
                }
            }
        }
        tabView.reloadData()
    }
    
    func clearUI() {
        let commpleteVC = CompleteScanRenewVC()
        commpleteVC.operateType = .exchangeGoods
        self.navigationController?.pushViewController(commpleteVC, animated: true)
        NotificationCenter.default.post(name: Notification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton){
        self.commitReplaceGoods()
    }
    
    //MARK: - Network
    // 获取换货回收的商品
    func fetchExchangeBackGoodsList(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.exchangeBackGoodsList(id: selChangingOrRefundingItem?.id ?? 0), model: SaledGoodsModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateExchangeBackGoodsList(addedInfo: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateExchangeBackGoodsList(addedInfo: result)
            }
        }
    }
    
    // 通过二维码获取可换货商品
    func queryPreProductInfoByBarCode(codeStr:String,index:Int){
        self.noNetwork = false
        let changedGoods = renewAddedGoods[index]
         ApiLoadingProvider.request(PAPI.queryOutGoods(barCode:codeStr,productId:changedGoods.productId ?? 0),model: OutGoodsModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updatePreAddGoodsUI(addedInfo: nil,index: index)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updatePreAddGoodsUI(addedInfo: result,index: index)
            }
        }
    }
    
    func commitReplaceGoods(){
        var replaceList = [[String:Int]]()
        guard renewAddedGoods.count > 0 else {
            SVProgressHUD.showInfo(withStatus: "请先添加商品")
            return
        }
        for goods in renewAddedGoods {
            if let changeedGoods = goods.exchangeOutGoods {
                if changeedGoods.isSatisfyExchangeNew() {
                    let item = ["oldGoodsId":(goods.id ?? 0),
                                "newGoodsId":(goods.exchangeOutGoods?.id ?? 0)]
                    replaceList.append(item)
                }
                else {
                    SVProgressHUD.showInfo(withStatus: "请添加正确的商品")
                    return
                }
            }
            else{
                SVProgressHUD.showInfo(withStatus: "请添加商品")
                return
            }
        }
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.replaceGoods(id: selChangingOrRefundingItem?.id ?? 0,replaceList:replaceList), model: BaseModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
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
        stepIndicatorView.stepMarks = ["扫码回收","扫码换新"]
        stepIndicatorView.direction = .customCenter
        stepIndicatorView.numberOfSteps = 2
        stepIndicatorView.currentStep = 1
        stepIndicatorView.stepWith = 60
        stepIndicatorView.frame = CGRect(x: 15, y: 15, width: SCREEN_WIDTH - 15 - 15, height: 72)
        return stepIndicatorView
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(ScanRenewCell.classForCoder(),
                         forCellReuseIdentifier: "scanRenewCellIdentifier")
        
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "换新安装完成",imageName:"")
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
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(91)
            make.bottom.equalTo(commitBtn.snp.top).offset(-10)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ScanRenewVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return renewAddedGoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanRenewCellIdentifier", for: indexPath) as! ScanRenewCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        let contentStr = renewAddedGoods[indexPath.row].exchangeOutGoods?.barCode ?? ""
        cell.configRenewInfo(info: renewAddedGoods[indexPath.row])
        cell.btnClickBlock = { [unowned self] (type,index) in
            if type == 0{
                let inputVC = EqualExchangeInputVC()
                inputVC.selIndex = indexPath.row
                inputVC.contentStr = contentStr
                inputVC.inputCallback = { [unowned self] (contentStr,index) in
                   print("input: \(contentStr)")
                   self.queryPreProductInfoByBarCode(codeStr: contentStr, index: index)
                }
                self.navigationController?.pushViewController(inputVC, animated: true)
            }
            else{
                let scanVC = EqualExchangeScanVC()
                scanVC.selIndex = indexPath.row
                scanVC.inputCallback = { [unowned self] (contentStr,index) in
                    print("input: \(contentStr)")
                    self.queryPreProductInfoByBarCode(codeStr: contentStr, index: index)
                }
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // Edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
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
            
        }
    }
}

//MARK: - BWSwipeRevealCellDelegate
extension ScanRenewVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
   }
}

extension ScanRenewVC {
    
    func image(forEmptyDataSet scrollVie6w: UIScrollView!) -> UIImage! {
        let imageName = self.noNetwork ? "nonetwork" : "nodata"
        return UIImage.init(named: imageName)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let titleStr = self.noNetwork ? "网络出错了，请检查链接" : "暂时没有数据记录"
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
        if self.noNetwork {
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
        if self.noNetwork {
            self.fetchExchangeBackGoodsList()
        }
    }
}
