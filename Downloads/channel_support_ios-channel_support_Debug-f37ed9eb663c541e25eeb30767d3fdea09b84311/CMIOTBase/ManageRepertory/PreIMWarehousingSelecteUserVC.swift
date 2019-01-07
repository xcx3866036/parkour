//
//  PreIMWarehousingSelecteUserVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/15.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class PreIMWarehousingSelecteUserVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NavBarTitleChangeable {
    
    var mainDataArr = [EmployeeGroupModel]()
    var subDataArr = [UserModel]()
    var selectedIndex: Int = 0
    var subSelectedIndex: Int = -1
    var dataArr = [(EmployeeGroupModel,[UserModel])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择员工"
        self.view.backgroundColor = RGB(247, g: 248, b: 251)
        
        let serachBarButton = UIBarButtonItem.init(image: UIImage.init(named: "black_search"), style: .plain, target: self, action: #selector(searchBtnClick(sender:)))
        self.navigationItem.rightBarButtonItem = serachBarButton
        
        self.configUI()
        self.fetchEmployeeGroupList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarDefaultInVC(rootVC: self)
        }
    }
    
    
    func updateGroupTypeUI(infoModel:EmployeeGroupListModel?){
        if let info = infoModel {
            mainDataArr = info.list ?? []
        }
        for (_,groupInfo) in mainDataArr.enumerated() {
            dataArr.append((groupInfo,[UserModel]()))
        }
        if mainDataArr.count > 0 {
            self.fetchEmployeeInfoList()
        }
        mainTabView.reloadData()
    }
    
    func updateGroupUserUI(infoModel:EmployeeInfoListModel?){
        if let info = infoModel {
            subDataArr = info.list ?? []
        }
        dataArr[selectedIndex].1 = subDataArr
        subTabView.reloadData()
    }
    
    //MARK: - function
    @objc func commitBtnClick(sender: UIButton) {
        if subSelectedIndex < 0 {
            SVProgressHUD.showInfo(withStatus: "请先选择员工！")
            return
        }
        let user = dataArr[selectedIndex].1[subSelectedIndex]
        let selectVC = SelelctPreIMWarehousingProductVC()
        selectVC.selUser = user
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
    @objc func searchBtnClick(sender: UIButton) {
        let searchVC = ZSSearchPeopleViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: - Network
    func fetchEmployeeGroupList(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.queryEmployeeGroupList(inIds: [], likeGroupName: ""), model: EmployeeGroupListModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateGroupTypeUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateGroupTypeUI(infoModel: result)
            }
        }
    }
    
    func fetchEmployeeInfoList(){
        self.noNetwork = false
        let group = dataArr[selectedIndex].0
        ApiLoadingProvider.request(PAPI.queryEmployeeInfoList(groupId: group.id ?? 0), model: EmployeeInfoListModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.noNetwork = codeError.code == 2
                self.updateGroupUserUI(infoModel: nil)
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateGroupUserUI(infoModel: result)
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
        stepIndicatorView.stepMarks = ["选择员工","添加预出库产品"]
        stepIndicatorView.direction = .customCenter
        stepIndicatorView.numberOfSteps = 2
        stepIndicatorView.currentStep = 0
        stepIndicatorView.stepWith = 100.0
        stepIndicatorView.frame = CGRect(x: 15, y: 0, width: SCREEN_WIDTH - 15 - 15, height: 87)
        stepIndicatorView.backgroundColor = UIColor.clear
        return stepIndicatorView
    }()
    
    lazy var commitBtn: UIButton = {
        let btn = UIFactoryGenerateBtn(fontSize: 18, color: RGB(255, g: 255, b: 255), placeText: "下一步",imageName:"")
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(commitBtnClick(sender:)), for: .touchUpInside)
        btn.backgroundColor = RGB(25, g: 81, b: 255)
        btn.setCornerRadius(radius: 6)
        btn.addAttTitle(mainTitle: "下一步", subTitle: "（选择产品）")
        return btn
    }()
    
    lazy var mainTabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(SelectGroupsCell.classForCoder(), forCellReuseIdentifier: "selectGroupsCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = RGB(247, g: 248, b: 251)
        return tabView
    }()
    lazy var subTabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(SelectUserInGroupCell.classForCoder(), forCellReuseIdentifier: "selectUserInGroupCellIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = UIColor.white
        return tabView
    }()
    
    func configUI() {
        
        self.view.addSubview(stepBgView)
        stepBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(87)
        }
//        stepBgView.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 87))
        stepBgView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "step_pre_bg")!)
        stepBgView.addSubview(stepIndicatorView)
        
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            }
        }
//        commitBtn.addGradientLayerWithColors(bounds: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 30, h: 45))
        commitBtn.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "btn_bg")!)
        
        view.addSubview(mainTabView)
        mainTabView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(87)
            make.width.equalTo(115)
            make.bottom.equalTo(commitBtn.snp.top).offset(-32)
        }
        
        view.addSubview(subTabView)
        subTabView.snp.makeConstraints { (make) in
            make.left.equalTo(mainTabView.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(mainTabView.snp.top)
            make.bottom.equalTo(mainTabView.snp.bottom)
        }
    }
}

//MARK: - NavBarTitleChangeable
extension PreIMWarehousingSelecteUserVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension PreIMWarehousingSelecteUserVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTabView {
            return dataArr.count
        }
        else if tableView == subTabView {
            if dataArr.count > 0 {
                return dataArr[selectedIndex].1.count
            }
            else{
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTabView {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "selectGroupsCellIdentifier", for: indexPath) as! SelectGroupsCell
            mainCell.selectionStyle = .none
            mainCell.topLine.isHidden = indexPath.row != 0
            mainCell.bottomLine.isHidden = indexPath.row != mainDataArr.count - 1
            mainCell.configGroupListInfo(info: dataArr[indexPath.row].0)
            if indexPath.row == selectedIndex {
               mainCell.backgroundColor = RGB(255, g: 255, b: 255)
            }
            else{
                mainCell.backgroundColor = RGB(247, g: 248, b: 251)
            }
            return mainCell
        }
        else if tableView == subTabView {
            let subCell = tableView.dequeueReusableCell(withIdentifier: "selectUserInGroupCellIdentifier", for: indexPath) as! SelectUserInGroupCell
            let isSelected = indexPath.row == subSelectedIndex ? true : false
            subCell.selectionStyle = .none
            subCell.topLine.isHidden = true
            subCell.configSelectUserInfo(info: dataArr[selectedIndex].1[indexPath.row],isSelected: isSelected)
            return subCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mainTabView {
            let groupInfo = dataArr[indexPath.row].0
            let groupName = groupInfo.groupName ?? ""
            let calHeight = groupName.height(115 - 8, font: UIFont.systemFont(ofSize: 15), lineBreakMode: nil)
            let height = calHeight <= 21 ? 21 : calHeight
            return CGFloat(40 + height)
        }
        else if tableView == subTabView {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mainTabView {
            if indexPath.row == selectedIndex {
                return
            }
            selectedIndex = indexPath.row
            subSelectedIndex = -1
            mainTabView.reloadData()
            let users = dataArr[selectedIndex].1
            if users.count > 0 {
                subTabView.reloadData()
            }
            else{
                self.fetchEmployeeInfoList()
            }
        }
        else if tableView == subTabView {
            if indexPath.row == subSelectedIndex {
                return
            }
            subSelectedIndex = indexPath.row
            subTabView.reloadData()
        }
    }
}
