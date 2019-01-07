//
//  ChannelsHomeVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/25.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import SwiftyUserDefaults

let kLoginSuccessNotification = "loginSuccessNotification"
let kUpdateCurrentMonthSalesNotification = "kUpdateCurrentMonthSalesNotification"

class ChannelsHomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var needUpdate: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.configHeadUI()
        view.addSubview(self.tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headBgView.snp.bottom).offset(0)
        }
        
        if let token = Defaults[.token], token.length > 0{
            self.fetchCurrentMonthSales()
        }
        else{
           startGotoLogin(rootVC: self)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccessNotification),
                                               name: NSNotification.Name(kLoginSuccessNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCurrentMonthSales),
                                               name: NSNotification.Name(kUpdateCurrentMonthSalesNotification),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if needUpdate {
            self.fetchCurrentMonthSales()
            needUpdate = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(kLoginSuccessNotification),
                                                  object: nil)
         NotificationCenter.default.removeObserver(self,
                                                   name: NSNotification.Name(kUpdateCurrentMonthSalesNotification),
                                                   object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(infoModel:CurrentMonthSalesModel?) {
        if let info = infoModel {
            let orderCount = info.totalOrder ?? 0
            let salesCount = info.totalAmount ?? 0.0
            let salesCountStr = String.init(format: "%.2f", salesCount)
            orderNoView.configInfo(imgaeName: nil,
                                   infoNoStr: String(orderCount),
                                   infoStr: "本月订单数")
            orderAmount.configInfo(imgaeName: "home_cash",
                                   infoNoStr: salesCountStr,
                                   infoStr: "本月销售额(元)")
        }
    }
    
    func updateUserInfoUI(){
        let user = UserModel.read()
        nameLab.text = user?.employeeName
        groupLab.text = user?.groupName
    }
    
    @objc func pushMineViewController(){
        let vc = UIStoryboard(name: "Mine", bundle: nil).instantiateViewController(withIdentifier: "MineViewController") as! MineViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginSuccessNotification(){
        self.updateUserInfoUI()
        self.fetchCurrentMonthSales()
        tabView.reloadData()
    }
    
    @objc func updateCurrentMonthSales(){
        needUpdate = true
    }
    
    // MARK: - Function
    // type:1 管理员权限  0:销售权限
    func cellClickIndex(index: Int,type:Int) {
        if type == 1 {
            if index == 0 {
                print("库存管理")
                let managerVC = ManagerRepertoryVC()
                self.navigationController?.pushViewController(managerVC, animated: true)
            }
            return
        }
        switch index {
        case 0:   // 销售下单
            let vc = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "IssueViewController") as! IssueViewController
            self.navigationController?.pushViewController(vc, animated: true)
            print("销售下单")
        case 1:   // 订单管理
            print("订单管理")
            let orderVC = OrderManagerVC()
            self.navigationController?.pushViewController(orderVC, animated: true)
        case 2:   // 退换货
            print("退换货")
            let changinVC = ChangingOrRefundingVC()
            self.navigationController?.pushViewController(changinVC, animated: true)
        case 3:   // 酬金
            let vc = UIStoryboard(name: "Commission", bundle: nil).instantiateViewController(withIdentifier: "CommissionMainViewController") as! CommissionMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
            print("酬金")
        case 4:   // 库存
            let repertoryVC = ChannelRepertoryVC()
            self.navigationController?.pushViewController(repertoryVC, animated: true)
        case 5:   // 库存管理
            print("库存管理")
            let managerVC = ManagerRepertoryVC()
            self.navigationController?.pushViewController(managerVC, animated: true)
        default:
            print("Module can not find")
        }
    }
    
    //MARK: NetWork
    func fetchCurrentMonthSales(){
        self.noNetwork = false
        ApiLoadingProvider.request(PAPI.statisticsCurrentMonthSales(),
                                   model: CurrentMonthSalesModel.self) { (result, resultInfo) in
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
    
    //MARK: UI
    lazy var headBgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.clear
        return bgView
    }()
    
    lazy var nameLab: UILabel = {
        let lab = UILabel.init(x: 0, y: 0, w: 0, h: 0, fontSize: 18)
        return lab
    }()
    
    lazy var groupLab: UILabel = {
        let lab = UILabel.init(x: 0, y: 0, w: 0, h: 0, fontSize: 13)
        return lab
    }()
    
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(ProductInfoCell.classForCoder(),
                         forCellReuseIdentifier: "productInfoIdentifier")
        tabView.register(FunctionModulesCell.classForCoder(),
                         forCellReuseIdentifier: "functionModulesIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    lazy var orderNoView: OrderInfoView = {
        let view = OrderInfoView()
        return view
    }()
    
    lazy var orderAmount: OrderInfoView = {
        let view = OrderInfoView()
        return view
    }()
    
    func configHeadUI(){
        let user = UserModel.read()
        view.addSubview(self.headBgView)
        headBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(215)
        }
        
        let bgView = UIImageView()
        bgView.image = UIImage.init(named: "home_head_bg")
        headBgView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(199)
        }
        
        let headImgView = UIImageView()
        headImgView.image = UIImage.init(named: "home_head")
        headImgView.isUserInteractionEnabled = true
        let tapOne = UITapGestureRecognizer(target: self,
                                            action: #selector(pushMineViewController))
        tapOne.numberOfTapsRequired = 1
        tapOne.numberOfTouchesRequired = 1
        headImgView.addGestureRecognizer(tapOne)
        headBgView.addSubview(headImgView)
        headImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(46)
            make.width.height.equalTo(55)
            make.left.equalToSuperview().offset(15)
        }
        
        
        nameLab.text = user?.employeeName
        nameLab.textColor = RGB(255, g: 255, b: 255)
        headBgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(headImgView.snp.top).offset(6)
            make.left.equalTo(headImgView.snp.right).offset(12)
            make.right.equalToSuperview()
            make.height.equalTo(25)
        }
        
        groupLab.text = user?.groupName
        groupLab.textColor = RGB(255, g: 255, b: 255)
        headBgView.addSubview(groupLab)
        groupLab.snp.makeConstraints { (make) in
            make.left.equalTo(headImgView.snp.right).offset(12)
            make.right.equalToSuperview()
            make.top.equalTo(nameLab.snp.bottom).offset(2)
            make.height.equalTo(20)
        }
        
        let settingBtn = UIFactoryGenerateBtn(fontSize: 10,
                                              color: UIColor.white,
                                              placeText: "",
                                              imageName: "home_setting")
        settingBtn.addTarget(self,
                             action: #selector(pushMineViewController),
                             for: .touchUpInside)
        headBgView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().offset(-23)
            make.centerY.equalTo(headImgView.snp.centerY)
        }
        
        let orderBgImgView = UIImageView()
        orderBgImgView.image = UIImage.init(named: "home_white_bg2")
        headBgView.addSubview(orderBgImgView)
        orderBgImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(headImgView.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        
        let orderWidth = (SCREEN_WIDTH - 30) / 2
        orderBgImgView.addSubview(orderNoView)
        orderNoView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(orderWidth)
        }
        orderNoView.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "本月订单数")
        
        orderBgImgView.addSubview(orderAmount)
        orderAmount.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(orderWidth)
        }
        orderAmount.configInfo(imgaeName: "home_cash", infoNoStr: "", infoStr: "本月销售额(元)")
    }
}


// MARK: - UITableViewDelegate UITableViewDataSource
extension ChannelsHomeVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let productCell = tableView.dequeueReusableCell(withIdentifier: "productInfoIdentifier", for: indexPath) as! ProductInfoCell
            productCell.selectionStyle = .none
            return productCell
        }
        else {
            let functionCell = tableView.dequeueReusableCell(withIdentifier: "functionModulesIdentifier", for: indexPath) as! FunctionModulesCell
            functionCell.selectionStyle = .none
            functionCell.collectionView.reloadData()
            functionCell.cellClickBlock = { [unowned self] (index,type) in
                self.cellClickIndex(index: index,type:type)
            }
            return functionCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
           return 74
        }
        else if indexPath.section == 1 {
            let itemWidth = (SCREEN_WIDTH - 15 - 15 - 9 - 9) / 3
            return itemWidth * 2 + 10
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 54)
        
        let markView = UIView.init(x: 15, y: 30, w: 4, h: 14)
        markView.backgroundColor = RGB(45, g: 80, b: 255)
        headView.addSubview(markView)
        
        let markLab = UILabel.init(x: markView.right + 10, y: markView.top, w: 100, h: 14, fontSize: 13)
        markLab.textColor = RGB(25, g: 25, b: 25)
        markLab.font = UIFont.boldSystemFont(ofSize: 13)
        markLab.text = section == 0 ? "客户下单" : "常用功能"
        headView.addSubview(markLab)
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("产品信息")
            let vc = UIStoryboard(name: "Sale", bundle: nil).instantiateViewController(withIdentifier: "SaleMainViewController") as! SaleMainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension ChannelsHomeVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 54
        if scrollView.contentOffset.y >= 0 &&  scrollView.contentOffset.y <= sectionHeaderHeight{
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        }
        else if scrollView.contentOffset.y > sectionHeaderHeight{
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }
}

