//
//  AddressTableViewCell.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/10.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
