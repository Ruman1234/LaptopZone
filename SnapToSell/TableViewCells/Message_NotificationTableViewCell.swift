//
//  Message_NotificationTableViewCell.swift
//  SnapToSell
//
//  Created by Apple on 10/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Message_NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var messageImg: UIImageView!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var messageImageHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var chatview: UIView!
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var traillingSpace: NSLayoutConstraint!
    
    @IBOutlet weak var leadingSpace: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    
//    internal var aspectConstraint : NSLayoutConstraint? {
//        didSet {
//            if oldValue != nil {
//                messageImg.removeConstraint(oldValue!)
//            }
//            if aspectConstraint != nil {
//                messageImg.addConstraint(aspectConstraint!)
//            }
//        }
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        aspectConstraint = nil
//    }
//
//    func setPostedImage(image : UIImage) {
//
//        let aspect = image.size.width / image.size.height
//
//        aspectConstraint = NSLayoutConstraint(item: messageImg!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageImg!, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
//
//        messageImg.image = image
//    }

}
