

//
//  SideMenuTableViewCell.swift
//  SnapToSell
//
//  Created by Apple on 8/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
