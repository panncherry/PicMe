//
//  NewPostViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Photos
import MBProgressHUD
import Parse

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickedView: UIImageView!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickedView.image = UIImage(named: "pbg.jpg")
        vc.delegate = self
    }

    
    @IBAction func postButton_Clicked(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Post.postUserImage(image: imagePickedView.image, withCaption: postTextField.text) { (success, error) in
            print("File sent")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    // zooming in / out function
    func zoomImg() {
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        // if picture is unzoomed, zoom it
        if imagePickedView.frame == unzoomed {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.imagePickedView.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .black
                self.postTextField.alpha = 0
                self.publishBtn.alpha = 0
                self.removeBtn.alpha = 0
            })
            
            // to unzoom
        } else {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.imagePickedView.frame = unzoomed
                // unhide objects from background
                self.view.backgroundColor = .white
                self.postTextField.alpha = 1
                self.publishBtn.alpha = 1
                self.removeBtn.alpha = 1
            })
        }
    }
    
    // alignment
    func alignment() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        imagePickedView.frame = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        postTextField.frame = CGRect(x: imagePickedView.frame.size.width + 25, y: imagePickedView.frame.origin.y, width: width / 1.488, height: imagePickedView.frame.size.height)
        publishBtn.frame = CGRect(x: 0, y: height / 1.09, width: width, height: width / 8)
        removeBtn.frame = CGRect(x: imagePickedView.frame.origin.x, y: imagePickedView.frame.origin.y + imagePickedView.frame.size.height, width: imagePickedView.frame.size.width, height: 20)
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        // Do something with the images (based on your use case)
        imagePickedView.image = editedImage
     
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
