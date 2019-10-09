//
//  SelectModelTableViewCell.swift
//  SnapToSell
//
//  Created by Apple on 10/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SelectModelTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViwe: UIImageView!
    
    @IBOutlet weak var modelName: UILabel!
    
    @IBOutlet weak var servicename: UILabel!
    
    
    @IBOutlet weak var getofferBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}