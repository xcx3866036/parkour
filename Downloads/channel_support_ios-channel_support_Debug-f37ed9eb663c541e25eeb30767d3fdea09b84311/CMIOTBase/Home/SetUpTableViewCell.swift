//
//  SetUpTableViewCell.swift
//  CMIOTBase
//
//  Created by Apple on 2018/10/10.
//  Copyright © 2018年 xiaojunzhang. All rights reserved.
//

import UIKit

class SetUpTableViewCell: UITableViewCell {

    @IBOutlet weak var numTF: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    var setUpScanActionBlock:(() -> Void)?
    var setUpGoBlock:(() -> Void)?
    var productId: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let imageView = UIImageView.init(frame:CGRect(x: 0, y: 0, w: 31, h: 31))
        imageView.image = UIImage.init(named: "exchange_scan")
        
        imageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(scanClick))
        imageView.addGestureRecognizer(gesture)
        
        self.numTF.rightView = imageView
        self.numTF.rightViewMode = .always
        self.numTF.delegate = self
    }

    @objc func scanClick(_ recog:UITapGestureRecognizer){
        
        if(setUpScanActionBlock != nil){
            self.setUpScanActionBlock!()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

extension SetUpTableViewCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(setUpGoBlock != nil){
            self.setUpGoBlock!()
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text?.count != 0){
            if(setUpGoBlock != nil){
                self.setUpGoBlock!()
            }
        }
    }
}
