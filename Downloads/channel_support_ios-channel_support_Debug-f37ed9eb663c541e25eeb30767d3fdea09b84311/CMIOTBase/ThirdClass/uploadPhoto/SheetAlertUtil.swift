//
//  SheetAlertUtil.swift
//  LoveHome
//
//  Created by Apple on 2018/9/29.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class SheetAlertUtil: UIView {
    
    fileprivate var bgkView:UIView! = nil
    fileprivate var viewSize:CGSize! = nil
    
    //按钮回调方法
    var selectIndex: ((_ selectIndex: Int) -> Swift.Void)?
    
    init(frame: CGRect, titles:[String]) {
        super.init(frame: frame)
        viewSize = UIScreen.main.bounds.size
        self.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenSheet))
        self.addGestureRecognizer(tap)
        makeBaseUIWithTitles(titles: titles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//MARK: - 私有方法,别乱搞,出了问题我不负责的哈
extension SheetAlertUtil {
    
    fileprivate func makeBaseUIWithTitles(titles:[String]) {
        
        bgkView = UIView.init(frame:CGRect.init(x: 0, y: viewSize.height, width: viewSize.width, height: CGFloat(titles.count) * 44 + 50))
        bgkView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:0.8)
        self.addSubview(bgkView)
        
        var y = self.createBtnWithTitle(title: "取消", origin_y: bgkView.frame.size.height - 44, tag: -1) - 50
        for i in 0..<titles.count {
            y = self.createBtnWithTitle(title: titles[i], origin_y: y, tag: i)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.bgkView.alpha = 1.0
            self.bgkView.transform = CGAffineTransform(translationX: 0, y: -self.bgkView.bounds.height)
        }, completion: nil)
    }
    
    fileprivate func createBtnWithTitle(title:String, origin_y:CGFloat, tag:NSInteger) -> CGFloat{
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.frame = CGRect.init(x: 0, y: origin_y, width: viewSize.width, height: 44)
        btn.backgroundColor = UIColor.white
        btn.tag = tag
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
        bgkView.addSubview(btn)
        var y = origin_y
        y -= tag == -1 ? 0 : 44.4
        return y
    }
    
    @objc fileprivate func click(sender:UIButton) {
        
        if (selectIndex != nil)&&(sender.tag != -1) {
            selectIndex!(sender.tag)
        }
        //不管点击哪一个都让他先kill掉,以免造成不必要的麻烦
        hiddenSheet()
    }
    
    @objc fileprivate func hiddenSheet() {
        //延时0.5s执行 让它有个过度感😂
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.bgkView.alpha = 0.0
            self.bgkView.transform = CGAffineTransform.identity
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}


