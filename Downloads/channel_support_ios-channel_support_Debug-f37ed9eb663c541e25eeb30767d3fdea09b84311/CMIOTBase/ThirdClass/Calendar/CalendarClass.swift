//
//  CalendarClass.swift
//  EntranceGuardV2.0
//
//  Created by gh on 2017/5/12.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit
import FSCalendar

protocol SelectYearAndMonthDelegate : NSObjectProtocol {
    func chooseYearAndMonth(chooseYM: (String,String,Date))
}

class CalendarSelectMonthDetailView: UIView {
    var calendarContainerView:UIView!
    var backView :UIView!
    var calendarView:MonthYearPickerView!
    var selectYear:Int!
    var selectMonth:Int!
    weak var delegate:SelectYearAndMonthDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarSelectMonthDetailView {
    func initUi(){
        self.backView = UIView.init(frame: self.bounds)
        self.backView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.6)
        self.addSubview(self.backView)
        self.backView.alpha = 0
        let tapControl = UITapGestureRecognizer.init(target: self, action: #selector(tapDismiss))
        self.backView.addGestureRecognizer(tapControl)
        
        
        self.calendarContainerView = UIView.init()
        self.calendarContainerView.bounds = CGRect.init(x: 0, y: 0, w: 305, h: 308)
        self.calendarContainerView.center = CGPoint.init(x: self.backView.centerX, y: -154)
        self.calendarContainerView.backgroundColor = UIColor.white
//        self.calendarContainerView.cornerRadius = 9
//        self.calendarContainerView.masksToBounds = true
        self.calendarContainerView.setCornerRadius(radius: 9)
        self.addSubview(self.calendarContainerView)
        
        let titleLabel = UILabel.init(x: 0, y: 0, w: self.calendarContainerView.w, h: 53)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = "选择年月"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.backgroundColor = RGB(37, g: 150, b: 255)
        self.calendarContainerView.addSubview(titleLabel)

        self.calendarView = MonthYearPickerView.init(frame: CGRect.init(x: 0, y: titleLabel.frame.maxY, w: self.calendarContainerView.w, h: 202))
        self.calendarView.commonSetup()
        self.selectYear = self.calendarView.orignalYear
        self.selectMonth = self.calendarView.orignalMonth
        self.calendarContainerView.addSubview(self.calendarView)
        
        let line = UIView.init(x: 0, y: self.calendarView.frame.maxY, w: self.calendarView.w, h: 1)
        line.backgroundColor = RGB(217, g: 217, b: 217)
        self.calendarContainerView.addSubview(line)
        
        let cancelButton = UIButton.init(type: .system)
        cancelButton.frame = CGRect.init(x: 0, y: line.frame.maxY, w: self.calendarContainerView.w/2, h: self.calendarContainerView.h - line.frame.maxY)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(RGB(101, g: 101, b: 101), for: .normal)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.addTarget(self, action: #selector(cancelButtonPress), for: .touchUpInside)
        self.calendarContainerView.addSubview(cancelButton)
        
        
        let confirmButton = UIButton.init(type: .system)
        confirmButton.frame = CGRect.init(x: cancelButton.frame.maxX, y: cancelButton.frame.minY, w: cancelButton.w, h: cancelButton.h)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = RGB(37, g: 150, b: 255)
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmButton.addTarget(self, action: #selector(selectMonthPress), for: .touchUpInside)
        self.calendarContainerView.addSubview(confirmButton)
        
        self.calendarView.onDateSelected = { [weak self] (month: Int, year: Int) in
            self!.selectMonth = month
            self!.selectYear = year
        }
    }
    
    func reload() {
        self.backView.removeFromSuperview()
        self.calendarContainerView.removeFromSuperview()
        self.initUi()
    }
    
    @objc func cancelButtonPress(){
        self.dismiss()
    }
    
    @objc func selectMonthPress(){
        let calendar = NSCalendar.current
        let dateComponents = NSDateComponents.init()
        dateComponents.year = self.selectYear
        dateComponents.month = self.selectMonth
        dateComponents.day = 1
        let date = calendar.date(from: dateComponents as DateComponents)
        self.delegate?.chooseYearAndMonth(chooseYM: date!.toStringTypeTwo())
        self.dismiss()
    }
    
    @objc func tapDismiss(){
        self.dismiss()
    }
    
    func show(){
        UIView.animate(withDuration: 0.4, animations: {
            self.calendarContainerView.center = self.backView.center
            self.backView.alpha = 1
        }) { (Bool) in
            
        }
    }
    
    func dismiss(){
        UIView.animate(withDuration: 0.4, animations: {
            self.calendarContainerView.center = CGPoint.init(x: self.backView.centerX, y: -154)
            self.backView.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
}

enum calendarEnterMode : Int{
    case calendarEnterModeFromMainCheking = 0
    case calendarEnterModeFromDetailChecking
}

class CalendarSelectDayView: UIView,FSCalendarDataSource,FSCalendarDelegate{
    var calendarContainerView:UIView!
    var calendar :FSCalendar!
    var backView :UIView!
    var enterMode:calendarEnterMode!
    var callBack:(()->())?
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(date: Date = Date()) {
        self.removeSubviews()
        self.initView(date: date)
    }
    
    func initView(date: Date = Date()){
        self.backView = UIView.init(frame: self.bounds)
        self.backView.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.6)
        self.backView.alpha = 0
        self.addSubview(self.backView)
        
        self.calendarContainerView = UIView.init()
        self.calendarContainerView.layer.shadowColor = UIColor.black.cgColor
        self.calendarContainerView.layer.shadowOpacity = 0.5
        self.calendarContainerView.layer.shadowOffset = CGSize.zero
        self.calendarContainerView.layer.shadowRadius = 5
        self.calendarContainerView.bounds = CGRect.init(x: 0, y: 0, w: SCREEN_WIDTH - 40, h: 250)
        self.calendarContainerView.center = CGPoint.init(x: self.backView.centerX, y: -61)
        self.calendarContainerView.backgroundColor = UIColor.white
        self.addSubview(self.calendarContainerView)

        self.calendar = FSCalendar.init()
        self.calendar.backgroundColor = UIColor.white
        self.calendar.frame = CGRect.init(x: 10, y: 0, w: self.calendarContainerView.w - 20, h: self.calendarContainerView.h)
        
        self.calendarContainerView.addSubview(self.calendar)
        self.calendar.appearance.headerTitleColor = RGB(106, g: 180, b: 243)
        self.calendar.appearance.weekdayTextColor = UIColor.black
        self.calendar.appearance.titleFont = UIFont.systemFont(ofSize: 15)
        self.calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 15)
        self.calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 15)
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.appearance.headerDateFormat = "yyyy年MM月"
        self.calendar.scope = .month
        self.calendar.placeholderType = .none
        self.calendar.appearance.selectionColor = RGB(106, g: 180, b: 243)
        self.calendar.appearance.titleWeekendColor = UIColor.black
        self.calendar.bottomBorder.isHidden = true
        self.calendar.allowsMultipleSelection = false
        let tapControl = UITapGestureRecognizer.init(target: self, action: #selector(tapDismiss))
        self.backView.addGestureRecognizer(tapControl)
        
        let leftView = UIView.init()
        leftView.backgroundColor = UIColor.white
        self.calendarContainerView.addSubview(leftView)
        
        let rightView = UIView.init()
        rightView.backgroundColor = UIColor.white
        self.calendarContainerView.addSubview(rightView)
        
        leftView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.top.equalTo(0)
            ConstraintMaker.height.equalTo(30)
            ConstraintMaker.width.equalTo(80)
        }
        
        rightView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.right.top.equalTo(0)
            ConstraintMaker.height.equalTo(30)
            ConstraintMaker.width.equalTo(80)
        }
        self.calendar.select(date)
        self.calendar.appearance.headerDateFormat = "yyyy年MM月"
    }
    
    @objc func tapDismiss(){
        self.dismiss()
    }
    
    func show(){
        UIView.animate(withDuration: 0.4, animations: {
            self.calendarContainerView.center = self.backView.center
            self.backView.alpha = 1
        }) { (Bool) in
        }
    }
    
    func dismiss(){
        UIView.animate(withDuration: 0.4, animations: {
            self.calendarContainerView.center = CGPoint.init(x: self.backView.centerX, y: -61)
            self.backView.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        if self.enterMode == calendarEnterMode.calendarEnterModeFromMainCheking {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: selectDateChangeNotifition), object: nil, userInfo: ["dataPunchard":date.toStringTypeOne()])
            self.dismiss()
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
}

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var beginYear:Int!
    var months: [String]!
    var years: [Int]!
    var yearCount:Int!
    var orignalMonth:Int!
    var orignalYear:Int!
    var month: Int = 0 {
        didSet {
            selectRow(month-1, inComponent: 1, animated: false)
        }
    }
    
    var year: Int = 0 {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 0, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            self.orignalYear = year
            year = 2000
            for _ in 0...self.orignalYear - year {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 1
        for _ in 1...12 {
//            months.append(DateFormatter().monthSymbols[month].capitalized)
            months.append("\(month)月")
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.orignalMonth = currentMonth
        self.selectRow(currentMonth - 1, inComponent: 1, animated: false)
        self.selectRow(years.count - 1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 1:
            return months[row]
        case 0:
            return "\(years[row])年"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1:
            return months.count
        case 0:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 1)+1
        let year = years[self.selectedRow(inComponent: 0)]

        if let block = onDateSelected {
            block(month, year)
        }
        
        self.month = month
        self.year = year
    }
}
