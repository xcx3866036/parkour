//
//  CommissionTableViewCell.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class CommissionTableViewCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var rightDate: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var leftDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
