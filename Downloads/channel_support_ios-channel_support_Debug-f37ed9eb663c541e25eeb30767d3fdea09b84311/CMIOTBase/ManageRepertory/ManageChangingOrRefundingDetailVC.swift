//
//  ManageChangingOrRefundingDetailVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import MJRefresh

enum DetailType {
    case backType
    case beforehandType
}

class ManageChangingOrRefundingDetailVC: UIViewController,UITableViewDelegate, UITableViewDataSource, CalendarSelectMonthNewDelegate,SelectYearAndMonthDelegate,NavBarTitleChangeable,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    var detailType: DetailType = .backType
    var selDate: Date = Date()
    var backDataArr = [EmployeeDimensionReturnListModel]()
    var outDataArr = [EmployeeDimensionReturnListModel]()
    var pageNum: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = detailType == .backType ? "退还货数量明细" : "预出库明细"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        //刷新
       tabView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.pageNum = 1
            if self?.detailType == .backType {
                self?.fetchStatisticsEmployeeDimensionReturn(isRefresh: true)
            }
            else{
                self?.fetchStatisticsEmployeeOut(isRefresh: true)
            }
            self?.tabView.mj_header.endRefreshing()
        })
        
        //加载
        tabView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.pageNum += 1
            if self?.detailType == .backType {
                self?.fetchStatisticsEmployeeDimensionReturn(isRefresh: false)
            }
            else{
                self?.fetchStatisticsEmployeeOut(isRefresh: false)
            }
            self?.tabView.mj_footer.endRefreshing()
        })
        
        self.startFetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarLightContentInVC(rootVC: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func updateUI(infoModel:ReturnModel?){
        if let info = infoModel {
            sumBackGoodsCoutView.configInfo(imgaeName: nil, infoNoStr: String(info.totalReturn ?? 0), infoStr: "总退换")
            badGoodsCountView.configInfo(imgaeName: nil, infoNoStr: String(info.totalBad ?? 0), infoStr: "坏货")
            self.fetchStatisticsEmployeeDimensionReturn(isRefresh: true)
        }
    }
    
    func updateBeforehandUI(infoModel: OutModel?){
        if let info = infoModel {
            beforehandView.configInfo(imgaeName: nil, infoNoStr: String(info.total ?? 0), infoStr: "总预出")
            self.fetchStatisticsEmployeeOut(isRefresh: true)
        }
    }
    
    func updateListUI(infoModel:EmployeeDimensionReturnModel?,isRefresh: Bool){
        if let info = infoModel {
            let goodsList = info.list ?? [EmployeeDimensionReturnListModel]()
            if isRefresh {
                if detailType == .backType {
                    backDataArr = goodsList
                }
                else{
                    outDataArr = goodsList
                }
                self.tabView.mj_footer.resetNoMoreData()
            }
            else{
                if goodsList.count <= 0 {
                    self.tabView.mj_footer.endRefreshingWithNoMoreData()
                }
                if detailType == .backType {
                    backDataArr += goodsList
                }
                else{
                    outDataArr += goodsList
                }
            }
        }
        tabView.reloadData()
    }
    
    // MARK: - Function
    func startFetchData(){
        if detailType == .backType {
            self.fetchStatisticsReturn()
//            self.fetchStatisticsEmployeeDimensionReturn()
        }
        else{
            self.fetchStatisticsbeforehand()
//            self.fetchStatisticsEmployeeOut()
        }
    }
    // MARK: - Network
    func fetchStatisticsReturn(){
        self.noNetwork = false
        let dateInfo = selDate.calFirstAndLastDay()
        ApiLoadingProvider.request(PAPI.statisticsReture(startDate: dateInfo.0, endDate: dateInfo.1), model: ReturnModel.self) { (result, resultInfo) in
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
    
    func fetchStatisticsbeforehand(){
        self.noNetwork = false
        let dateInfo = selDate.calFirstAndLastDay()
        ApiLoadingProvider.request(PAPI.statisticsOut(startDate: dateInfo.0, endDate: dateInfo.1), model: OutModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateBeforehandUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateBeforehandUI(infoModel: result)
            }
        }
    }
    
    func fetchStatisticsEmployeeDimensionReturn(isRefresh: Bool){
        self.noNetwork = false
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        let dateInfo = selDate.calFirstAndLastDay()
        ApiLoadingProvider.request(PAPI.statisticsEmployeeDimesionReture(startDate: dateInfo.0,
                                                                         endDate: dateInfo.1,
                                                                         queryCondition:queryCondition), model: EmployeeDimensionReturnModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateListUI(infoModel: nil,isRefresh: isRefresh)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateListUI(infoModel: result,isRefresh: isRefresh)
            }
        }
    }
    
    func fetchStatisticsEmployeeOut(isRefresh: Bool){
        self.noNetwork = false
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        let dateInfo = selDate.calFirstAndLastDay()
        ApiLoadingProvider.request(PAPI.statisticsEmployeeOut(startDate: dateInfo.0,
                                                              endDate: dateInfo.1,
                                                              queryCondition:queryCondition), model: EmployeeDimensionReturnModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateListUI(infoModel: nil,isRefresh: isRefresh)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateListUI(infoModel: result,isRefresh: isRefresh)
            }
        }
    }
    
    //MARK: - UI
    lazy var topBg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "rep_bg_1")
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(ManagerDetailCell.classForCoder(), forCellReuseIdentifier: "managerDetailCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    lazy var calendarMonthView: CalendarSelectMonthDetailView = {
        let calendar = CalendarSelectMonthDetailView.init(frame: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: SCREEN_HEIGHT))
        calendar.delegate = self
        return calendar
    }()
    
    lazy var monthSwitchView: CalendarSelectMonthNewView = {
        let monthView = CalendarSelectMonthNewView.init(frame: CGRect.init(x: 0, y: kNavigationBarH + 12, w: SCREEN_WIDTH, h: 25))
        monthView.backgroundColor = UIColor.clear
        monthView.delegate = self
        return monthView
    }()
    
    lazy var sumBackGoodsCoutView: OrderInfoView = {
        let infoView = OrderInfoView()
        return infoView
    }()
    
    lazy var badGoodsCountView: OrderInfoView = {
        let infoView = OrderInfoView()
        return infoView
    }()
    
    lazy var beforehandView: OrderInfoView = {
        let infoView = OrderInfoView()
        return infoView
    }()
    
    func configUI() {
        view.addSubview(topBg)
        topBg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(247)
        }
        
        topBg.addSubview(monthSwitchView)
        let nowDateStr = DateFormatter.yyyyMMddFormatter.string(from: selDate)
        monthSwitchView.updateShowDateWithMonth(month: nowDateStr)
        
        if detailType == .backType {
            let productWidth = (SCREEN_WIDTH) / 2
            sumBackGoodsCoutView.infoNoBtn.setTitleColor(RGB(255, g: 255, b: 255), for: .normal)
            sumBackGoodsCoutView.infoLab.textColor = RGB(255, g: 255, b: 255)
            topBg.addSubview(sumBackGoodsCoutView)
            sumBackGoodsCoutView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview().offset(35)
                make.height.equalTo(60)
                make.width.equalTo(productWidth)
            }
            sumBackGoodsCoutView.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "总退换")
            
            badGoodsCountView.infoNoBtn.setTitleColor(RGB(255, g: 255, b: 255), for: .normal)
            badGoodsCountView.infoLab.textColor = RGB(255, g: 255, b: 255)
            topBg.addSubview(badGoodsCountView)
            badGoodsCountView.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview().offset(35)
                make.height.equalTo(60)
                make.width.equalTo((productWidth))
            }
            badGoodsCountView.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "坏货")
        }
        else{
            beforehandView.infoNoBtn.setTitleColor(RGB(255, g: 255, b: 255), for: .normal)
            beforehandView.infoLab.textColor = RGB(255, g: 255, b: 255)
            topBg.addSubview(beforehandView)
            beforehandView.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview().offset(35)
                make.height.equalTo(60)
                make.width.equalTo((SCREEN_WIDTH))
            }
            beforehandView.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "总预出")
        }
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBg.snp.bottom).offset(-40)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ManageChangingOrRefundingDetailVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailType == .backType {
            return backDataArr.count
        }
        else{
            return outDataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerDetailCellIdentifier", for: indexPath) as! ManagerDetailCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if detailType == .backType {
            cell.configBackDetailInfo(info: backDataArr[indexPath.row])
        }
        else{
            cell.configOutDetailInfo(info: outDataArr[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailVC = ManagerUserDetailVC()
        userDetailVC.detailType = self.detailType
        userDetailVC.selDate = self.selDate
        if detailType == .backType {
            userDetailVC.selEmployee = backDataArr[indexPath.row]
        }
        else{
            userDetailVC.selEmployee = outDataArr[indexPath.row]
        }
        self.navigationController?.pushViewController(userDetailVC, animated: true)
    }
}

//MARK: - CalendarSelectMonthNewDelegate
extension ManageChangingOrRefundingDetailVC {
    func didTapMonthSelect() {
        if self.calendarMonthView.superview == nil {
            let window = UIApplication.shared.keyWindow
            window?.addSubview(self.calendarMonthView)
            self.calendarMonthView.show()
        }
        else {
            self.calendarMonthView.dismiss()
        }
    }
}

//MARK: - SelectYearAndMonthDelegate
extension ManageChangingOrRefundingDetailVC {
    func chooseYearAndMonth(chooseYM: (String,String,Date)){
        let dateStr = DateFormatter.yyyyMMddFormatter.string(from: chooseYM.2)
        self.monthSwitchView.updateShowDateWithMonth(month: dateStr)
        self.selDate = chooseYM.2
        self.startFetchData()
    }
}

//MARK: - NavBarTitleChangeable
extension ManageChangingOrRefundingDetailVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.white, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

extension ManageChangingOrRefundingDetailVC {
    
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
            self.startFetchData()
        }
    }
}
