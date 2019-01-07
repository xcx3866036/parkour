//
//  GroupStaffRepVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/8.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD
import MJRefresh

enum ReperttoryType {
    case MyReperttoryType
    case GroupReperttoryType
}

class GroupStaffRepVC: UIViewController, UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(GroupStaffRepDetailCell.classForCoder(), forCellReuseIdentifier: "groupStaffDetailIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    var dataArr: [GroupStockDetailsItemModel] = [GroupStockDetailsItemModel]()
    var selStockGoods: ProductDimensionStockItemModel?
    var pageNum: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "组内员工库存"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
        
        //刷新
         tabView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.pageNum = 1
            self?.fetchsGroupStockDetails(isRefresh: true)
            self?.tabView.mj_header.endRefreshing()
        })
        
        //加载
//        tabView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
//            self?.pageNum += 1
//            self?.fetchsGroupStockDetails(isRefresh: false)
//            self?.tabView.mj_footer.endRefreshing()
//        })
        
        self.fetchsGroupStockDetails(isRefresh: true)
    }

    func configUI() {
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    func updateUI(infoModel:GroupStockDetailsModel?,isRefresh: Bool){
        if let info = infoModel {
            let fetechedArr = info.list ?? []
            if isRefresh{
                dataArr = fetechedArr
//                self.tabView.mj_footer.resetNoMoreData()
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
    
    // MARK: - Function
    func callPhoneInIndex(idnex: Int) {
        print("call phone .....")
        let info = dataArr[idnex]
        let phoneStr = info.cellphone ?? ""
        if phoneStr.length > 0 {
            UIApplication.shared.openURL(URL(string: "telprompt://" + phoneStr)!)
        }
    }
    
    //MARK: - NetWork
    func fetchsGroupStockDetails(isRefresh: Bool){
        self.noNetwork = false
        let queryCondition = ["pageNum":pageNum,"pageSize":kPageSize]
        let user = UserModel.read()
        ApiLoadingProvider.request(PAPI.queryStatisticsGroupStockDetails(groupId:user?.groupId ?? 0,
                                                                         productId:selStockGoods?.productId ?? 0,
                                                                         queryCondition:queryCondition), model: GroupStockDetailsModel.self) { (result, resultInfo) in
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
extension GroupStaffRepVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupStaffDetailIdentifier", for: indexPath) as! GroupStaffRepDetailCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.configGroupStaffRep(infoModel: self.dataArr[indexPath.row], index: indexPath.row)
//        cell.configGroupStaffRepInfo(count: indexPath.row, index: indexPath.row, phoneStr: "15884592964")
        cell.rightView.isHidden = true
        cell.cellClickBlock = { [unowned self] (index) in
            self.callPhoneInIndex(idnex: index)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let staffProductVC = GroupStaffRepProductVC()
//        staffProductVC.selUser = dataArr![indexPath.row]
//        self.navigationController?.pushViewController(staffProductVC, animated: true)
    }
}

extension GroupStaffRepVC {
    
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
           self.fetchsGroupStockDetails(isRefresh: true)
        }
    }
}
