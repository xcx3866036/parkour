//
//  RepertoryDetailVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class RepertoryDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NavBarTitleChangeable {

    lazy var mainTabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(RepMainDetailTabCell.classForCoder(), forCellReuseIdentifier: "mainDetailIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    lazy var subTabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(RepSubDetailTabCell.classForCoder(), forCellReuseIdentifier: "subDetailIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = RGB(247, g: 248, b: 251)
        return tabView
    }()
    
    var mainDataArr = [("售出",3,[ProductStockDetailsItemModel](),false),
                       ("预出库",2,[ProductStockDetailsItemModel](),false),
                       ("退还库房",6,[ProductStockDetailsItemModel](),false),
                       ("换货换出",7,[ProductStockDetailsItemModel](),false),
                       ("换货退回",4,[ProductStockDetailsItemModel](),false),
                       ("退货退回",5,[ProductStockDetailsItemModel](),false),
                       ("平级换出",8,[ProductStockDetailsItemModel](),false),
                       ("平级换入",9,[ProductStockDetailsItemModel](),false)]
    
    var subDataArr = [ProductStockDetailsModel]()
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的库存明细"
        self.view.backgroundColor = UIColor.white
        self.configUI()
        self.fetchStockDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarSperateInVC(rootVC: self)
        }
    }
    
    func configUI() {
  
        view.addSubview(mainTabView)
        mainTabView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(85)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
        
        view.addSubview(subTabView)
        subTabView.snp.makeConstraints { (make) in
            make.left.equalTo(mainTabView.snp.right)
            make.top.right.equalToSuperview()
            make.bottom.equalTo(mainTabView.snp.bottom)
        }
    }
    
    //MARK: - function
    func updateUI(infoModel:ProductStockDetailsModel?){
//        var products = [ProductStockDetailsItemModel]()
        if let info = infoModel {
            let products = info.list ?? []
            mainDataArr[selectedIndex].2 = products
            mainDataArr[selectedIndex].3 = true
        }
        subTabView.reloadData()
    }
    //MARK: NetWork
    func fetchStockDetails(){
        self.noNetwork = false
        let status = mainDataArr[selectedIndex].1
        ApiLoadingProvider.request(PAPI.queryStockDetails(productId: -1, goodsStatus: status), model: ProductStockDetailsModel.self) { (result, resultInfo) in
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
}

//MARK: - NavBarTitleChangeable
extension RepertoryDetailVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.black, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension RepertoryDetailVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTabView {
            return mainDataArr.count
        }
        else if tableView == subTabView {
            let products = mainDataArr[selectedIndex].2
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTabView {
            let mainCell = tableView.dequeueReusableCell(withIdentifier: "mainDetailIdentifier", for: indexPath) as! RepMainDetailTabCell
            let isSelected = indexPath.row == selectedIndex ? true : false
            if indexPath.row == selectedIndex {
                mainCell.backgroundColor = RGB(247, g: 248, b: 251)
            }
            else{
                mainCell.backgroundColor = RGB(255, g: 255, b: 255)
            }
            mainCell.configInfo(title: mainDataArr[indexPath.row].0, isSelected: isSelected)
            return mainCell
        }
        else if tableView == subTabView {
            let subCell = tableView.dequeueReusableCell(withIdentifier: "subDetailIdentifier", for: indexPath) as! RepSubDetailTabCell
            subCell.configRepetoryDetailInfo(info: mainDataArr[selectedIndex].2[indexPath.row])
            subCell.selectionStyle = .none
            return subCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mainTabView {
            return 66
        }
        else if tableView == subTabView {
            return 70
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
        if tableView == mainTabView{
            if selectedIndex == indexPath.row {
                mainTabView.reloadData()
                return
            }
            selectedIndex = indexPath.row
            mainTabView.reloadData()
            if mainDataArr[selectedIndex].3{
                subTabView.reloadData()
            }
            else{
               self.fetchStockDetails()
            }
        }
    }
}
