//
//  PreviewViewController.swift
//  PictureApp
//
//  Created by Apple on 6/29/19.
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictrureCollectionViewCell", for: indexPath) as! PictrureCollectionViewCell
        
//        cell.scrollView.minimumZoomScale = 1.0
//        cell.scrollView.maximumZoomScale = 6.0

        cell.setup()
        cell.imgView.image = self.img[indexPath.row]
        cell.cancleBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
       
        
//        let imageView = ImageZoomView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), image: nil)
//        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.layer.borderWidth = 5
        

        
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
        self.removeBarcode(sender.tag)
        
        if self.img.count == 0 {
            if self.delegate != nil {
                self.delegate.dataBack(img: self.img)
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
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
