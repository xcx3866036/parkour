//
//  CommissionMainViewController.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class CommissionMainViewController: UIViewController,CalendarSelectMonthNewDelegate,SelectYearAndMonthDelegate {

    @IBOutlet weak var commissionTab: UITableView!
    @IBOutlet weak var midView: UIView!
    var completeLabel:UILabel?
    var dataArr:[CommissionMonthModel] = []
    var model:CommissionDetailsModel?
    var currentClick:Int = 0
    var type:String = "0"
    lazy var topBg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "bg3")
        imgView.isUserInteractionEnabled = true
        imgView.layer.cornerRadius = 5
        return imgView
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoCommissionDetailViewController" {
            let vc:CommissionDetailViewController = segue.destination as! CommissionDetailViewController
            vc.model = dataArr[currentClick]
            vc.flag = self.type
            if(self.type == "1"){
                vc.typePrice = (model?.settledAmount)!
            }else if(self.type == "2"){
                vc.typePrice = (model?.settlementAmount)!
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的佣金"
        self.view.backgroundColor = kBackgroundColor
        reloadData()
        loadMonthData(date: "")
    }
    func loadMonthData(date:String){
        ApiLoadingProvider.request(PAPI.statisticsHistoryMonth(settlementYear: date), model: CommissionMonthListModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.dataArr = (result?.list)!
                self.commissionTab.reloadData()
            }
        }
    }
    
    func reloadData(){
        ApiLoadingProvider.request(PAPI.statisticsCurrentMonth(), model: CommissionDetailsModel.self) { (result, info) in
            if let codeError = info.2 {
                self.noNetwork = codeError.code == 2
                SVProgressHUD.showError(withStatus: codeError.localizedDescription)
            }
            else{
                self.model = result
                self.setUI()
            }
        }
    }

    
    func goDetail(){
        self.performSegue(withIdentifier: "GoCommissionDetailViewController", sender: nil)
    }
    
    func setUI() {
        
        let rb:UIView = UIView()
        
        view.addSubview(rb)
        rb.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(304)
        }
        
        rb.addSubview(topBg)
        topBg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(234)
        }
        
        topBg.addSubview(monthSwitchView)
        let nowDateStr = DateFormatter.yyyyMMddFormatter.string(from: Date())
        monthSwitchView.updateShowDateWithYear(month: nowDateStr)
        
        let bottom = UIView()
        bottom.backgroundColor = UIColor.white
        topBg.addSubview(bottom)
        
        bottom.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        bottom.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        let topLabel = UILabel()
        topLabel.font = UIFont.systemFont(ofSize: 13)
        topLabel.textColor = UIColor.colorWithHexString(hex: "#7D7D7D")
        topLabel.text = "本月已结算"
        bottom.addSubview(topLabel)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickMonth))
        bottom.addGestureRecognizer(gesture)
        
        
        topLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(19)
            make.width.equalTo(70)
        }
        
        
        let moneyFlag = UILabel()
        moneyFlag.font = UIFont.systemFont(ofSize: 14)
        moneyFlag.textColor = UIColor.colorWithHexString(hex: "#1A45FF")
        moneyFlag.text = String(format: "￥", (model?.settledAmount)!)
        bottom.addSubview(moneyFlag)
        
        moneyFlag.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(32)
        }
        
        
        completeLabel = UILabel()
        completeLabel?.font = UIFont.systemFont(ofSize: 27)
        completeLabel?.textColor = UIColor.colorWithHexString(hex: "#1A45FF")
        completeLabel?.text = String(format: "%.2f", (model?.settledAmount)!)
        bottom.addSubview(completeLabel!)
        
        completeLabel?.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(32)
        }
        
        let rightImage = UIImageView()
        rightImage.image = UIImage(named: "group_rep_right")
        bottom.addSubview(rightImage)
        
        rightImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-19)
            make.height.equalTo(13)
            make.width.equalTo(6)
        }
        
        
        let bottom1 = UIView()
        bottom1.backgroundColor = UIColor.white
        bottom1.isUserInteractionEnabled = true
        rb.addSubview(bottom1)
        
        bottom1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(70)
        }
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(clickMonth1))
        bottom1.addGestureRecognizer(gesture1)
        
        
        let topLabel1 = UILabel()
        topLabel.isUserInteractionEnabled = true
        topLabel1.font = UIFont.systemFont(ofSize: 13)
        topLabel1.textColor = UIColor.colorWithHexString(hex: "#7D7D7D")
        topLabel1.text = "结算中"
        bottom1.addSubview(topLabel1)
        
        topLabel1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(19)
            make.width.equalTo(70)
        }
        
        let topLabel2 = UILabel()
        topLabel2.font = UIFont.boldSystemFont(ofSize: 18)
        topLabel2.textColor = UIColor.colorWithHexString(hex: "#1D1D1D")
        topLabel2.text = String(format: "%.2f", (model?.settlementAmount)!)
        bottom1.addSubview(topLabel2)
        
        topLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel1.snp.bottom).offset(1)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(21)
        }
        
        let topLabel3 = UILabel()
        topLabel3.font = UIFont.systemFont(ofSize: 13)
        topLabel3.textColor = UIColor.colorWithHexString(hex: "#7D7D7D")
        topLabel3.text = "已支付的订单，7日后结算"
        bottom1.addSubview(topLabel3)
        
        topLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel2.snp.bottom).offset(1)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(19)
        }
        
        let rightImage1 = UIImageView()
        rightImage1.image = UIImage(named: "group_rep_right")
        bottom1.addSubview(rightImage1)
        
        rightImage1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-19)
            make.height.equalTo(13)
            make.width.equalTo(6)
        }
        
    }
    @objc func clickMonth(){
        self.type = "1"
        self.goDetail()
    }
    
    @objc func clickMonth1(){
        self.type = "2"
        self.goDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.navigationBar.isTranslucent = false
        
    }

}

extension CommissionMainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommissionTableViewCell" ) as! CommissionTableViewCell
        if dataArr[indexPath.row].settlementMonth.length == 1 {
            dataArr[indexPath.row].settlementMonth = String(format: "0%@", dataArr[indexPath.row].settlementMonth)
        }
        cell.leftDate.text = dataArr[indexPath.row].settlementMonth
        cell.rightDate.text = String(dataArr[indexPath.row].effectiveSingular ?? 0)
        cell.priceLabel.text = String(format: "%.2f", dataArr[indexPath.row].commissionIncome!)
        cell.numLabel.text = String(format: "/%d单", dataArr[indexPath.row].totalSingular!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.type = "0"
        self.currentClick = indexPath.row
        self.goDetail()
    }
    
    
}


extension CommissionMainViewController:NavBarTitleChangeable{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        appDelegate!.changeNavigationBarLightContentInVC(rootVC: self)
        
        
    }
    
    var preferredTextAttributes: [NSAttributedStringKey : AnyObject] {
        let item = FunNavTitleTextAttributesItem(color: UIColor.white, font:nil)
        return getNavgationBarTitleTextAttributes(with: item)
    }
    
    
}


//MARK: - CalendarSelectMonthNewDelegate
extension CommissionMainViewController {
    func didTapMonthSelect() {
        let datePicker = YLDatePicker(currentDate: nil, minLimitDate: Date(), maxLimitDate: nil, datePickerType: .Y) { [weak self] (date) in
            let nowDateStr = DateFormatter.yyyyMMddFormatter.string(from: date)
            self!.monthSwitchView.updateShowDateWithYear(month: nowDateStr)
            self?.loadMonthData(date: date.getString(format: "yyyy"))
        }
        datePicker.show()
    }
}

//MARK: - SelectYearAndMonthDelegate
extension CommissionMainViewController {
    func chooseYearAndMonth(chooseYM: (String,String,Date)){
        let dateStr = DateFormatter.yyyyMMddFormatter.string(from: chooseYM.2)
        self.monthSwitchView.updateShowDateWithMonth(month: dateStr)
    }
}
