

//
//  OffertableViewCell.swift
//  SnapToSell
//
//  Created by Apple on 10/9/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OffertableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var flawLess: UIButton!
    @IBOutlet weak var brokenBtn: UIButton!
    
    @IBOutlet weak var productName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func yesBtn(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            self.yesBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func noBtn(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            self.noBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    

}
