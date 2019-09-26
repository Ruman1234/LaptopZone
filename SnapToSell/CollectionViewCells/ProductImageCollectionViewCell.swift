//
//  ProductImageCollectionViewCell.swift
//  SnapToSell
//
//  Created by Apple on 8/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell ,UIScrollViewDelegate{
    
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var cancleBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var deleteBtn: UIButton!

    let MAXIMUM_SCALE = 3.0
    let MINIMUM_SCALE = 1.0

    
    
    func setup() {
        
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.clipsToBounds = false
        scrollView.delegate = self
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.zoomImage(_:)))
        productImage.gestureRecognizers = [pinch]
        productImage.isUserInteractionEnabled = true
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
            productImage.transform = transform
            scrollView.contentSize = productImage.frame.size
        }
        
    }
    
    
    
    @objc func pinch(_ sender: UIPinchGestureRecognizer){
        productImage.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return productImage
    }
}
