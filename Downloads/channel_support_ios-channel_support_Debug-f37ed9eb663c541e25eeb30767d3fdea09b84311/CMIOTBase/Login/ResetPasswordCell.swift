//
//  ResetPasswordCell.swift
//  EntranceGuardV2.0
//
//  Created by 杜鹏 on 2017/7/17.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ResetPasswordCell: UITableViewCell {
    var titleTextField: UITextField!
    var textField:UITextField!
    
    var endEditBlock: ((_ text:String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
//        self.textLabel?.textColor = RGB(68, g: 68, b: 68)
//        self.textLabel?.font = UIFont.systemFont(ofSize: 12)
        self.accessoryType = .none
        
        titleTextField = UITextField.init(x: 24 * kRatioToIP6W, y: 26, w: SCREEN_WIDTH - 30 - 36 * kRatioToIP6W, h: 24, fontSize: 17)
        titleTextField.font = UIFont.boldSystemFont(ofSize: 17)
        titleTextField.textAlignment = .left
        titleTextField.textColor = RGB(46, g: 51, b: 59)
        titleTextField.delegate = self
        
        textField = UITextField.init(x: 24 * kRatioToIP6W, y: titleTextField.bottom, w: SCREEN_WIDTH - 30 - 36 * kRatioToIP6W, h: 37, fontSize: 14)
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.none
        textField.adjustsFontSizeToFitWidth=true
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.tintColor = RGB(63, g: 137, b: 242)
        textField.contentVerticalAlignment = .center  //垂直居中对齐
        textField.clearButtonMode = .whileEditing //编辑时出现清除按钮
        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        textField.keyboardDistanceFromTextField = 140
        textField.setValue(RGB(225, g: 225, b: 225), forKeyPath:"_placeholderLabel.textColor")
        textField.textAlignment = .left
        textField.textColor = RGB(68, g: 68, b: 68)
        textField.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(textField)
        contentView.addSubview(titleTextField)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResetPasswordCell: UITextFieldDelegate {
    // MARK: textField delegate
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            return false
        }
        return true
    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        let length:NSInteger = (newString?.length)!
        if self.tag == 0 {
            if length > 4 {
                return false
            }
        }
        else{
            if length > 18 {
                return false
            }
            let StringSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" //不允许输入其他字符
            for c in string.characters {
                if  !StringSet.contains(String(c)){
                    return false
                }
            }
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
