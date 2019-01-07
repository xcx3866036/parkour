//
//  OrderManagerVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/10.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import MJRefresh

let kNeedUpdateOrderListNotification = "needUpdateOrderListNotification"   // 需要更新列表

class OrderManagerItemVC: UIViewController,UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchBarDelegate {
    
    var searchMark: Int = 0         // 1: 搜索模式
    var isStartSearch: Bool = false
    
    var pageNum: Int = 1
    var orderStatus: Int = 0
    var needUpdate: Bool = false
    var dataArr = [OrderInofListItemModel]()
    
    lazy var searchView : ZSSearchView = {
        let searchView = ZSSearchView.init(frame: CGRect.init(x: 50, y: 0, width: SCREEN_WIDTH - 50 - 15, height: 34))
        searchView.backgroundColor = UIColor.clear
        searchView.searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchView.searchBar.delegate = self
        searchView.searchBar.placeholder = "商品名称/产品编码/订单号"
        searchView.searchBtn.addTarget(self, action: #selector(searchDone), for: .touchUpInside)
        
        return searchView
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(CompleteOrderCell.classForCoder(), forCellReuseIdentifier: "completeOrderCellIdentifier")
         tabView.register(InserviceOrderCell.classForCoder(), forCellReuseIdentifier: "inserviceOrderCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.noNetwork = false
        NotificationCenter.default.addObserver(self, selector: #selector(needUpdateOrderList), name: NSNotification.Name(kNeedUpdateOrderListNotification), object: nil)
        
        if searchMark == 1 {
            view.backgroundColor = RGB(247, g: 248, b: 251)
            self.navigationItem.titleView = searchView
        }
        else{
            //刷新
            tabView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                self?.pageNum = 1
                self?.fetchOrderInofList(isRefresh: true)
                self?.tabView.mj_header.endRefreshing()
            })
            
            //加载
            tabView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                self?.pageNum += 1
                self?.fetchOrderInofList(isRefresh: false)
                self?.tabView.mj_footer.endRefreshing()
            })
            
            self.fetchOrderInofList(isRefresh: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needUpdate{
            if searchMark == 0 {
                pageNum = 1
                self.fetchOrderInofList(isRefresh: true)
                needUpdate = false
            }
        }
    }
    deinit {
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kNeedUpdateOrderListNotification), object: nil)
    }
    
    func configUI() {
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            }
        }
    }
    
    func updateUI(infoModel:OrderInofListModel?,isRefresh : Bool){
        if let info = infoModel {
            let fetechedArr = info.list ?? []
            if isRefresh{
                dataArr = fetechedArr
                self.tabView.mj_footer.resetNoMoreData()
            }
            else{
                if fetechedArr.count <= 0{
                    self.tabView.mj_footer.endRefreshingWithNoMoreData()
                }
                dataArr += fetechedArr
            }
        }
          self.tabView.reloadData()
    }
    
    @objc func needUpdateOrderList() {
        needUpdate = true
    }
    
    // MARK: - function
    // Type 0:cancle  1:operate
    func orderCellClick(type: Int, status: Int, index: Int){
        if type == 0 {
            self.cancleOrderWithIndex(type: type, index: index)
        }
        else if type == 1 {
            if status == 1{
               self.startInstallWithIndex(type: type, index: index)
            }
            else if status == 2 {
                self.startInputCodeWithIndex(type: type, index: index)
            }
            else if status == 3 {
                self.startPayNowWithIndex(type: type, index: index)
            }
            else if status == 4 || status == 6 || status == 7 {
                self.startAfterSalesWithIndex(type: type, index: index)
            }
            else if status == 8 {
                self.startBuyWithIndex(type: type, index: index)
            }
        }
    }
    
    func cancleOrderWithIndex(type: Int, index: Int){
        let commitVC = CommitAddRemarkVC()
        commitVC.operateType = .cancleOrder
        commitVC.selOrder = dataArr[index]
        self.navigationController?.pushViewController(commitVC, animated: true)
    }
    
    func startInstallWithIndex(type: Int, index: Int) {
        print("扫码安装")
        let setupVC = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "SetUpViewController") as! SetUpViewController
        setupVC.currentId = dataArr[index].id ?? 0
        self.navigationController?.pushViewController(setupVC, animated: true)
    }
    
    func startInputCodeWithIndex(type: Int, index: Int) {
        print("输入验证码")
        let identifyingVC = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "IdentifyingViewController") as! IdentifyingViewController
        identifyingVC.currentId = dataArr[index].id ?? 0
        self.navigationController?.pushViewController(identifyingVC, animated: true)
    }
    
    func startAfterSalesWithIndex(type: Int, index: Int){
        print("申请售后")
        let afterSaleVC = ChooseAfterSaleTypeVC()
        afterSaleVC.selOrder = dataArr[index]
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
        payVC.currentId = dataArr[index].id ?? 0
        self.navigationController?.pushViewController(payVC, animated: true)
    }
    
    func configOrderListParams() -> [Int]{
        var params = [Int]()
        switch orderStatus {
        case 0:
            break
        case 1:
//            params = [1,2,5]
             params = [1,2]
        case 2:
            params = [3]
        case 3:
            params = [4,5,6,7,9]
        case 4:
            params = [8]
        default:
            print("order list default")
        }
        
        return params
    }

}

// MARK: - Network
extension OrderManagerItemVC {
    func fetchOrderInofList(isRefresh : Bool){
        self.noNetwork = false
        let status = configOrderListParams()
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        ApiLoadingProvider.request(PAPI.queryOrderList(inOrderStatus:status,queryCondition: queryCondition), model: OrderInofListModel.self) { (result, resultInfo) in
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
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension OrderManagerItemVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let orderInfo = dataArr[indexPath.row]
        let orderStatusCode = orderInfo.orderStatus ?? 0
        if orderStatusCode == 1 || orderStatusCode == 2 || orderStatusCode == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "inserviceOrderCellIdentifier", for: indexPath) as! InserviceOrderCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.btnClickBlock = { [unowned self] (type, index) in
                self.orderCellClick(type: type, status: orderInfo.orderStatus ?? 0,index: index)
            }
            cell.collectionClickBlock = { [unowned self] (index) in
                let detailVC = OrderDetailVC()
                detailVC.selOrder = self.dataArr[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
             cell.configOderListInfo(info: orderInfo)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "completeOrderCellIdentifier", for: indexPath) as! CompleteOrderCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.index = indexPath.row
            cell.btnClickBlock = { [unowned self] (type, index) in
                self.orderCellClick(type: type, status:orderInfo.orderStatus ?? 0,index: index)
            }
            cell.collectionClickBlock = { [unowned self] (index) in
                let detailVC = OrderDetailVC()
                detailVC.selOrder = self.dataArr[indexPath.row]
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
             cell.configOderListInfo(info: orderInfo)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let status = dataArr[indexPath.row].orderStatus ?? 0
        if status == 1 || status == 2 || status == 3{
            return 281
        }
        else {
            return 201
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = OrderDetailVC()
        detailVC.selOrder = dataArr[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: SearchBarDelegate
extension OrderManagerItemVC {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchOrder()
    }
    
    func searchOrder(){
        self.isStartSearch = true
        self.searchView.searchBar.resignFirstResponder()
//        self.searchEmployeeInfoList()
    }
    
    //MARK: 点击搜索按钮方法
    @objc func searchDone() {
        self.searchOrder()
    }
    
    func startPreIMWarehousing(section: Int, row: Int) {
        
    }
}

extension OrderManagerItemVC {
    
    func image(forEmptyDataSet scrollVie6w: UIScrollView!) -> UIImage! {
        let imageName = self.noNetwork ? "nonetwork" : "nodata"
        return UIImage.init(named: imageName)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let titleStr = self.noNetwork ? "网络出错了，请检查链接" : "暂时没有订单记录"
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
            if searchMark == 0 {
                pageNum = 1
                self.fetchOrderInofList(isRefresh: true)
            }
        }
    }
}
