//
//  PictrureCollectionViewCell.swift
//  PictureApp
//
//  Created by Apple on 6/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PictrureCollectionViewCell: UICollectionViewCell , UIScrollViewDelegate{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var barcodeLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let MAXIMUM_SCALE = 3.0
    let MINIMUM_SCALE = 1.0

     
    override func awakeFromNib() {
//        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(_:)))
//        imgView.addGestureRecognizer(pinch)
        
    }
    
    
    func setup() {
        
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.zoomImage(_:)))
        imgView.gestureRecognizers = [pinch]
        imgView.isUserInteractionEnabled = true
//        scrollView.delegate = self
        
    }

    @objc func zoomImage(_ gesture: UIPinchGestureRecognizer?) {
        if gesture?.state == .ended || gesture?.state == .changed {
            print("gesture.scale = \(gesture?.scale ?? 0.0)")
            
            let currentScale: CGFloat = frame.size.width / bounds.size.width
            var newScale = currentScale * (gesture?.scale ?? 0.0)
            
            if newScale < CGFloat(MINIMUM_SCALE) {
                newScale = CGFloat(MINIMUM_SCALE)
            }
            if newScale > CGFloat(MAXIMUM_SCALE) {
                newScale = CGFloat(MAXIMUM_SCALE)
            }
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            imgView.transform = transform
            scrollView.contentSize = imgView.frame.size
        }
        
    }
    
    
    
    @objc func pinch(_ sender: UIPinchGestureRecognizer){
        imgView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
}
