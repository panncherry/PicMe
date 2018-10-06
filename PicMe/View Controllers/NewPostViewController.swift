//
//  NewPostViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Photos
import Parse
import MBProgressHUD

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var publishBtn: UIButton!
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImage.image = UIImage(named: "pbg.jpg")
    }
    
    @IBAction func postButton_Clicked(_ sender: Any) {
        print("Post button pressed")
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Post.postUserImage(image: resize(image: postImage.image!, newSize: CGSize(width: 300, height: 300)), withCaption: postTextField.text ?? "") { (success: Bool, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                self.tabBarController?.selectedIndex = 0
                self.postTextField.text = ""
                self.postImage.image = UIImage(named: "pbg.jpg")
                print("Successfully save data.")
            }
            else {
                let alert = UIAlertController(title: "An Error Occurred", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.show(alert, sender: nil)
            }}}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = resize(image: originalImage, newSize: CGSize(width: 640, height: 640))
        self.postImage.image = editedImage
        print("Image set")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func openCamera(_ sender: Any) {
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
    }
    
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerController.SourceType.photoLibrary
        print("Open photo library.")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onTappedDismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height:newSize.height)))
        resizeImageView.contentMode = UIView.ContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}
        

