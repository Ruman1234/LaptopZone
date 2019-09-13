//
//  PreviewViewController.swift
//  SnapToSell
//
//  Created by Apple on 8/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate {
    func dataBack(img :[UIImage])
}

class PreviewViewController: UIViewController , UICollectionViewDelegateFlowLayout , UICollectionViewDelegate , UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var img  = [UIImage]()
    var delegate : PreviewViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = true
        //        collectionView.isZooming = true
        collectionView.maximumZoomScale = 6
        collectionView.minimumZoomScale = 1
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return img.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
        
        let Cimg = self.img[indexPath.row]
        
        let ii = Cimg.fixedOrientation()
        cell.setup()
        cell.productImage.image = ii
        cell.cancleBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        
//        if Constants.orientaionArray.count > 0 {
//            if Constants.orientaionArray[indexPath.row] == 0{
//                let transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
//                cell.scrollView.transform = transform
//
//            }else{
//                let transform = CGAffineTransform(rotationAngle: CGFloat(0))
//                cell.scrollView.transform = transform
//
//            }
//        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let pageWidth:Float = Float(self.view.bounds.width)
        let minSpace:Float = 10.0
        
        var cellToSwipe:Double = Double(Float((scrollView.contentOffset.x))/Float((pageWidth+minSpace)))
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
            cellToSwipe = cellToSwipe  + Double(0.1)
        }else{
            cellToSwipe = cellToSwipe  + Double(0.9)
        }
        
        if cellToSwipe < 0 {
            cellToSwipe = 0
        } else if cellToSwipe >= Double(self.img.count) {
            cellToSwipe = Double(self.img.count) - Double(1)
        }
        let indexPath:IndexPath = IndexPath(row: Int(cellToSwipe), section:0)
        self.collectionView.scrollToItem(at:indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        
    }
    
    @IBAction func cancleBtn(_ sender: AnyObject) {
        
        if self.delegate != nil {
            self.delegate.dataBack(img: self.img)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func deleteBtn(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "!!!", message: "Are you sure you want to delete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.removeBarcode(sender.tag)
            
            if self.img.count == 0 {
                if self.delegate != nil {
                    self.delegate.dataBack(img: self.img)
                }
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeBarcode(_ i: Int) {
        
        self.img.remove(at: i)
        let indexPath = IndexPath(row: i, section: 0)
        
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        }
    }
    
        
}
    

