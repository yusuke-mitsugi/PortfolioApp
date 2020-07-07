//
//  StampChoiseViewController.swift
//  PortfolioApp
//
//  Created by Yusuke Mitsugi on 2020/05/28.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit

protocol SelectStampDelegate {
    
    func selectStamp(stamp:UIImage)
}



class StampChoiseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var imageArray:[UIImage] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: SelectStampDelegate?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        collectionView.collectionViewLayout = layout
        
        print("コレクション")
        
        // ↓ 本番
        for i in 1...15 {
            imageArray.append(UIImage(named: "\(i).png")!)
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    
    //セルルが選択された時のメソッド
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let stamp = imageArray[indexPath.row]
        delegate?.selectStamp(stamp: stamp)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace:CGFloat = 20
        let cellSize:CGFloat = self.view.bounds.width/3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    @IBAction func closeTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
