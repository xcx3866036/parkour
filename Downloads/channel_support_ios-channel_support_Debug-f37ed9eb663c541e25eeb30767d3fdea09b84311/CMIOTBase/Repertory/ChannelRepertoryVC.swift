//
//  ChannelRepertoryVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
let kUpdateRepNotification = "kUpdateRepNotification"

class ChannelRepertoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource,NavBarTitleChangeable {
    
    var needUpdate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的库存"
        view.backgroundColor = UIColor.white
        
        let detailBar = UIBarButtonItem.init(title: "明细", style: .plain, target: self, action: #selector(ChannelRepertoryVC.checkDetailRepertory(sender:)))
//        self.navigationItem.rightBarButtonItem = detailBar
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotal), name: NSNotification.Name(kUpdateRepNotification), object: nil)
        self.configUI()
        self.fetchPersonalStock()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarLightContentInVC(rootVC: self)
        }
        if needUpdate {
            self.fetchPersonalStock()
            needUpdate = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kUpdateRepNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func updateUI(infoModel:RefundPersonalStockModel?){
        if let info = infoModel {
            let typeCount = info.typeCount ?? 0
            let totalCount = info.totalCount ?? 0
            productKindView.configInfo(imgaeName: nil, infoNoStr: String(typeCount), infoStr: "在库产品种类")
            productRepAmount.configInfo(imgaeName: nil, infoNoStr: String(totalCount), infoStr: "在库产品数量")
        }
    }
    
    // MARK: - Function
    @objc func checkDetailRepertory(sender: UIBarButtonItem) {
        let detailVC = RepertoryDetailVC()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func checkMyRepertoryDetial(sender: UITapGestureRecognizer) {
        let groupVC = GroupRepertoryDetailVC()
        groupVC.repType = .MyReperttoryType
        self.navigationController?.pushViewController(groupVC, animated: true)
    }
    
    @objc func updateTotal(){
        needUpdate = true
    }
    
    //MARK: NetWork
    func fetchPersonalStock(){
        ApiLoadingProvider.request(PAPI.statisticsPersonalStock(), model: RefundPersonalStockModel.self) { (result, resultInfo) in
            if let codeError = resultInfo.2 {
                self.updateUI(infoModel: nil)
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.updateUI(infoModel: result)
            }
        }
    }
    
    //MARK: - UI
    lazy var topBg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "rep_bg")
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(RepOperationCell.classForCoder(), forCellReuseIdentifier: "repertoryIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    lazy var productKindView:OrderInfoView = {
        let view = OrderInfoView()
        return view
    }()
    
    lazy var productRepAmount:OrderInfoView = {
        let view = OrderInfoView()
        return view
    }()
    
    func configUI() {
        view.addSubview(topBg)
        topBg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(282)
        }
        
        let productWidth = (SCREEN_WIDTH) / 2
        productKindView.infoNoBtn.setTitleColor(RGB(255, g: 255, b: 255), for: .normal)
        productKindView.infoLab.textColor = RGB(255, g: 255, b: 255)
        topBg.addSubview(productKindView)
        productKindView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(productWidth)
        }
        productKindView.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "在库产品种类")
        productKindView.addTapGesture(target: self, action: #selector(ChannelRepertoryVC.checkMyRepertoryDetial(sender:)))
        
        productRepAmount.infoNoBtn.setTitleColor(RGB(255, g: 255, b: 255), for: .normal)
        productRepAmount.infoLab.textColor = RGB(255, g: 255, b: 255)
        topBg.addSubview(productRepAmount)
        productRepAmount.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(productWidth)
        }
        productRepAmount.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "在库产品数量")
        productRepAmount.addTapGesture(target: self, action: #selector(ChannelRepertoryVC.checkMyRepertoryDetial(sender:)))
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topBg.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}

//MARK: - NavBarTitleChangeable
extension ChannelRepertoryVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.white, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ChannelRepertoryVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repertoryIdentifier", for: indexPath) as! RepOperationCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.bottomLine.isHidden = indexPath.row == 2
        cell.configInfoByIndex(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
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
            let productVC = RepProductInfoVC()
            self.navigationController?.pushViewController(productVC, animated: true)
        }
        else if indexPath.row == 1 {
            let groupVC = GroupRepertoryDetailVC()
            groupVC.repType = .GroupReperttoryType
            self.navigationController?.pushViewController(groupVC, animated: true)
        }
        else if indexPath.row == 2 {
            let exchangeVC = EqualExchangeProductVC()
            self.navigationController?.pushViewController(exchangeVC, animated: true)
        }
    }
}

//MARK: - UINavigationControllerDelegate
extension ChannelRepertoryVC {
   
}
