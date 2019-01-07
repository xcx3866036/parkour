//
//  UserInfoCell.swift
//  EntranceGuardV2.0
//
//  Created by 杜鹏 on 2017/7/14.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    var textField:UITextField!
    
    var endEditBlock: ((_ text:String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.frame = CGRect(x:30*kRatioToIP6W, y:
            contentView.centerY - 7, width: 120,height:14)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.textLabel?.textColor = RGB(68, g: 68, b: 68)
        self.textLabel?.font = UIFont.systemFont(ofSize: 15)
//        self.accessoryType = .none
//        self.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "-e-箭头1"))

        textField = UITextField.init(x: SCREEN_WIDTH - 44.5 * kRatioToIP6W - 200 * kRatioToIP6W, y: 4, w: 200 * kRatioToIP6W, h: 46, fontSize: 15)
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.none
        textField.adjustsFontSizeToFitWidth=true
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.tintColor = RGB(63, g: 137, b: 242)
        textField.contentVerticalAlignment = .center  //垂直居中对齐
        textField.clearButtonMode = .whileEditing //编辑时出现清除按钮
        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        textField.keyboardDistanceFromTextField = 140
        textField.setValue(RGB(225, g: 225, b: 225), forKeyPath:"_placeholderLabel.textColor")
        textField.textAlignment = .right
        textField.textColor = RGB(153, g: 153, b: 153)
        contentView.addSubview(textField)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



extension UserInfoCell: UITextFieldDelegate {
    
    // MARK: textField delegate
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        let length:NSInteger = (newString?.length)!
//        print(textField.tag)
        switch textField.tag {
        case 1://姓名
            if length > 32 {
                return false
            }
        case 2://手机号
            if length > 11 {
                return false
            }
        case 6:// 职位
            if length > 16 {
                return false
            }
        case 8:// 邮箱
            if length > 64 {
                return false
            }
        case 9:// 办公电话
            if length > 32 {
                return false
            }
        case 10:// 办公地址
            if length > 128 {
                return false
            }
        case 11:// 身份证号
            if length > 18 {
                return false
            }
        case 13, 14: // 支付宝、微信
            if length > 128 {
                return false
            }
        case 15:// 银行卡号
            if length > 32 {
                return false
            }
        default:
            if length > 50 {
                return false
            }
            break
        }

        return true
    }
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField){
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        endEditBlock?(textField.text!)
    }
    
}



