//
//  ShipmentRatesTableViewCell.swift
//  SnapToSell
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ShipmentRatesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var carier: UILabel!
    
    @IBOutlet weak var servidce: UILabel!
    
    @IBOutlet weak var rate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
