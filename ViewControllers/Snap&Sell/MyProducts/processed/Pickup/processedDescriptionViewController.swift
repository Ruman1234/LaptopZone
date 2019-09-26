//
//  processedDescriptionViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class processedDescriptionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func continueBtn(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("nextStepPickup"), object: nil)
    }
    
}
