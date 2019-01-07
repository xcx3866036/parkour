//
//  ChangingOrRefundingVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import MJRefresh

let kNeedUpdateAfterSalesListNotification = "kNeedUpdateAfterSalesListNotification"   //

class ChangingOrRefundingItemVC: UIViewController,UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    
    var pageNum: Int = 1
    var changingOrRefundingStatus: Int = 0
    var needUpdate: Bool = false
    var dataArr = [AfterSaleServiceInfofListItemModel]()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(CompleteRefundingCell.classForCoder(),
                         forCellReuseIdentifier: "completeChangingOrRefundingIdentifier")
        tabView.register(InserviceRefundingCell.classForCoder(),
                         forCellReuseIdentifier: "inserviceRefundingIdentifier")
        tabView.register(InServiceChangeCell.classForCoder(),
                         forCellReuseIdentifier: "inserviceChangeIdentifier")
        tabView.register(InserviceChangingCell.classForCoder(),
                         forCellReuseIdentifier: "inserviceChangingIdentifier")
        
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

         NotificationCenter.default.addObserver(self, selector: #selector(needUpdateOrderList), name: NSNotification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
        
        //刷新
        tabView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.pageNum = 1
            self?.fetchAfterSaleServiceInfofList(isRefresh: true)
            self?.tabView.mj_header.endRefreshing()
        })
        
        //加载
        tabView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.pageNum += 1
            self?.fetchAfterSaleServiceInfofList(isRefresh: false)
            self?.tabView.mj_footer.endRefreshing()
        })
        self.fetchAfterSaleServiceInfofList(isRefresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needUpdate{
            pageNum = 1
            self.fetchAfterSaleServiceInfofList(isRefresh: true)
            needUpdate = false
        }
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kNeedUpdateAfterSalesListNotification), object: nil)
    }
    
    @objc func needUpdateOrderList() {
        needUpdate = true
    }
    
    func configUI() {
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    func updateUI(infoModel: AfterSaleServiceInfofListModel?,isRefresh : Bool){
        if let info = infoModel{
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
         tabView.reloadData()
    }
    
    func listCancleAfterSale(index: Int){
        
    }
    
    func configListParams() -> [Int] {
        var params = [Int]()
        if changingOrRefundingStatus == 0 {}
        else if changingOrRefundingStatus == 1 {
            params = [1,2,5,6,7]
        }
        else if changingOrRefundingStatus == 2 {
            params = [3,8]
        }
        else if changingOrRefundingStatus == 3 {
            params = [4,9,10]
        }
        return params
    }
    
    //MARK: -
    func cellClickCallBackIndex(type: Int, index: Int){
        let dealStatus = dataArr[index].dealStatus ?? 0
        if type == 0 {
            self.cancleAfterSalesWithIndex(type: type, index: index)
        }
        else{
            if dealStatus == 1{
                 self.startToRecyleWithIndex(type: type, index: index,recyleType: .forRecycle)
            }
            if dealStatus == 2 {
                 self.startToReNewWithIndex(type: type, index: index)
            }
            else if dealStatus == 5  {
               self.startToCheckWithIndex(type: type, index: index)
            }
            else if dealStatus == 6 {
               self.startToRecyleWithIndex(type: type, index: index,recyleType: .forReturn)
            }
            else if dealStatus == 7 {
                self.startToRefundWithIndex(type: type, index: index)
            }
        }
    }

    func cancleAfterSalesWithIndex(type: Int, index: Int){
        let commitVC = CommitAddRemarkVC()
        commitVC.operateType = .cancleAfterSales
        commitVC.selChangingOrRefundingItem = dataArr[index]
        self.navigationController?.pushViewController(commitVC, animated: true)
    }
    
    func startToRecyleWithIndex(type: Int, index: Int, recyleType: RecycleType){
        //扫码回收
        let recyleVC = ScanRecycleVC()
        recyleVC.type = recyleType
        recyleVC.selChangingOrRefundingItem = dataArr[index]
        self.navigationController?.pushViewController(recyleVC, animated: true)
    }
    
    func startToReNewWithIndex(type: Int, index: Int){
        //扫码换新
        let renewVC = ScanRenewVC()
        renewVC.selChangingOrRefundingItem = dataArr[index]
        self.navigationController?.pushViewController(renewVC, animated: true)
    }
    
    func startToRefundWithIndex(type: Int, index: Int){
        //退款详情
        let completeCheckVC = CompleteCheckBackGoodsVC()
        self.navigationController?.pushViewController(completeCheckVC, animated: true)
    }
    
    func startToCheckWithIndex(type: Int, index: Int){
        //退货检查
        let checkVC = CheckBackGoodsVC()
        checkVC.selChangingOrRefundingItem = dataArr[index]
        self.navigationController?.pushViewController(checkVC, animated: true)
    }
    
//    func startToBackRecyleWithIndex(type: Int, index: Int){
//        //退货回收
//        let recyleVC = ScanRecycleVC()
//        recyleVC.type = .forReturn
//        recyleVC.selChangingOrRefundingItem = dataArr[index]
//        self.navigationController?.pushViewController(recyleVC, animated: true)
//    }
}

// MARK: - Network
extension ChangingOrRefundingItemVC{
    func fetchAfterSaleServiceInfofList(isRefresh : Bool){
        self.noNetwork = false
        let params = self.configListParams()
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        ApiLoadingProvider.request(PAPI.queryAfterSaleServiceInfoList(dealStatus: params,queryCondition: queryCondition), model: AfterSaleServiceInfofListModel.self) { (result, resultInfo) in
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
extension ChangingOrRefundingItemVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dealStatus = dataArr[indexPath.row].dealStatus ?? 0
        if dealStatus == 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inserviceChangeIdentifier", for: indexPath) as! InServiceChangeCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.btnClickBlock = { [unowned self] (type, index) in
                self.cellClickCallBackIndex(type: type, index: index)
            }
            cell.configServiceChangeInfo(infoModel:dataArr[indexPath.row])
            return cell
        }
        else if dealStatus == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inserviceChangingIdentifier", for: indexPath) as! InserviceChangingCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.btnClickBlock = { [unowned self] (type, index) in
                self.cellClickCallBackIndex(type: type, index: index)
            }
             cell.configServiceChangeInfo(infoModel:dataArr[indexPath.row])
            return cell
        }
        else if dealStatus == 5 || dealStatus == 6 || dealStatus == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inserviceRefundingIdentifier", for: indexPath) as! InserviceRefundingCell
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.btnClickBlock = { [unowned self] (type, index) in
                self.cellClickCallBackIndex(type: type, index: index)
            }
            cell.configServiceChangeInfo(infoModel:dataArr[indexPath.row])
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "completeChangingOrRefundingIdentifier", for: indexPath) as! CompleteRefundingCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.configServiceChangeInfo(infoModel:dataArr[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dealStatus = dataArr[indexPath.row].dealStatus ?? 0
        if dealStatus == 1{
            return 262
        }
        else if dealStatus == 2{
            return 262
        }
        else if dealStatus == 5 || dealStatus == 6 || dealStatus == 7{
            return 242
        }
        else {
            return 130
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
        let detailVC = ChangingOrRefundingDetailVC()
        detailVC.selChangingOrRefundingItem = dataArr[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ChangingOrRefundingItemVC {
    
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
            pageNum = 1
           self.fetchAfterSaleServiceInfofList(isRefresh: true)
        }
    }
}
