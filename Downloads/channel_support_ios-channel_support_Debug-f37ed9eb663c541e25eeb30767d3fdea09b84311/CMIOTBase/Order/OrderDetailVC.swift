//
//  OrderDetailVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/18.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class OrderDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var selOrder: OrderInofListItemModel?
    var detailOrder: OrderDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configTopUI()
        self.configUI()
        self.updateUI(infoModel: nil)
        self.fetchOrderDetail()
    }
    
    func updateUI(infoModel:OrderDetailModel?){
        detailOrder = infoModel
        let nameStr = infoModel?.customerName ?? ""
        let telStr = " " + (infoModel?.customerCellphone ?? "")
        let singleAttribute1 = [ NSAttributedStringKey.foregroundColor: RGB(38, g: 38, b: 38),
                                 NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        let singleAttribute2 = [ NSAttributedStringKey.foregroundColor: RGB(38, g: 38, b: 38),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        let nameAttStr = NSMutableAttributedString.init(string: nameStr, attributes: singleAttribute1)
        let telAttStr = NSAttributedString.init(string: telStr, attributes: singleAttribute2)
        nameAttStr.append(telAttStr)
        userTelLab.attributedText = nameAttStr
        
        addressLab.text = infoModel?.customerAddress ?? ""
        
        let sumStr = "实付款"
        let sumPriceStr = "￥" + String((selOrder?.amount ?? 0.0))
        let singleAttribute3 = [ NSAttributedStringKey.foregroundColor: RGB(36, g: 36, b: 36),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        let singleAttribute4 = [ NSAttributedStringKey.foregroundColor: RGB(255, g: 75, b: 75),
                                 NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        let sumAttStr = NSMutableAttributedString.init(string: sumStr, attributes: singleAttribute3)
        let subSumAttStr = NSAttributedString.init(string: sumPriceStr, attributes: singleAttribute4)
        sumAttStr.append(subSumAttStr)
        sumLab.attributedText = sumAttStr
        if let detalInfo = infoModel {
            self.selOrder?.isReturnable = detalInfo.isReturnable
            self.selOrder?.isExchangeable = detalInfo.isExchangeable
            self.selOrder?.returnGoodsDays = detalInfo.returnGoodsDays
            self.selOrder?.exchangeGoodsDays = detalInfo.exchangeGoodsDays 
        }
        tabView.reloadData()
    }
    
    // MARK: - function
    @objc func scanBtnClick(sender: UIButton){
        print("scan")
        switch selOrder?.orderStatus ?? 0 {
        case 1:
             self.startInstallWithIndex(type: 0, index: 0)
        case 2:
            self.startInputCodeWithIndex(type: 0, index: 0)
        case 5:
//           self.startInstallWithIndex(type: 0, index: 0)
            break
        case 3:
            self.startPayNowWithIndex(type: 1, index: 0)
        case 4: fallthrough
        case 7: fallthrough
        case 6:
            self.startAfterSalesWithIndex(type: 0, index: 0)
        case 8:
            self.startBuyWithIndex(type: 0, index: 0)
        case 9:
            break
        default:
            print("error")
        }
    }
    
    @objc func cancleBtnClick(sender: UIButton){
        let commitVC = CommitAddRemarkVC()
        commitVC.operateType = .cancleOrder
        self.navigationController?.pushViewController(commitVC, animated: true)
    }
    
    func startInstallWithIndex(type: Int, index: Int) {
        print("扫码安装")
        let setupVC = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "SetUpViewController") as! SetUpViewController
         setupVC.currentId = selOrder?.id ?? 0
        self.navigationController?.pushViewController(setupVC, animated: true)
    }
    
    func startInputCodeWithIndex(type: Int, index: Int) {
        print("输入验证码")
        let identifyingVC = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "IdentifyingViewController") as! IdentifyingViewController
        identifyingVC.currentId = selOrder?.id ?? 0
        self.navigationController?.pushViewController(identifyingVC, animated: true)
    }
    
    func startAfterSalesWithIndex(type: Int, index: Int){
        print("申请售后")
        let afterSaleVC = ChooseAfterSaleTypeVC()
        afterSaleVC.selOrder = selOrder
        self.navigationController?.pushViewController(afterSaleVC, animated: true)
    }
    
    func startBuyWithIndex(type: Int, index: Int) {
        print("再次购买")
        let saleVC = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "IssueViewController") as! IssueViewController
        self.navigationController?.pushViewController(saleVC, animated: true)
    }
    
    func startPayNowWithIndex(type: Int, index: Int) {
        print("立即收款")
        let payVC = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "PaySelectViewController") as! PaySelectViewController
         payVC.currentId = selOrder?.id ?? 0
        self.navigationController?.pushViewController(payVC, animated: true)
    }
    
    func calRemarkStrHeight(remark:String) -> CGFloat {
        if remark.length <= 0 {
            return 0.0
        }
        let height = remark.height(SCREEN_WIDTH - 30 - 20, font: UIFont.systemFont(ofSize: 13), lineBreakMode: nil)
        return height
    }
    
    func gotoChangingORefungingDetail(){
       let result = self.backToSpecificVC(VCName: "ChangingOrRefundingDetailVC")
        if result == false {
            let detailVC = ChangingOrRefundingDetailVC()
            detailVC.selChangingOrRefundingItem = detailOrder?.transformToAfterSaleServiceInfofListItem()
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    //MARK: - Network
    func fetchOrderDetail(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.queryOrderDetail(id: selOrder?.id ?? 0), model: OrderDetailModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateUI(infoModel: result)
            }
        }
    }
    
    //MARK: - UI
    lazy var topBgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    lazy var stepIndicatorView: StepIndicatorView = {
        let stepIndicatorView = UIFactoryGenerateStepIndicatorView()
        let status = selOrder?.orderStatus ?? 0
        let step = selOrder?.configOrderStatusInfo().step ?? 0
        stepIndicatorView.stepMarks = ["下单","扫码安装","输入验收码","收款"]
        stepIndicatorView.numberOfSteps = 4
        stepIndicatorView.currentStep = step
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
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "扫码安装", imageName: "")
        btn.setCornerRadius(radius: 4)
        btn.addBorder(width: 1, color: RGB(151, g: 151, b: 151))
        btn.addTarget(self, action: #selector(scanBtnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 12, color: RGB(36, g: 36, b: 36), placeText: "取消订单", imageName: "")
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
        
        let status = selOrder?.orderStatus ?? 0
        let resultInfo = selOrder?.configOrderStatusInfo()
        
        let btnTitle = resultInfo?.btnStr ?? ""
        let needHideCancleBtn = resultInfo?.isHidenCancle ?? true
        let statusImgName = resultInfo?.statusImgStr ?? ""
        let statusStr = resultInfo?.statusStr ?? ""
        
        scanBtn.setTitle(btnTitle, for: .normal)
        cancleBtn.isHidden = needHideCancleBtn
        scanBtn.isHidden = btnTitle.length <= 0 ? true : false
        
        if status == 1 || status == 2 || status == 3{
            topBgView.addSubview(stepIndicatorView)
        }
        else{
            statusMarkImgView.image = UIImage.init(named: statusImgName)
            statusMarkLab.text = statusStr
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

// MARK: - UITableViewDelegate UITableViewDataSource
extension OrderDetailVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let orderStatus = selOrder?.orderStatus ?? 0
        // 售后中
        if orderStatus == 5 || orderStatus == 9 {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return detailOrder?.orderDetails.count ?? 0
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
        let orderStatus = selOrder?.orderStatus ?? 0
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderProductInfoCellIdentifier", for: indexPath) as! OrderProductInfoCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.configProductInfo(infoModel: detailOrder?.orderDetails[indexPath.row])
//            cell.configInfoByIndex(index: indexPath.row)
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderInfoCellIdentifier", for: indexPath) as! PreProductsNOCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.index = indexPath.row
            cell.detailBtn.isHidden = true
            cell.cellClickBlock = nil
            cell.configOrderInfoByInfo(info: selOrder!, index: indexPath.row)
            return cell
        }
        else if indexPath.section == 2 {
            if orderStatus == 5 || orderStatus == 9 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "orderInfoCellIdentifier", for: indexPath) as! PreProductsNOCell
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.clear
                 cell.index = indexPath.row
                cell.detailBtn.isHidden = false
                cell.cellClickBlock = { [unowned self] (index) in
                   self.gotoChangingORefungingDetail()
                }
                cell.configOrderChangingOrTrfundingInfo(info: detailOrder, index: indexPath.row)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "orderRemarksCellIdentifier", for: indexPath) as! OrderRemarksCell
                let remarks = detailOrder?.remark ?? ""
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor.clear
                cell.configRemarksStr(remarks:remarks)
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderRemarksCellIdentifier", for: indexPath) as! OrderRemarksCell
            let remarks = detailOrder?.remark ?? ""
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.configRemarksStr(remarks:remarks)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let orderStatus = selOrder?.orderStatus ?? 0
        let section = indexPath.section
        if section == 0 {
            return 100
        }
        else if section == 1 {
            return 30
        }
        else if section == 2 {
            if orderStatus == 5 || orderStatus == 9 {
                return 30 + 10
            }
            else{
               return self.calRemarkStrHeight(remark: detailOrder?.remark ?? "") + 10.0
            }
        }
        else{
             return self.calRemarkStrHeight(remark: detailOrder?.remark ?? "") + 10.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let orderStatus = selOrder?.orderStatus ?? 0
        var tipsStr = ""
        if section == 0 {
            tipsStr = "商品信息"
        }
        else if section == 1 {
             tipsStr = "订单信息"
        }
        else if section == 2 {
            if orderStatus == 5 {
                 tipsStr = "服务信息"
            }
            else{
                 tipsStr = "备注信息"
            }
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
extension OrderDetailVC {
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
