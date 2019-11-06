//
//  AddressTableViewCell.swift
//  SnapToSell
//
//  Created by Apple on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var aptStreet: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var defaultLbl: UILabel!
    
    
    @IBOutlet weak var zip: UILabel!
    
    @IBOutlet weak var number: UILabel!
    
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var numberLbl: UILabel!
    
    @IBOutlet weak var delBTn: UIButton!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet weak var acceptOffer: UIButton!
    
    @IBOutlet weak var rejectBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
