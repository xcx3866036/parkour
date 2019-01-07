//
//  submitOrderTableViewCell.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class submitOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
