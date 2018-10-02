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
        let postData = PFObject(className: "Post")
        
        if let currentUser = PFUser.current() {
            postData["author"] = currentUser
        }
        postData["caption"] = postTextField.text ?? ""
        postData["postImage"] = postImage.image ?? ""
        
        postData.saveInBackground { (success, error) in
            if success {
                print("Post data sent successfully.")
                self.postTextField.text = ""
            } else if let error = error {
                print("Problem saving post data: \(error.localizedDescription)")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = resize(image: originalImage, newSize: CGSize(width: 640, height: 640))
        self.postImage.image = editedImage
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
