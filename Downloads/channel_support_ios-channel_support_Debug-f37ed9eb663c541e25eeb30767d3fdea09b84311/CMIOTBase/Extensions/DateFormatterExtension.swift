//
//  DateFormatterExtention.swift
//  CMIOTBase
//
//  Created by junzhang on 2018/9/20.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter {
    
    public class var yyyyMMddHHmmssFormatter: DateFormatter {
        get {
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFmt
        }
    }
    
    public class var  yyyyMMddFormatter: DateFormatter {
        get {
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "yyyy-MM-dd"
            return dateFmt
        }
    }
    
    public class var  yyyyMMddFormatter2: DateFormatter {
        get {
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "yyyy/MM/dd"
            return dateFmt
        }
    }
    
    public class var  yyyyMMddFormatterYear: DateFormatter {
        get {
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "yyyy年MM月dd日"
            return dateFmt
        }
    }
    
    public class var  yyyyMMddFormatterMonth: DateFormatter {
        get {
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "MM月dd日"
            return dateFmt
        }
    }
    
    
    public class var HHmmFormatter: DateFormatter {
        get {
            let dateFmt = DateFormatter()
            dateFmt.dateFormat = "HH:mm"
            return dateFmt
        }
    }
}
extension Date {
    func toStringTypeTwo() -> (String,String,Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let result = dateFormatter.string(from: self)
        return (result.components(separatedBy: "-").first!,result.components(separatedBy: "-").last!,self)
    }
    
    func calFirstAndLastDay() -> (String, String, Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let result = dateFormatter.string(from: self)
        
        let firstDay = result + "-" + "01"
        let lastDay = result + "-" + String(self.numberOfDaysInMonth())
        return (firstDay,lastDay,self)
    }
}

//MARK: UIFont - 字体
extension UIFont {
    static func fontWithPX(px : CGFloat) -> UIFont {
        var floats : CGFloat = 1.2
        if UIScreen.main.bounds.size.width == 375 {
            floats = 1.05
        } else if UIScreen.main.bounds.size.width > 375 {
            floats = 0.95;
        }
        return UIFont.systemFont(ofSize: px / ( 2.0 * floats ) * 2)
    }
}

