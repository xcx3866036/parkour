//
//  ChangingOrRefundingDetailVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD

class ChangingOrRefundingDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var selChangingOrRefundingItem:AfterSaleServiceInfofListItemModel?
    var detailChangingOrRefundingItem: AfterSaleServiceInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "退换货详情"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configTopUI()
        self.configUI()
        self.updateDetailUI(infoModel: nil)
        self.fetchAfterSaleServiceInfo()
    }
    
    func updateDetailUI(infoModel: AfterSaleServiceInfoModel?){
        let nameStr = infoModel?.order?.customerName ?? ""
        let telStr = " " + (infoModel?.order?.customerCellphone ?? "")
        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(38, g: 38, b: 38),
                                 NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(38, g: 38, b: 38),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        let nameAttStr = NSMutableAttributedString.init(string: nameStr, attributes: singleAttribute1)
        let telAttStr = NSAttributedString.init(string: telStr, attributes: singleAttribute2)
        nameAttStr.append(telAttStr)
        userTelLab.attributedText = nameAttStr
        
        addressLab.text = infoModel?.order?.customerAddress
        
        let sumStr = "实付款"
        let sumPriceStr = "￥" + String.init(format: "%.2f", infoModel?.order?.amount ?? 0.0)
        
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: RGB(36, g: 36, b: 36),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(255, g: 75, b: 75),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        let sumAttStr = NSMutableAttributedString.init(string: sumStr, attributes: singleAttribute3)
        let subSumAttStr = NSAttributedString.init(string: sumPriceStr, attributes: singleAttribute4)
        sumAttStr.append(subSumAttStr)
        sumLab.attributedText = sumAttStr
        if let info = infoModel{
            selChangingOrRefundingItem?.id = info.id
            selChangingOrRefundingItem?.serviceNo = info.serviceNo
            selChangingOrRefundingItem?.type = info.type
            selChangingOrRefundingItem?.orderId = info.orderId
            selChangingOrRefundingItem?.orderNo = info.orderNo
            selChangingOrRefundingItem?.applyUser = info.applyUser
            selChangingOrRefundingItem?.applyUserName = info.applyUserName
            selChangingOrRefundingItem?.createTime = info.createTime
            selChangingOrRefundingItem?.dealStatus = info.dealStatus
            selChangingOrRefundingItem?.dealStatus = info.dealStatus
            selChangingOrRefundingItem?.refundTime = info.refundTime
            selChangingOrRefundingItem?.remark = info.remark
            selChangingOrRefundingItem?.goodsAmount = info.goodsCount
        }
        self.updateTopInfoView()
        tabView.reloadData()
    }
    
    func updateTopInfoView(){
        let dealStatus = selChangingOrRefundingItem?.dealStatus ?? 0
        let resultStatusInfo = selChangingOrRefundingItem?.configAfterSalesStatusInfo()
        let needHideCancleBtn = resultStatusInfo?.isHiddenCancel ?? true
        let needHideScanBtn = resultStatusInfo?.isHiddenScan ?? true
        let btnTitle = resultStatusInfo?.btnStr ?? ""
        let statusImgName = resultStatusInfo?.statusImgStr ?? ""
        let stausStr = resultStatusInfo?.statusStr ?? ""
        
        cancleBtn.isHidden = needHideCancleBtn
        scanBtn.isHidden = needHideScanBtn
        scanBtn.setTitle(btnTitle, for: .normal)
        
        if dealStatus == 1 || dealStatus == 2 || dealStatus == 5 || dealStatus == 7 || dealStatus == 6 {
            topBgView.addSubview(stepIndicatorView)
            stepIndicatorView.stepMarks = resultStatusInfo?.markStrs ?? [""]
            stepIndicatorView.currentStep = resultStatusInfo?.step ?? 0
        }
        else{
            statusMarkImgView.image = UIImage.init(named: statusImgName)
            statusMarkLab.text = stausStr
            topBgView.addSubview(statusMarkImgView)
            statusMarkImgView.snp.makeConstraints { (make) in
                make.height.width.equalTo(24)
                make.left.equalToSuperview().offset(29)
                make.centerY.equalToSuperview().offset(-15)
            }
            topBgView.addSubview(statusMarkLab)
            statusMarkLab.snp.makeConstraints { (make) in
                make.height.equalTo(25)
                make.centerY.equalTo(statusMarkImgView.snp.centerY)
                make.right.equalToSuperview()
                make.left.equalTo(statusMarkImgView.snp.right).offset(8)
            }
        }
    }
    
    // MARK: - function
    @objc func scanBtnClick(sender: UIButton){
        print("scan")
        let dealStatus = selChangingOrRefundingItem?.dealStatus ?? 0
        switch dealStatus {
        case 1:
            self.startToRecyleWithIndex(type: 0, index: 0,recyleType: .forRecycle)
        case 2:
            self.startToReNewWithIndex(type: 0, index: 0)
        case 5:
            self.startToCheckWithIndex(type: 0, index: 0)
        case 6:
            self.startToRecyleWithIndex(type: 0, index: 0,recyleType: .forReturn)
        case 7:
            self.startToRefundWithIndex(type: 0, index: 0)
        default:
            print("scan")
        }
    }
    
    @objc func cancleBtnClick(sender: UIButton){
        print("cancel")
        let commitVC = CommitAddRemarkVC()
        commitVC.operateType = .cancleAfterSales
        commitVC.selChangingOrRefundingItem = self.selChangingOrRefundingItem
        self.navigationController?.pushViewController(commitVC, animated: true)
    }
    
     func startToRecyleWithIndex(type: Int, index: Int, recyleType: RecycleType){
        //扫码回收
        let recyleVC = ScanRecycleVC()
        recyleVC.type = recyleType
        recyleVC.selChangingOrRefundingItem = self.selChangingOrRefundingItem
        self.navigationController?.pushViewController(recyleVC, animated: true)
    }
    
    func startToReNewWithIndex(type: Int, index: Int){
        //扫码换新
        let renewVC = ScanRenewVC()
        renewVC.selChangingOrRefundingItem = self.selChangingOrRefundingItem
        self.navigationController?.pushViewController(renewVC, animated: true)
    }
    
    func startToCheckWithIndex(type: Int, index: Int){
        //退货检查
        let checkVC = CheckBackGoodsVC()
        checkVC.selChangingOrRefundingItem = self.selChangingOrRefundingItem
        self.navigationController?.pushViewController(checkVC, animated: true)
    }
    func startToRefundWithIndex(type: Int, index: Int){
        //退款详情
        let completeCheckVC = CompleteCheckBackGoodsVC()
        self.navigationController?.pushViewController(completeCheckVC, animated: true)
    }
    
    func checkOrderDetail() {
        let result = self.backToSpecificVC(VCName: "OrderDetailVC")
        if result == false{
            if let detailInfo = detailChangingOrRefundingItem{
                let orderVC = OrderDetailVC()
                orderVC.selOrder = detailInfo.creatOrderListItem()
                self.navigationController?.pushViewController(orderVC, animated: true)
            }
        }
    }
    
    func calRemarkStrHeight() -> CGFloat {
        let remarks = detailChangingOrRefundingItem?.remark ?? ""
        if remarks.length <= 0 {
            return 0
        }
        let height = remarks.height(SCREEN_WIDTH - 30 - 20, font: UIFont.systemFont(ofSize: 13), lineBreakMode: nil)
        
        return height
    }
    
    //MARK: - UI
    lazy var topBgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    lazy var stepIndicatorView: StepIndicatorView = {
        let stepIndicatorView = UIFactoryGenerateStepIndicatorView()
        let  currentStep = selChangingOrRefundingItem?.configAfterSalesStatusInfo().step ?? 0
        let markStrs = selChangingOrRefundingItem?.configAfterSalesStatusInfo().markStrs ?? [String]()
        let dealStatus = self.selChangingOrRefundingItem?.dealStatus ?? 0
        stepIndicatorView.stepMarks = markStrs
        stepIndicatorView.direction = .customCenter
        stepIndicatorView.numberOfSteps = markStrs.count
        stepIndicatorView.currentStep = currentStep
        stepIndicatorView.stepWith = 60
        stepIndicatorView.frame = CGRect(x: 34, y: 22, width: SCREEN_WIDTH - 34 - 34, height: 72)
        stepIndicatorView.backgroundColor = UIColor.clear
        return stepIndicatorView
    }()
    
    lazy var statusMarkImgView: UIImageView = {
        let imgView = UIFactoryGenerateImgView(imageName: "order_status_cancle")
        return imgView
    }()
    
    lazy var statusMarkLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 18, color: UIColor.white, placeText: "订单交易已取消")
        lab.font = UIFont.boldSystemFont(ofSize: 18)
        return lab
    }()
    
    lazy var infoBgView: UIImageView = {
        let bgView = UIFactoryGenerateImgView(imageName: "order_address_bg")
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var userTelLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 12, color: RGB(38, g: 38, b: 38), placeText: "")
        return lab
    }()
    
    lazy var addressLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 13, color: RGB(135, g: 135, b: 135), placeText: "")
        lab.numberOfLines = 0
        return lab
    }()
    
    
    lazy var bottomBgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    
    lazy var sumLab: UILabel = {
        let lab = UIFactoryGenerateLab(fontSize: 12, color: RGB(28, g: 28, b: 28), placeText: "实付款")
        return lab
    }()
    
    lazy var scanBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "扫码回收", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "取消售后", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(cancleBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(OrderProductInfoCell.classForCoder(), forCellReuseIdentifier: "orderProductInfoCellIdentifier")
        tabView.register(PreProductsNOCell.classForCoder(), forCellReuseIdentifier: "orderInfoCellIdentifier")
        tabView.register(OrderRemarksCell.classForCoder(), forCellReuseIdentifier: "orderRemarksCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        //        tabView.emptyDataSetSource = self
        //        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    func configTopUI(){
        
        self.view.addSubview(topBgView)
        topBgView.snp.makeConstraints { (make) in
            make.height.equalTo(125)
            make.left.right.top.equalToSuperview()
        }
//        topBgView.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 125))
        topBgView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "step_head_bg")!)
    }
    
    func configUI() {
        self.view.addSubview(infoBgView)
        infoBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(90)
            make.top.equalTo(topBgView.snp.bottom).offset(-36)
        }
        infoBgView.addSubview(userTelLab)
        userTelLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-11)
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(10)
        }
        infoBgView.addSubview(addressLab)
        addressLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-11)
            make.bottom.equalToSuperview()
            make.top.equalTo(userTelLab.snp.bottom).offset(0)
        }
        
        self.view.addSubview(bottomBgView)
        bottomBgView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
        bottomBgView.addSubview(scanBtn)
        scanBtn.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-9)
            make.centerY.equalToSuperview()
        }
        
        bottomBgView.addSubview(cancleBtn)
        cancleBtn.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.right.equalTo(scanBtn.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        bottomBgView.addSubview(sumLab)
        sumLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalTo(cancleBtn.snp.left).offset(-4)
            make.height.equalTo(21)
            make.centerY.equalToSuperview()
        }
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(infoBgView.snp.bottom).offset(0)
            make.bottom.equalTo(bottomBgView.snp.top).offset(-20)
        }
    }
}

//MARK: - Network
extension ChangingOrRefundingDetailVC{
    func fetchAfterSaleServiceInfo(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.queryAfterSaleServiceInfo(id: selChangingOrRefundingItem?.id ?? 0), model: AfterSaleServiceInfoModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateDetailUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.detailChangingOrRefundingItem = result
                self.updateDetailUI(infoModel: result)
            }
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ChangingOrRefundingDetailVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return detailChangingOrRefundingItem?.order?.orderDetails.count ?? 0
        }
        else if section == 1 {
            return 5
        }
        else if section == 2 {
            return 1
        }
        else if section == 3 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderProductInfoCellIdentifier", for: indexPath) as! OrderProductInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
//            cell.configInfoByIndex(index: indexPath.row)
            let product = detailChangingOrRefundingItem?.order?.orderDetails[indexPath.row] ?? OrderDetailProductModel()
            cell.configProductInfo(infoModel: product)
            return cell
        }
        else if indexPath.section == 1 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderInfoCellIdentifier", for: indexPath) as! PreProductsNOCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            if indexPath.section == 1 {
                cell.detailBtn.isHidden = true
                cell.cellClickBlock = nil
                cell.configChangingOrTrfundingInfoByIndex(afterSalesInfo: selChangingOrRefundingItem ?? AfterSaleServiceInfofListItemModel(),detail:detailChangingOrRefundingItem, index: indexPath.row)
            }
            else{
                cell.detailBtn.isHidden = false
                cell.cellClickBlock = { [unowned self] (index) in
                    self.checkOrderDetail()
                }
                cell.configOrderChangingOrTrfundingInfoByIndex(info:detailChangingOrRefundingItem,index: indexPath.row)
            }
           
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderRemarksCellIdentifier", for: indexPath) as! OrderRemarksCell
            let remarks = detailChangingOrRefundingItem?.remark ?? ""
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.configRemarksStr(remarks:remarks)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return 100
        }
        else if section == 1 {
            return 30
        }
        else if section == 2 {
            return 30 + 10
        }
        else if section == 3 {
            return self.calRemarkStrHeight() + 10.0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var tipsStr = ""
        if section == 0 {
            tipsStr = "商品信息"
        }
        else if section == 1 {
            tipsStr = "服务信息"
        }
        else if section == 2 {
            tipsStr = "订单信息"
        }
        else if section == 3 {
            tipsStr = "备注信息"
        }
        let headView = UIView.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 48)
        headView.backgroundColor = UIColor.clear
        
        let bgView = UIView.init(x: 15, y: 8, w: SCREEN_WIDTH - 30, h: 40)
        bgView.backgroundColor = UIColor.white
        headView.addSubview(bgView)
        
        let lab = UIFactoryGenerateLab(fontSize: 14, color: RGB(88, g: 88, b: 88), placeText: tipsStr)
        lab.frame = CGRect.init(x: 24, y: 8, w: headView.w - 48, h: 40)
        headView.addSubview(lab)
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - UIScrollViewDelegate
extension ChangingOrRefundingDetailVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 48
        if scrollView.contentOffset.y >= 0 &&  scrollView.contentOffset.y <= sectionHeaderHeight{
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
        else if scrollView.contentOffset.y > sectionHeaderHeight{
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }
}




