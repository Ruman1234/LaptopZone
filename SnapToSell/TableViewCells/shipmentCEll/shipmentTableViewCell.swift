//
//  shipmentTableViewCell.swift
//  SnapToSell
//
//  Created by Apple on 10/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class shipmentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
