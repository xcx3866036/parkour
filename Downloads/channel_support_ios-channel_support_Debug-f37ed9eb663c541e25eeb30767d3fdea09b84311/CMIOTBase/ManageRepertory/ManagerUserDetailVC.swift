//
//  ManagerUserDetailVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import MJRefresh

class ManagerUserDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate,NavBarTitleChangeable,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    var repType:ReperttoryType  = ReperttoryType.GroupReperttoryType
    var selDate: Date = Date()
    var selEmployee: EmployeeDimensionReturnListModel?
    var detailType: DetailType = .backType
    var backDataArr = [ReturnEmployeeDetailsListModel]()
    var outDataArr = [EmployeeDimensionOutListModel]()
    var pageNum: Int = 1
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(ManagerUserDetailCell.classForCoder(), forCellReuseIdentifier: "managerUserDetailIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var titleStr = ""
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        if detailType == .backType {
            titleStr = (selEmployee?.employeeName ?? "") + "的退还货"
        }
        else{
            titleStr = (selEmployee?.employeeName ?? "") + "的预出库"
        }
        self.title = titleStr
        //刷新
        tabView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.pageNum = 1
            self?.startFetchData(isRefresh: true)
            self?.tabView.mj_header.endRefreshing()
        })
        
        //加载
        tabView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.pageNum += 1
            self?.startFetchData(isRefresh: false)
            self?.tabView.mj_footer.endRefreshing()
        })
        self.startFetchData(isRefresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarSperateInVC(rootVC: self)
        }
    }
    
    func startFetchData(isRefresh: Bool){
        if detailType == .backType {
            self.fetchReturnEmployeeDetails(isRefresh: isRefresh)
        }
        else{
            self.fetchEmployeeDimensionOut(isRefresh: isRefresh)
        }
    }
    
    func configUI() {
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    func updateUI(infoModel:ReturnEmployeeDetailsModel?,isRefresh: Bool){
        if let info = infoModel {
            let infoList = info.list ?? [ReturnEmployeeDetailsListModel]()
            if isRefresh {
                backDataArr = infoList
                self.tabView.mj_footer.resetNoMoreData()
            }
            else{
                if infoList.count <= 0 {
                    self.tabView.mj_footer.endRefreshingWithNoMoreData()
                }
                backDataArr += infoList
            }
        }
        tabView.reloadData()
    }
    
    func updateBeforehandUI(infoModel: EmployeeDimensionOutModel?,isRefresh: Bool){
        if let info = infoModel {
            let infoList = info.list ?? [EmployeeDimensionOutListModel]()
            if isRefresh {
                outDataArr = infoList
                self.tabView.mj_footer.resetNoMoreData()
            }
            else{
                if infoList.count <= 0 {
                    self.tabView.mj_footer.endRefreshingWithNoMoreData()
                }
                outDataArr += infoList
            }
        }
        tabView.reloadData()
    }
    
    //MARK: network
    func fetchReturnEmployeeDetails(isRefresh: Bool){
        self.noNetwork = false
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        ApiLoadingProvider.request(PAPI.queryRetureEmployeeDetails(employeeId: selEmployee?.employeeId ?? 0, endDate: selEmployee?.operationDate ?? "",queryCondition:queryCondition), model: ReturnEmployeeDetailsModel.self) { (result, resultInfo) in
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
    
    func fetchEmployeeDimensionOut(isRefresh: Bool){
        self.noNetwork = false
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        ApiLoadingProvider.request(PAPI.statisticsEmployeeDimesionOut(employeeId: selEmployee?.employeeId ?? 0, operationDate: selEmployee?.operationDate ?? "",queryCondition:queryCondition), model: EmployeeDimensionOutModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateBeforehandUI(infoModel: nil,isRefresh: isRefresh)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateBeforehandUI(infoModel: result,isRefresh: isRefresh)
            }
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ManagerUserDetailVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailType == .backType {
            return backDataArr.count
        }
        else{
            return outDataArr.count
        }
//        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerUserDetailIdentifier", for: indexPath) as! ManagerUserDetailCell
        cell.selectionStyle = .none
        if detailType == .backType {
            cell.configBackDetailInfo(info: backDataArr[indexPath.row])
        }
        else{
           cell.configOutDetailInfo(info: outDataArr[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
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
}

//MARK: - NavBarTitleChangeable
extension ManagerUserDetailVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

extension ManagerUserDetailVC {
    
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
            self.startFetchData(isRefresh: true)
        }
    }
}
