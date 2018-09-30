//
//  NewPostViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Photos

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickedView: UIImageView!
    
    @IBOutlet weak var postTextField: UITextField!
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        let isEditied = true
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        if isEditied{
            imagePickedView.image = editedImage
        } else {
            imagePickedView.image = originalImage
        }
        print("image set")
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        //let vc = UIImagePickerController()
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
        //let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerController.SourceType.photoLibrary
        print("Open photo library.")
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onTappedDismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func postImage(_ sender: Any) {
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
