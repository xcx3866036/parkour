//
//  ZSDatePickerView.swift
//  EntranceGuardV2.0
//
//  Created by cuixin on 2017/10/31.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit

enum DatePickerTypes : Int {
    case YearMonthDay = 0   //年月日
    case HoursMinute        //小时分钟
}


protocol CertainDateDelegate : NSObjectProtocol{
    func certainDateString(Date : String , DatePicerType : DatePickerTypes)
}

class ZSDatePickerView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    var dateTypes : DatePickerTypes!
    //MARK: pickView
    var pickView : UIPickerView!
    //当前选中年月日时分，选择年月日时分  区分开
    var currentYear : Int = 0
    var currentMonth : Int = 0
    var currentDay : Int = 0
    var currentHour : Int = 0
    var currentMinute : Int = 0
    var selectYear : Int = 0
    var selectMonth : Int = 0
    var selectDay : Int = 0
    var selectHour : Int = 0
    var selectMinute : Int = 0

    var MonthCountArray : [Int] = []
    var dayCountArray : [Int] = []
    
    //显示年范围
    var yearRange : Int = 0
    //协议
    weak var chooseDateDelegate : CertainDateDelegate?
    //背景
    var backgroundBtn : UIButton!
    //弹出容器
    var popContainView : UIView!
    //顶部容器
    var topView : UIView!
    //头标题label
    var titleLabel : UILabel!
    //底部容器
    var bottomContainView : UIView!
    //取消按钮
    var cancelBtn : UIButton!
    //确定按钮
    var certainBtn : UIButton!
    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        certainBtn.addTarget(self, action: #selector(certainDateString(sender:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }
    
    //确定日期
    @objc func certainDateString(sender : UIButton){
        var DateString = ""
        if dateTypes == .YearMonthDay {
            DateString = String(format: "%d年%02d月%02d日", selectYear, selectMonth, selectDay )
        }
        else{
            DateString = String(format: "%d时%d分", selectHour, selectMinute )
        }
        if self.chooseDateDelegate != nil {
            self.chooseDateDelegate?.certainDateString(Date: DateString , DatePicerType : dateTypes)
        }
    }
    
    //获取当前年月日
    func setCurrentDate(){
        let calendar = NSCalendar.current
        var comps : DateComponents = DateComponents()
        comps = calendar.dateComponents([.year, .month, .day ,.hour,.minute], from: Date.init())
        
        currentYear = comps.year!
        currentMonth = comps.month!
        currentDay = comps.day!
        currentHour = comps.hour!
        currentMinute = comps.minute!
        yearRange = 2

        selectYear = currentYear
        selectMonth = currentMonth
        selectDay = currentDay
        selectHour = currentHour
        selectMinute = currentMinute
        
        MonthCountArray = fetchCurrentMonthRemain(year: currentYear)
        dayCountArray = fetchCurrentDaysRemain(Month: currentMonth, Year: currentYear)
        
        pickView.reloadAllComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: 显示隐藏方法
extension ZSDatePickerView {
    /// show
    func showView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundBtn.alpha = 0.6
            self.popContainView.frame = CGRect(x: 35 * kRatioToIP6W, y: 180 * kRatioToIP6H, w: SCREEN_WIDTH - 70 * kRatioToIP6W, h: 307.5 * kRatioToIP6H)
        }) { (true) in
        }
    }
    
    /// dissmiss
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundBtn.alpha = 0
            self.popContainView.frame = CGRect(x: 35 * kRatioToIP6W, y: -307.5 * kRatioToIP6H, w: SCREEN_WIDTH - 70 * kRatioToIP6W, h: 307.5 * kRatioToIP6H)
        }) { (true) in
            self.removeFromSuperview()
        }
    }
}

//MARK: UI
extension ZSDatePickerView {
    func initUI() {
        //背景
        backgroundBtn = UIButton()
        backgroundBtn.backgroundColor = UIColor.black
        backgroundBtn.alpha = 0
        backgroundBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.addSubview(backgroundBtn)
        backgroundBtn.snp.makeConstraints { (make) in
            make.left.right.width.height.equalToSuperview()
        }
        
        popContainView = UIView()
        popContainView.frame = CGRect(x: 35 * kRatioToIP6W, y: -307.5 * kRatioToIP6H, w: SCREEN_WIDTH - 70 * kRatioToIP6W, h: 307.5 * kRatioToIP6H)
        popContainView.backgroundColor = UIColor.white
        popContainView.layer.cornerRadius = 9 * kRatioToIP6W
        popContainView.clipsToBounds = true
        popContainView.layer.masksToBounds = true
        self.addSubview(popContainView)
        
        topView = UIView()
        topView.backgroundColor = RGB(37, g: 150, b: 255)
        popContainView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(54 * kRatioToIP6H)
        }
        
        titleLabel = UILabel()
        titleLabel.text = "选择年月"
        //TODO: - 设置AttributesStr
//        titleLabel.labelAttributes(textFont: 17, textColor: UIColor.white, backgroundColor: UIColor.clear, textAlignment: .center)
        topView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        bottomContainView = UIView()
        bottomContainView.backgroundColor = UIColor.white
        popContainView.addSubview(bottomContainView)
        bottomContainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(53.5 * kRatioToIP6H)
        }
        
        let verView = UIView()
        verView.backgroundColor = UIColor.clear
        bottomContainView.addSubview(verView)
        verView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(0.1)
            make.centerX.equalTo(bottomContainView.snp.centerX)
        }
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(RGB(101, g: 101, b: 101), for: .normal)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.titleLabel?.font = UIFont.fontWithPX(px: 16)
        bottomContainView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(verView.snp.left).offset(0)
        }
        
        certainBtn = UIButton()
        certainBtn.setTitle("确定", for: .normal)
        certainBtn.setTitleColor(RGB(240, g: 250, b: 255), for: .normal)
        certainBtn.backgroundColor = RGB(37, g: 150, b: 255)
        certainBtn.titleLabel?.font = UIFont.fontWithPX(px: 16)
        bottomContainView.addSubview(certainBtn)
        certainBtn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(verView.snp.right).offset(0)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = RGB(217, g: 217, b: 217)
        bottomContainView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        //MARK: pickView
        pickView = UIPickerView()
        pickView.backgroundColor = UIColor.clear
        pickView.delegate = self
        pickView.dataSource = self
        popContainView.addSubview(pickView)
        pickView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.bottom.equalTo(bottomContainView.snp.top).offset(0)
        }
    }
}


//MARK: PickerView代理方法
extension ZSDatePickerView {
    //行高
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45.5 * kRatioToIP6H
    }
    //列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if self.dateTypes!.rawValue == 0 {
            return 3
        }else {
            return 2
        }
    }
    //行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //年月
        if self.dateTypes!.rawValue == 0 {
            if component == 0 {
                return yearRange
            }else if component == 1{
                return MonthCountArray.count
            }else{
                return dayCountArray.count
            }
        }else {  //时分
            if component == 0 {
                return 24
            }else{
                return 60
            }
        }
    }
    
   
    
    
    //行视图
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //改线的颜色
        pickerView.subviews[1].backgroundColor = RGB(141, g: 141, b: 141)
        pickerView.subviews[2].backgroundColor = RGB(141, g: 141, b: 141)
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 10, y: 10, w: 100, h: 20)
        let label = UILabel()
        //TODO: -
//        label.labelAttributes(textFont: 24.7, textColor: RGB(65, g: 65, b: 65), backgroundColor: UIColor.clear, textAlignment: .center)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        switch dateTypes {
        case .YearMonthDay?:
            if component == 0 {
                label.text = "\(currentYear + row)年"
            } else if component == 1{
                label.text = String.init(format: "%02d月", MonthCountArray[row])
            } else {
                label.text = String.init(format: "%02d日", dayCountArray[row])
            }
            break
        case .HoursMinute?:
            if component == 0 {
                label.text = "\(row)时"
            } else{
                label.text = "\(row)分"
            }
            break
        default:
            break
        }
        return view
    }
    //滚动监听
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.dateTypes == .YearMonthDay {
            switch component {
            case 0:
                selectYear = currentYear + row;
                MonthCountArray = fetchCurrentMonthRemain(year: selectYear)
                dayCountArray = fetchCurrentDaysRemain(Month: selectMonth, Year: selectYear)
                //解决选年份后 天数对应不了的问题
                selectMonth = MonthCountArray[0]
                dayCountArray = fetchCurrentDaysRemain(Month: selectMonth, Year: selectYear)
                
                self.pickView.reloadAllComponents()
                self.pickView.selectRow(0, inComponent: 1, animated: true)

            break;
            case 1:
                selectMonth = MonthCountArray[row];
                dayCountArray = fetchCurrentDaysRemain(Month: selectMonth, Year: selectYear)
                self.pickView.reloadComponent(2)
            break;
            case 2:
                selectDay = dayCountArray[row];
            default:
                break
            }
            
        } else {
            switch component {
            case 0:
                selectHour = row
            break
            case 1:
                selectMinute = row
            break
            default:
                break
            }
        }
    }
}

//计算当年剩余多少月
extension ZSDatePickerView {
    func fetchCurrentMonthRemain(year : Int) -> [Int] {
        var remainMonthArray : [Int] = []
        let lastMonth : Int = year == currentYear ? 13 - currentMonth : 12
        let startFor : Int = 12 - lastMonth + 1
        for i in startFor...12  {
            remainMonthArray.append(i)
        }
        return remainMonthArray
    }
    //计算当月剩余多少天
    func fetchCurrentDaysRemain(Month : Int , Year : Int) -> [Int] {
        //计算当月天数
        let currentMonthDay : Int = febTotalDays(year: selectYear, month: selectMonth)
        var startFor : Int = 0
        var daysArray : [Int] = []
        if Month == currentMonth && Year == currentYear{
            startFor = currentDay
        }else{
            startFor = 1
        }
        for i in startFor...currentMonthDay {
            daysArray.append(i)
        }
        return daysArray
    }
}

//MARK: 二月份总天数
extension ZSDatePickerView {
    func febTotalDays(year : Int , month : Int) -> Int {
        
        var day : Int = 0
        switch month
        {
        case 1:
            fallthrough
        case 3:
            fallthrough
        case 5:
            fallthrough
        case 7:
            fallthrough
        case 8:
            fallthrough
        case 10:
            fallthrough
        case 12:
            day = 31
            break
        case 4:
            fallthrough
        case 6:
            fallthrough
        case 9:
            fallthrough
        case 11:
            day = 30
            break
        case 2:
            if (year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0 {
                day = 29
                break
            }else{
                day=28;
                break
            }
        default:
            break;
        }
        return day;
    }
}





