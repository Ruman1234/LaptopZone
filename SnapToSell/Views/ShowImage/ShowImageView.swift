//
//  ShowImageView.swift
//  SnapToSell
//
//  Created by Apple on 10/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit




protocol ShowImageViewDelegate {
//    func didCloseWithoutimg(text : String)
    func didCloseImgView()
}

class ShowImageView: UIView {

    @IBOutlet weak var downloadBTn: UIButton!
    @IBOutlet weak var cancleBtnView: UIView!
    
    @IBOutlet weak var image: UIImageView!
    var img = UIImage()
    
    var delegate : ShowImageViewDelegate?
    
    override func awakeFromNib() {
        
        cancleBtnView.applyGradient(colours: [UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1) , UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)], locations: nil, startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
        downloadBTn.setGradient()
//        if img != nil {
        
//        let img = UIImageView()
//        img.frame = CGRect(x: 0, y: 0, width: self.frame.width - 50, height: self.frame.height - 100)
//        self.addSubview(img)
//        img.image = self.img
//            self.image.image = img
//        }
        
    }
    
    @IBAction func cancle(_ sender: Any) {
        
        delegate?.didCloseImgView()
    }
    
    
    @IBAction func cancleBtn(_ sender: Any) {
        delegate?.didCloseImgView()
    }
    
    @IBAction func downloadBtn(_ sender: Any) {
         UIImageWriteToSavedPhotosAlbum(self.image.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
//        UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)

        
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
               // we got back an error!
//               let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
//               ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.showToast(message: "Save error")
//            delegate?.didCloseImgView()
//               present(ac, animated: true)
           } else {
//               let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
//               ac.addAction(UIAlertAction(title: "OK", style: .default))
            delegate?.didCloseImgView()
//            self.showToast(message: "Saved!")
            
//               present(ac, animated: true)
           }
       }
       
    
}
