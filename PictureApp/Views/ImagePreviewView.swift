//
//  ImagePreviewView.swift
//  PictureApp
//
//  Created by Apple on 6/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit


protocol ImagePreviewViewDelegate {
    func didclose(Arr : [UIImage])
}

class ImagePreviewView: UIView ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var img = [UIImage]()
    var delegate:ImagePreviewViewDelegate?
    
    override func awakeFromNib() {
        collectionView.register(PictrureCollectionViewCell.self, forCellWithReuseIdentifier: "PictrureCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictrureCollectionViewCell", for: indexPath) as! PictrureCollectionViewCell

        cell.backgroundColor = UIColor.blue
//        cell.imgView.image = self.img[0]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.didclose(Arr: img)
        if delegate != nil {
            self.delegate?.didclose(Arr: img)
        }
        dasd()
    }
    
    func dasd()  {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
}
