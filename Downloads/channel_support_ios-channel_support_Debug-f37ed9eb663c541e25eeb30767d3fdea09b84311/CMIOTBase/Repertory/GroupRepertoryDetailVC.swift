//
//  GroupRepertoryDetailVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import MJRefresh

class GroupRepertoryDetailVC: UIViewController, UITableViewDataSource,UITableViewDelegate,NavBarTitleChangeable,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{

    var repType:ReperttoryType  = ReperttoryType.MyReperttoryType
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(GroupRepDetailTabCell.classForCoder(), forCellReuseIdentifier: "groupDetailIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    var pageNum: Int = 1
    var dataArr:[ProductDimensionStockItemModel] = [ProductDimensionStockItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = repType == .MyReperttoryType ? "我的库存详情" : "组内库存详情"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        
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
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    func startFetchData(isRefresh: Bool){
        if repType == .MyReperttoryType {
            self.fetchProductDimensionStock(isRefresh: isRefresh)
        }
        else{
            self.fetchGroupStockList(isRefresh: isRefresh)
        }
    }
    
    func configUI() {
        
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    func updateUI(infoModel:ProductDimensionStockModel?,isRefresh: Bool) {
        if let info = infoModel {
            let infoList = info.list ?? []
            if isRefresh {
                dataArr = infoList
                self.tabView.mj_footer.resetNoMoreData()
            }
            else{
                if infoList.count <= 0 {
                    self.tabView.mj_footer.endRefreshingWithNoMoreData()
                }
                dataArr += infoList
            }
        }
         self.tabView.reloadData()
    }
    
    //MARK: - function
    //MARK: NetWork
    func fetchProductDimensionStock(isRefresh: Bool){
        self.noNetwork = false
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
      ApiLoadingProvider.request(PAPI.statisticsProductDimensionStock(queryCondition:queryCondition), model: ProductDimensionStockModel.self) { (result, resultInfo) in
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
    
    //MARK: NetWork
    func fetchGroupStockList(isRefresh: Bool){
        let user = UserModel.read()
        self.noNetwork = false
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        ApiLoadingProvider.request(PAPI.statisticsGroupStockList(groupId: user?.groupId ?? 0,queryCondition:queryCondition), model: ProductDimensionStockModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateUI(infoModel: nil,isRefresh:isRefresh )
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                 self.updateUI(infoModel: result,isRefresh:isRefresh )
            }
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension GroupRepertoryDetailVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupDetailIdentifier", for: indexPath) as! GroupRepDetailTabCell
        cell.selectionStyle = .none
        cell.configGroupStaffRepInfo(type: repType, infoModel: dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if repType == .GroupReperttoryType {
            let staffVC = GroupStaffRepVC()
            staffVC.selStockGoods = dataArr[indexPath.row]
            self.navigationController?.pushViewController(staffVC, animated: true)
       }
        else if repType == .MyReperttoryType {
            let productVC = GroupStaffRepProductVC()
            productVC.repType = .MyReperttoryType
            productVC.selStockGoods = dataArr[indexPath.row]
            self.navigationController?.pushViewController(productVC, animated: true)
        }
    }
}

//MARK: - NavBarTitleChangeable
extension GroupRepertoryDetailVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

extension GroupRepertoryDetailVC {
    
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
