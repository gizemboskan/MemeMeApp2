//
//  MemeTableViewController.swift
//  Mememe_1
//
//  Created by Gizem Boskan on 4.05.2021.
//  Copyright © 2021 Gizem Boskan. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var memes : [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target:self, action: #selector(addButtonTapped))
        
        navigationItem.title = "Sent Memes"
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    // MARK: - Helpers
    
    @objc func addButtonTapped () {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "editor") as? UINavigationController {
            self.definesPresentationContext = true
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meme", for: indexPath)
        
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage
        
        cell.imageView?.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? MemeDetailViewController {
            let meme = memes[(indexPath as NSIndexPath).row]
            vc.selectedImage = meme.memedImage
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = memes.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


