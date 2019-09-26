
//
//  HistoryTableViewCell.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var barcodelbl: UILabel!
    
    @IBOutlet weak var conditionLbl: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var pictureLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
