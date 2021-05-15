//
//  MemeDetailViewController.swift
//  Mememe_1
//
//  Created by Gizem Boskan on 5.05.2021.
//  Copyright © 2021 Gizem Boskan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: - Properties
    var memes = [Meme]()
    @IBOutlet var memeImageView: UIImageView!
    var selectedImage: UIImage?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(selectedPictureNumber) of \(totalPictures)"
        if let imageToLoad = selectedImage {
            memeImageView.image = imageToLoad
        }
        memeImageView.layer.borderWidth = 1
        memeImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBarStatus(status: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupBarStatus(status: false)
        
    }
    // MARK: - Helpers
    private func setupBarStatus(status: Bool){
        tabBarController?.tabBar.isHidden = status
        navigationController?.hidesBarsOnTap = status
    }
}
