//
//  Extension+UITableView.swift
//  Parkour
//
//  Created by XiaoFeng on 2018/2/9.
//  Copyright © 2018年 新翼工作室. All rights reserved.
//

import UIKit

extension UITableView {

    func removeMoreLine() {
        let view = UIView(frame: CGRect.zero)
        self.tableFooterView = view
    }

}
