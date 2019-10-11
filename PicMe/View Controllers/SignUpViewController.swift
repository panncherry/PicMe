//
//  SignUpViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse
import Photos

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var window: UIWindow?
    
    // MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    // MARK: Properties
    //reset default size
    var scrollViewHeight: CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the scrollView frame size to device width and height
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //round the corner of avater image
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width/2
        avatarImg.clipsToBounds = true
        
        //declare selecte image tap
        let avatarImageTap = UITapGestureRecognizer(target: self, action: #selector(loadImage(recognizer:)))
        avatarImageTap.numberOfTapsRequired = 1
        avatarImg.isUserInteractionEnabled = true
        avatarImg.addGestureRecognizer(avatarImageTap)
    }
    
    
    // MARK: - IBActions
    @IBAction func closeButton(_ sender: Any) {
        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil) // Dimiss the current viewController when click on close button
    }
    
    @IBAction func createAccount(_ sender: Any) {
        print("create account pressed")
        
        // If user enter empty
        if(userNameField.text!.isEmpty || passwordField.text!.isEmpty || repeatPasswordField.text!.isEmpty || emailField.text!.isEmpty || fullnameField.text!.isEmpty || bioTextField.text!.isEmpty || websiteTextField.text!.isEmpty){
            displayAlert(title: "Error", message: "All fields are required")
        }
        
        // If password doesn't match
        if passwordField.text != repeatPasswordField.text {
            displayAlert(title: "Error", message: "Password does not match")
            clearTextFields()
        }
        
        // Send data to server
        let newUser = PFUser()
        newUser.username = userNameField.text?.lowercased()
        newUser.password = passwordField.text
        newUser.email = emailField.text?.lowercased()
        newUser["fullname"] = fullnameField.text?.lowercased()
        newUser["bio"] = bioTextField.text
        newUser["website"] = websiteTextField.text?.lowercased()
        
        // Will be assigned in Edit Profile
        newUser["telephone"] = ""
        newUser["gender"] = ""
        
        // Compress the image and send to server
        let data = avatarImg.image!.jpegData(compressionQuality: 0.5)
        let avatarFile = PFFile(name: "avatar.jpg", data: data!)
        newUser["avatar"] = avatarFile
        
        // Save data in server
        newUser.signUpInBackground{(success: Bool
            , error: Error?) in
            if success {
                print("Created a new user!!")
                //remember logged user in app memory
                UserDefaults.standard.set(newUser.username, forKey: "username")
                UserDefaults.standard.synchronize()
                self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                
            } else {
                print(error?.localizedDescription as Any)
                if error?._code == 200 {
                    print("Bad or missing username.")
                    self.alert()
                }
                if error?._code == 201 {
                    print("Password is required.")
                    self.passwordRequiredAlert()
                }
                if error?._code == 202 {
                    print("User name is already taken!")
                    self.userTakenAlert()
                }
                if error?._code == 203 {
                    print("Account already exists for this email address.")
                    self.userTakenAlert()
                }
            }
        }
    }
    
    //dismiss keyboard on tap
    @IBAction func onTapDismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - Helper Functions
    //Show Keyboard
    @objc func showKeyboard(notification: NSNotification){
        keyboard = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    // Hide Keyboard
    @objc func hideKeyboard(notification: NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    func alert(){
        displayAlert(title: "Error", message: "Bad or missing username.")
        clearTextFields()
    }
    
    func userTakenAlert(){
        displayAlert(title: "Error", message: "Username is already taken. OR Account already exists for this email address.")
        clearTextFields()
    }
    
    func passwordRequiredAlert(){
        displayAlert(title: "Error", message: "Password is required.")
        clearTextFields()
    }
    
    func accountExistAlert(){
        displayAlert(title: "Error", message: "Account already exists for this email address.")
        clearTextFields()
    }
    
    func newUserCreatedAlert(){
        displayAlert(title: "Congratulations!!!", message: "Your account is created.")
        clearTextFields()
    }
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func clearTextFields() {
        userNameField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
        fullnameField.text = ""
        bioTextField.text = ""
        websiteTextField.text = ""
        emailField.text = ""
    }
    
    //call imagePicker to select image
    @objc private func loadImage(recognizer:UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            imagePicker.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //connect selected image to our imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = resize(image: originalImage, newSize: CGSize(width: 128, height: 128))
        self.avatarImg.image = editedImage
        dismiss(animated: true, completion: nil)
    }
    
    private func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIView.ContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
