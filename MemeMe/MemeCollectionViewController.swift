//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Marwa Abou Niaaj on 3/29/17.
//  Copyright © 2017 Marwa Abou Niaaj. All rights reserved.
//

import UIKit

private let cellIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var memeFlowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView?.isPrefetchingEnabled = false
        installsStandardGestureForInteractiveMovement = true

        adjustFlowLayout(to: self.view.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.adjustFlowLayout(to: size)
        }, completion: nil)
    }
    
    func adjustFlowLayout(to size: CGSize) {
        
        if let memeFlowLayout = memeFlowLayout {
        
            let space: CGFloat = 3.5
            let dimension:CGFloat =
                size.width >= size.height ?
                    (size.width - (5 * space)) / 6.0 :
                    (size.width - (2 * space)) / 3.0
            
            memeFlowLayout.minimumInteritemSpacing = space
            memeFlowLayout.minimumLineSpacing = space
            memeFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        let meme = self.memes[indexPath.row]
        
        // Configure the cell
        cell.setText(top: meme.top, bottom: meme.bottom)
        cell.memeImageView.image = meme.image
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailVC.meme = memes[indexPath.row]
        memeDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}
