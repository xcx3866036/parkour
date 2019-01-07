//
//  ZSSearchView.swift
//  EntranceGuardV2.0
//
//  Created by cuixin on 2017/11/1.
//  Copyright © 2017年 gh. All rights reserved.
//

import UIKit

class ZSSearchView: UIView {

    var searchBar : UISearchBar!
    var searchBtn : UIButton!
    var defaultBtn : UIButton!
    
    override var intrinsicContentSize:CGSize{
       return UILayoutFittingExpandedSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       initUI()
    }
    
    func initUI() {
        searchBtn = UIButton()
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.setTitleColor(RGB(23, g: 146, b: 251), for: .normal)
        searchBtn.titleLabel?.font = UIFont.fontWithPX(px: 17)
        searchBtn.backgroundColor = UIColor.clear
        searchBtn.isHidden = true
        self.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-13.5 * kRatioToIP6W)
            make.height.equalTo(16 )
            make.width.equalTo(0)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        defaultBtn = UIButton()
        defaultBtn.setTitle("请输入姓名", for: .normal)
        defaultBtn.setImage(UIImage(named: "black_search"), for: .normal)
        defaultBtn.setTitleColor(RGB(200, g: 200, b: 200), for: .normal)
        defaultBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        defaultBtn.backgroundColor = UIColor.white
        defaultBtn.layer.borderColor = RGB(217, g: 217, b: 217).cgColor
        defaultBtn.layer.borderWidth = 0.5
        defaultBtn.layer.cornerRadius = 6
        defaultBtn.layer.masksToBounds = true
        
        self.addSubview(defaultBtn)
        defaultBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(searchBtn.snp.left).offset(-14)
            make.height.equalTo(34)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        defaultBtn.LayoutButtonWithEdgeInsetsStyle(style: .ZSButtonEdgeInsetsStyleLeft, imageTitleSpace: 9)
        
        searchBar = UISearchBar()
        searchBar.placeholder = "请输入姓名"
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.white
        searchBar.layer.borderColor = RGB(200, g: 200, b: 200).cgColor
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 6
        searchBar.layer.masksToBounds = true
        self.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(searchBtn.snp.left).offset(-14)
            make.height.equalTo(34)
            make.centerY.equalTo(self.snp.centerY)
        }

        defaultBtn.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
