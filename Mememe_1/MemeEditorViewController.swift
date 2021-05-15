//
//  ViewController.swift
//  Mememe_1
//
//  Created by Gizem Boskan on 23.04.2021.
//  Copyright © 2021 Gizem Boskan. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var memes = [Meme]()
    var cameraButton: UIBarButtonItem!
    var albumButton: UIBarButtonItem!
    var memedImage: UIImage? = nil
    
    // MARK: - UI Components
    
    @IBOutlet var textFieldTop: UITextField!
    @IBOutlet var textFieldBottom: UITextField!
    @IBOutlet var imagePickerView: UIImageView!
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShareButton()
        setupCancelButton()
        setupToolbarButtons()
        setupTextfields(textField: textFieldTop)
        setupTextfields(textField: textFieldBottom)
        setDefaultState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Helpers
    @objc func cancelTapped(){
        
        if (storyboard?.instantiateViewController(withIdentifier: "SentMemes") as? MemeTableViewController) != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func shareTapped (){
        memedImage = generateMemedImage()
        guard let memedImage = memedImage else { return }
        
        let vc = UIActivityViewController(activityItems: [memedImage,"Share this great meme with your loved ones! :)\n Or just save!"] , applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
        
        vc.completionWithItemsHandler = {(_, completed, _, _) in
            if !completed {
                return
            }
            // User completed activity
            self.save()
            vc.dismiss(animated: true, completion: nil)
        }
        
    }
    func save() {
        // Create the meme
        if let memedImage = memedImage {
            let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
            
            // Add it to the memes array on the Application Delegate
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        }
    }
    func generateMemedImage() -> UIImage {
        
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        return memedImage
        
    }
    private func pickImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func pickAnImageFromAlbum(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    @objc func pickAnImageFromCamera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldBottom.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keybordWillHide(_ notification:Notification) {
        if textFieldBottom.isFirstResponder && view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
    
    @objc func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupShareButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    private func setupCancelButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }
    
    private func setupToolbarButtons() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(pickAnImageFromCamera))
        
        albumButton = UIBarButtonItem(title: "Album", style: .plain , target: self, action: #selector(pickAnImageFromAlbum))
        
        toolbarItems = [spacer, cameraButton, spacer, albumButton, spacer]
        navigationController?.isToolbarHidden = false
    }
    
    private func setupTextfields(textField: UITextField) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -2.0
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    private func setDefaultState() {
        setDefaultTextfields()
        setDefaultImagePicker()
        setDefaultShareButton()
        navigationItem.title = "Meme Editor! :) "
    }
    
    private func setDefaultTextfields() {
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
    }
    
    private func setDefaultImagePicker() {
        imagePickerView.image = nil
    }
    
    private func setDefaultShareButton() {
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
}

// MARK: - Image Picker Controller Delegate
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        imagePickerView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        setDefaultTextfields()
        navigationItem.leftBarButtonItem?.isEnabled = true
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
}

// MARK: - Text Field Delegate
extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

