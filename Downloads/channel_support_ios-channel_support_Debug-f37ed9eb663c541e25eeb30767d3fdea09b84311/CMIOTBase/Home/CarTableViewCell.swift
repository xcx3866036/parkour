//
//  CarTableViewCell.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/9.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit
import SVProgressHUD
class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var reduceBt: UIButton!
    @IBOutlet weak var addBt: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    var num:Int = 0
    var model:ProductModel?
    var carActionBlock:((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addBt(_ sender: Any) {
        self.reduceBt.isEnabled = true
        self.addBt.isEnabled = true
        
        if self.numLabel.text == "99" {
            return
        }
        self.num = Int(self.numLabel.text!)!
        self.num += 1
        self.numLabel.text = String(format: "%d", self.num)
     

        if(self.carActionBlock != nil){
            self.carActionBlock!(self.num)
        }
        
    }
    @IBAction func reduceBt(_ sender: Any) {
        
        
        self.num = Int(self.numLabel.text!)!
        if num <= 0 {
            return
        }
        self.num -= 1
        self.numLabel.text = String(format: "%d", self.num)

        if(self.carActionBlock != nil){
            self.carActionBlock!(self.num)
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
