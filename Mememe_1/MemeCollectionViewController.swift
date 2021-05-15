//
//  MemeCollectionViewController.swift
//  Mememe_1
//
//  Created by Gizem Boskan on 4.05.2021.
//  Copyright © 2021 Gizem Boskan. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target:self, action: #selector(addButtonTapped))
        
        navigationItem.title = "Sent Memes"
        
        setupCollectionUI(currentWidth: view.frame.size.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    // MARK: - Helpers
    
    private func setupCollectionUI(currentWidth: CGFloat) {
        let space:CGFloat = 3.0
        let dimensionWidth = (currentWidth - (2 * space)) / 3.0
        let dimensionHeight = dimensionWidth
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }
    @objc func addButtonTapped () {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "editor") as? UINavigationController {
            self.definesPresentationContext = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell 
        
        let meme = memes[(indexPath as NSIndexPath).item]
        cell.imageView?.image = meme.memedImage
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? MemeDetailViewController {
            let meme = memes[(indexPath as NSIndexPath).item]
            vc.selectedImage = meme.memedImage
            vc.selectedPictureNumber = indexPath.item + 1
            vc.totalPictures = memes.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
