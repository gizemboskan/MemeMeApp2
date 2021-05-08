//
//  MemeDetailViewController.swift
//  Mememe_1
//
//  Created by Gizem Boskan on 5.05.2021.
//  Copyright © 2021 Gizem Boskan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memes = [Meme]()
    @IBOutlet var memeImageView: UIImageView!
    var selectedImage: UIImage?
    var selectedPictureNumber = 0
    var totalPictures = 0
    
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
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.hidesBarsOnTap = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnTap = false
    }
    
    //  memeImageView.image
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
