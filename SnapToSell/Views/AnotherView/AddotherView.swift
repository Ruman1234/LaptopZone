//
//  AddotherView.swift
//  SnapToSell
//
//  Created by Apple on 10/5/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField



protocol AddotherViewDelegate {
//    func didAdd()
//    func didClose(barcode:String, weight: String, condition:String , remarks:String , conditin_Id:String)
    func didClose(text : String)
    func didClose()
}



class AddotherView: UIView {
    @IBOutlet weak var closeBtn: UIButton!
    
  var delegate : AddotherViewDelegate?
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var textfield: SkyFloatingLabelTextField!
    
    
    override func awakeFromNib() {
        doneBtn.setFont(size: 19)
        doneBtn.setGradient()
        
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        self.delegate?.didClose(text: self.textfield.text!)
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        
        delegate?.didClose()
    }
    
}
