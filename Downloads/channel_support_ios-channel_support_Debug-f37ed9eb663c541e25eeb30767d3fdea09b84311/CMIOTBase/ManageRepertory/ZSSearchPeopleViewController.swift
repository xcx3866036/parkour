//
//  ZSSearchPeopleViewController.swift
//  EntranceGuardV2.0
//
//  Created by cuixin on 2017/11/1.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit
import SVProgressHUD
import DZNEmptyDataSet

class ZSSearchPeopleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    var isStartSearch: Bool = false
    var searchUsers = [UserModel]()
    var historyUsers = [UserModel]()
    
    lazy var searchView : ZSSearchView = {
        let searchView = ZSSearchView.init(frame: CGRect.init(x: 50, y: 0, width: SCREEN_WIDTH - 50 - 15, height: 34))
        searchView.backgroundColor = UIColor.clear
        searchView.searchBtn.setTitleColor(UIColor.white, for: .normal)
        searchView.searchBar.delegate = self
        searchView.searchBtn.addTarget(self, action: #selector(searchDone), for: .touchUpInside)

        return searchView
    }()
    
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(SelectUserInGroupCell.classForCoder(), forCellReuseIdentifier: "searchPeopleIdentifier")
        tabView.register(HistorySelectedUserCell.classForCoder(), forCellReuseIdentifier: "historySelectedIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.emptyDataSetSource = self
        tabView.emptyDataSetDelegate = self
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        searchView.searchBar.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGB(247, g: 247, b: 247)
        self.navigationItem.titleView = searchView
        self.configUI()
//        self.fetchSearchHistoryList()
    }
    
    //MARK: - Network
    func searchEmployeeInfoList(){
        self.noNetwork = false
        let likeName = (searchView.searchBar.text ?? "").trimmed()
        if likeName.length <= 0 {
            SVProgressHUD.showInfo(withStatus: "请输入姓名")
            return
        }
        ApiLoadingProvider.request(PAPI.searchEmployeeInfoList(likeEmployeeName: likeName), model: EmployeeInfoListModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateSearchUsersUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateSearchUsersUI(infoModel: result)
            }
        }
    }
    
    // 搜索记录
    func fetchSearchHistoryList(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.historySearchEmployeeInfoList(), model: EmployeeInfoListModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateHistorySearchUsersUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateHistorySearchUsersUI(infoModel: result)
            }
        }
    }
}

extension ZSSearchPeopleViewController {
    
    func configUI() {
    
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    func updateSearchUsersUI(infoModel:EmployeeInfoListModel?){
        if let info = infoModel{
            searchUsers = info.list ?? []
            tabView.reloadData()
        }
    }
    
    func updateHistorySearchUsersUI(infoModel:EmployeeInfoListModel?){
        if let info = infoModel{
            historyUsers = info.list ?? []
            tabView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchView.searchBar.resignFirstResponder()
    }
}

//MARK: tableViewDelegate
extension ZSSearchPeopleViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, w: SCREEN_WIDTH, h: 55))
        view.backgroundColor = UIColor.clear
        
        let bgView = UIView.init(x: 0, y: 10, w: SCREEN_WIDTH, h: 45)
        bgView.backgroundColor = UIColor.white
        view.addSubview(bgView)
        
        let lineView = UIView.init(x: 0, y: 54, w: SCREEN_WIDTH, h: 0.5)
        lineView.backgroundColor = RGB(235, g: 237, b: 243)
        if section == 1 {
            view.addSubview(lineView)
        }
        
        let label = UIFactoryGenerateLab(fontSize: 13, color: RGB(136, g: 136, b: 136), placeText: "")
        label.frame = CGRect.init(x: 15, y: 0, width: SCREEN_WIDTH - 30, height: 45)
        if self.isStartSearch {
            label.text = section == 0 ? "你可能想找" : "搜索记录"
        }
        else{
            label.text = "搜索记录"
        }
        label.text = section == 0 ? "你可能想找" : "搜索记录"
        bgView.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return searchUsers.count
        }
        else if section == 1 {
            return historyUsers.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchPeopleIdentifier", for: indexPath) as! SelectUserInGroupCell
            cell.selectionStyle = .none
            cell.markBtn.isHidden = true
            cell.configSelectUserInfo(info: searchUsers[indexPath.row], isSelected: false)
//            cell.configSelectUserName(userName: "王大锤", groupName: "产品组", isSelected: false)
             return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "historySelectedIdentifier", for: indexPath) as! HistorySelectedUserCell
            cell.dataArr = historyUsers
            cell.collectionView.reloadData()
            cell.cellClickBlock = { [unowned self] (index) in
                self.startPreIMWarehousing(section: 1, row: index)
            }
             return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        }
        
        var colums = 0
        if historyUsers.count % 2 == 0 {
            colums = historyUsers.count / 2
        }
        else{
             colums = historyUsers.count / 2 + 1
        }
        return CGFloat(colums * 60)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.startPreIMWarehousing(section: indexPath.section, row: indexPath.row)
        }
    }
}

//MARK: SearchBarDelegate
extension ZSSearchPeopleViewController {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           self.searchUser()
    }
    
    func searchUser(){
        self.isStartSearch = true
        self.searchView.searchBar.resignFirstResponder()
        self.searchEmployeeInfoList()
    }
    
    //MARK: 点击搜索按钮方法
    @objc func searchDone() {
        self.searchUser()
    }
    
    func startPreIMWarehousing(section: Int, row: Int) {
        let selectVC = SelelctPreIMWarehousingProductVC()
        if section == 0 {
           selectVC.selUser = searchUsers[row]
        }
        else{
          selectVC.selUser = historyUsers[row]
        }
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
}

extension ZSSearchPeopleViewController {
    
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
