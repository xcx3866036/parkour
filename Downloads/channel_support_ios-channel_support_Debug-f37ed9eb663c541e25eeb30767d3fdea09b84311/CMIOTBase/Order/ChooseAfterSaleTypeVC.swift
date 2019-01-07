//
//  ChooseAfterSaleTypeVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/16.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChooseAfterSaleTypeVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var selOrder: OrderInofListItemModel?
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(AfterSaleTypeCell.classForCoder(), forCellReuseIdentifier: "chooseAfterSaleTypeIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择售后类型"
        view.backgroundColor = RGB(247, g: 248, b: 251)
        self.configUI()
    }
    
    
    func configUI() {
        self.view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        let footView = UIView.init(x: 0, y: 0, w: SCREEN_WIDTH, h: 90)
        footView.backgroundColor = UIColor.clear
        
        let markLab = UIFactoryGenerateLab(fontSize: 14, color: RGB(255, g: 127, b: 16), placeText: "注意：")
        markLab.frame = CGRect.init(x: 15, y: 25, w: 100, h: 20)
        footView.addSubview(markLab)
        
        let tipLab = UIFactoryGenerateLab(fontSize: 12, color: RGB(129, g: 129, b: 129), placeText: "")
        tipLab.frame = CGRect.init(x: 15, y: markLab.bottom, w: SCREEN_WIDTH - 15, h: 40)
        tipLab.numberOfLines = 2
        tipLab.text = "1、换货可单选产品\n2、退货仅支持订单整体退货，即全部产品退货"
        footView.addSubview(tipLab)
        tabView.tableFooterView = footView
    }
    
    //MARK: Network
   
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ChooseAfterSaleTypeVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseAfterSaleTypeIdentifier", for: indexPath) as! AfterSaleTypeCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        let goodsDays = indexPath.row == 0 ? selOrder?.exchangeGoodsDays ?? 0 : selOrder?.returnGoodsDays ?? 0
        cell.configInfoByIndex(index: indexPath.row,goodsDays:goodsDays)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            let productVC = ChooseChangedProductVC()
//            self.navigationController?.pushViewController(productVC, animated: true)
            if (selOrder?.isExchangeable ?? 0) == 0 {
                SVProgressHUD.showInfo(withStatus: "抱歉！订单产品已超过保换货时间")
                return
            }
            let commitVC = CommitAddRemarkVC()
            commitVC.operateType = .applyForExchangingGoods
            commitVC.selOrder = self.selOrder
            commitVC.afterSaleType = 1
            self.navigationController?.pushViewController(commitVC, animated: true)
        }
        else if indexPath.row == 1 {
            if (selOrder?.isReturnable ?? 0) == 0 {
                SVProgressHUD.showInfo(withStatus: "抱歉！订单产品已超过退货时间")
                return
            }
            let commitVC = CommitAddRemarkVC()
            commitVC.operateType = .applyForReturningGoods
            commitVC.selOrder = self.selOrder
            commitVC.afterSaleType = 2
            self.navigationController?.pushViewController(commitVC, animated: true)
            
        }
    }
}

