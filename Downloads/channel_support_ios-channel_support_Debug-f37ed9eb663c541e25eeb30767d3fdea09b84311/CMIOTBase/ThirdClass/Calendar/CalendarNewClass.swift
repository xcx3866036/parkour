//
//  CalendarNewClass.swift
//  EntranceGuardV2.0
//
//  Created by gh on 2017/10/19.
//  Copyright © 2017年 gh. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarSelectMonthNewDelegate {
    func didTapMonthSelect()
}

class CalendarSelectMonthNewView :UIView {
    var yearLabel:UILabel!
    var monthLabel:UILabel!
    var dateView:UIView!
    var delegate:CalendarSelectMonthNewDelegate!
    
    lazy var dateFormatter1:DateFormatter = {
        let formartter = DateFormatter.init()
        formartter.dateFormat = "yyyy"
        return formartter
    }()
    
    lazy var dateFormatter2:DateFormatter = {
        let formartter = DateFormatter.init()
        formartter.dateFormat = "MM"
        return formartter
    }()
    
    lazy var dateFormatter3:DateFormatter = {
        let formartter = DateFormatter.init()
        formartter.dateFormat = "yyyy-MM-dd"
        return formartter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUi()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarSelectMonthNewView {
    func initUi(){
        self.dateView = UIView.init(x: self.centerX - 50, y: 0, w: 105, h: self.h)
        self.dateView.backgroundColor = UIColor.clear
        self.addSubview(self.dateView)
        
        self.yearLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, w: 60, h: self.h))
        self.yearLabel.textAlignment = .right
        self.yearLabel.textColor = UIColor.white
        self.yearLabel.font = UIFont.systemFont(ofSize: 18)
        self.dateView.addSubview(self.yearLabel)
        
        self.monthLabel = UILabel.init(x: self.yearLabel.right, y: 0, w: 25, h: self.h)
        self.monthLabel.textColor = UIColor.white
        self.monthLabel.font = UIFont.systemFont(ofSize: 18)
        self.monthLabel.textAlignment = .left
        self.dateView.addSubview(self.monthLabel)
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: self.monthLabel.right + 6, y: self.monthLabel.centerY - 3, w: 13, h: 6)
        button.setImage(#imageLiteral(resourceName: "manager_date_more"), for: .normal)
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        self.dateView.addSubview(button)
        
        self.dateView.addTapGesture { (sender) in
            self.buttonPress()
        }
    }
    
    func updateShowDateWithMonth(month:String){
//        self.yearLabel.text = "\(self.dateFormatter1.string(from: self.dateFormatter3.date(from: month)!))年"
//        self.monthLabel.text = "\(String(describing: self.dateFormatter2.string(from: self.dateFormatter3.date(from: month)!).toInt()!.toString))月"
        self.yearLabel.text = "\(self.dateFormatter1.string(from: self.dateFormatter3.date(from: month)!))-"
        self.monthLabel.text = "\(String(describing: self.dateFormatter2.string(from: self.dateFormatter3.date(from: month)!).toInt()!.toString))"
    }
    
    func updateShowDateWithYear(month:String){

        self.yearLabel.text = "\(self.dateFormatter1.string(from: self.dateFormatter3.date(from: month)!))"

    }
    
    @objc func buttonPress(){
        self.delegate.didTapMonthSelect()
    }
}

