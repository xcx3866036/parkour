//
//  ManagerRepertoryVC.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/10/11.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD

let kUpdateManagerRepNotification = "kUpdateManagerRepNotification"

class ManagerRepertoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource,NavBarTitleChangeable, CalendarSelectMonthNewDelegate,SelectYearAndMonthDelegate{
    
    var selDate: Date = Date()
    var needUpdate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "库存管理"
        view.backgroundColor = UIColor.white
        self.configUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotal), name: NSNotification.Name(kUpdateManagerRepNotification), object: nil)

        self.fetchStatisticsStock()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let delegate = appDelegate {
            delegate.changeNavigationBarLightContentInVC(rootVC: self)
        }
        if needUpdate {
            self.fetchStatisticsStock()
            needUpdate = false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kUpdateManagerRepNotification), object: nil)
    }
    
    func updateUI(infoModel:StockModel?){
        if let info = infoModel {
            productKindView.configInfo(imgaeName: nil, infoNoStr: String(info.totalReturn ?? 0), infoStr: "退还货数量")
            productRepAmount.configInfo(imgaeName: nil, infoNoStr: String(info.totalOut ?? 0), infoStr: "预出库数量")
        }
    }
    
    // MARK: - Function
    @objc func checkDetail(sender: UITapGestureRecognizer) {
        let detailVC = ManageChangingOrRefundingDetailVC()
        detailVC.selDate = self.selDate
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func checkBeforehandDetail(sender: UITapGestureRecognizer) {
        let detailVC = ManageChangingOrRefundingDetailVC()
        detailVC.detailType = .beforehandType
         detailVC.selDate = self.selDate
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func updateTotal(){
//        self.fetchStatisticsStock()
        needUpdate = true
    }
    
    //MARK: - Network
    func fetchStatisticsStock(){
        self.noNetwork = false
        let dateInfo = selDate.calFirstAndLastDay()
        ApiLoadingProvider.request(PAPI.statisticsStock(startDate: dateInfo.0, endDate: dateInfo.1), model: StockModel.self) { (result, resultInfo) in
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
    
    //MARK: - UI
    lazy var topBg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "rep_bg")
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    
    lazy var productKindView: OrderInfoView = {
        let infoView = OrderInfoView()
        return infoView
    }()
    
    lazy var productRepAmount: OrderInfoView = {
        let infoView = OrderInfoView()
        return infoView
    }()
    
    lazy var tabView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(), style: .plain)
        tabView.register(RepOperationCell.classForCoder(), forCellReuseIdentifier: "managerRepertoryIdentifier")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = .clear
        tabView.tableFooterView = UIView.init()
        return tabView
    }()
    
    lazy var calendarMonthView: CalendarSelectMonthDetailView = {
        let calendar = CalendarSelectMonthDetailView.init(frame: CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH, h: SCREEN_HEIGHT))
        calendar.delegate = self
        return calendar
    }()
    
    lazy var monthSwitchView: CalendarSelectMonthNewView = {
        let monthView = CalendarSelectMonthNewView.init(frame: CGRect.init(x: 0, y: kNavigationBarH + 25, w: SCREEN_WIDTH, h: 25))
        monthView.backgroundColor = UIColor.clear
        monthView.delegate = self
        return monthView
    }()
    
    func configUI() {
        view.addSubview(topBg)
        topBg.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(282)
            make.top.equalToSuperview().offset(0)
        }
        
        topBg.addSubview(monthSwitchView)
        let nowDateStr = DateFormatter.yyyyMMddFormatter.string(from: selDate)
        monthSwitchView.updateShowDateWithMonth(month: nowDateStr)
        
        let productWidth = (SCREEN_WIDTH) / 2
        productKindView.infoNoBtn.setTitleColor(RGB(255, g: 255, b: 255), for: .normal)
        productKindView.infoLab.textColor = RGB(255, g: 255, b: 255)
        topBg.addSubview(productKindView)
        productKindView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview().offset(35)
            make.height.equalTo(60)
            make.width.equalTo(productWidth)
        }
        productKindView.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "退还货数量")
        productKindView.addTapGesture(target: self, action: #selector(checkDetail(sender:)))
        
        productRepAmount.infoNoBtn.setTitleColor(RGB(255, g: 255, b: 255), for: .normal)
        productRepAmount.infoLab.textColor = RGB(255, g: 255, b: 255)
        topBg.addSubview(productRepAmount)
        productRepAmount.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(35)
            make.height.equalTo(60)
            make.width.equalTo(productWidth)
        }
        productRepAmount.configInfo(imgaeName: nil, infoNoStr: "", infoStr: "预出库数量")
        productRepAmount.addTapGesture(target: self, action: #selector(checkBeforehandDetail(sender:)))
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topBg.snp.bottom).offset(10)
        }
    }
}

//MARK: - NavBarTitleChangeable
extension ManagerRepertoryVC {
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.white, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource
extension ManagerRepertoryVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerRepertoryIdentifier", for: indexPath) as! RepOperationCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.bottomLine.isHidden = indexPath.row == 1
        cell.configManagerInfoByIndex(index: indexPath.row)
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
            let selectVC = PreIMWarehousingSelecteUserVC()
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
        else if indexPath.row == 1 {
            let scanVC = EqualExchangeProductVC()
            scanVC.inputType = .salesReturnInputType
            self.navigationController?.pushViewController(scanVC, animated: true)
        }
    }
}

//MARK: - CalendarSelectMonthNewDelegate
extension ManagerRepertoryVC {
    func didTapMonthSelect() {
        if self.calendarMonthView.superview == nil {
            let window = UIApplication.shared.keyWindow
            window?.addSubview(self.calendarMonthView)
            self.calendarMonthView.show()
        }
        else {
            self.calendarMonthView.dismiss()
        }
    }
}

//MARK: - SelectYearAndMonthDelegate
extension ManagerRepertoryVC {
    func chooseYearAndMonth(chooseYM: (String,String,Date)){
        let dateStr = DateFormatter.yyyyMMddFormatter.string(from: chooseYM.2)
        self.monthSwitchView.updateShowDateWithMonth(month: dateStr)
         selDate = chooseYM.2
        self.fetchStatisticsStock()
    }
}
