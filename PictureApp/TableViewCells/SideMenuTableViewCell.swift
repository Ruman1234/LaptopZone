
//
//  SideMenuTableViewCell.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
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
