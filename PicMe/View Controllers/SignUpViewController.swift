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
    
    
    //reset default size
    var scrollViewHeight: CGFloat = 0
    
    //keyboard frame size
    var keyboard = CGRect()
    
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
    

    /*:
     # Show Keyboard
     */
    @objc func showKeyboard(notification: NSNotification){
        keyboard = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    /*:
     # Hide Keyboard
     */
    @objc func hideKeyboard(notification: NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    
    /*:
     # Close Button
     * Dimiss the current viewController when click on close button
     */
    @IBAction func closeButton(_ sender: Any) {
        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    /*:
     # Sign up button
     * Create new account
     * If username, password, repeat passord, email, fullname, bio, and website textfields are empty
     * Display alert sheet "Invalid entry"
     */
    @IBAction func createAccount(_ sender: Any) {
        print("create account pressed")
        
        // If user enter empty
        if(userNameField.text!.isEmpty || passwordField.text!.isEmpty || repeatPasswordField.text!.isEmpty || emailField.text!.isEmpty || fullnameField.text!.isEmpty || bioTextField.text!.isEmpty || websiteTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Invalid Entry", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
            let okay = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        
        // If password doesn't match
        if passwordField.text != repeatPasswordField.text {
            let alert = UIAlertController(title: "Password", message: "Password does not match.", preferredStyle: UIAlertController.Style.alert)
            let okay = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
            passwordField.text = ""
            repeatPasswordField.text = ""
            fullnameField.text = ""
            bioTextField.text = ""
            websiteTextField.text = ""
            emailField.text = ""
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
                    self.alert(title: "Error", message: "Bad or missing username.")
                }
                if error?._code == 201 {
                    print("Password is required.")
                    self.passwordRequiredAlert(title: "Error", message: "Password is required")
                }
                if error?._code == 202 {
                    print("User name is already taken!")
                    self.userTakenAlert(title: "Error", message: "Username is already taken. or Account already exists for this email address.")
                }
                if error?._code == 203 {
                    print("Account already exists for this email address.")
                    self.userTakenAlert(title: "Error", message: "Account already exists for this email address.")
                }
            }
        }
    }
    
    
    /*:
     # Bad or Missing username Alert
     * Show alert if username is missing or wrong.
     * Clear textFields
     */
    func alert(title: String, message: String){
        let alert = UIAlertController(title: "Error", message: "Bad or missing username.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
        fullnameField.text = ""
        bioTextField.text = ""
        websiteTextField.text = ""
        emailField.text = ""
    }
    
    
    /*:
     # User Taken Alert
     * Display message, "username is already taken"
     * Clear text fields
     */
    func userTakenAlert(title: String, message: String){
        let alert = UIAlertController(title: "Error", message: "Username is already taken. OR Account already exists for this email address.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
        fullnameField.text = ""
        bioTextField.text = ""
        websiteTextField.text = ""
        emailField.text = ""
    }
    
    
    /*:
     # Password Required Alert
     * Display alert message, "Password is required"
     * Clear text fields
     */
    func passwordRequiredAlert(title: String, message: String){
        let alert = UIAlertController(title: "Error", message: "Password is required.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
        fullnameField.text = ""
        bioTextField.text = ""
        websiteTextField.text = ""
        emailField.text = ""
    }
    
    
    /*:
     # Account Already Exist Alter
     * Create new account
     */
    func accountExistAlert(title: String, message: String){
        let alert = UIAlertController(title: "Error", message: "Account already exists for this email address.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
        fullnameField.text = ""
        bioTextField.text = ""
        websiteTextField.text = ""
        emailField.text = ""
    }
    
    func newUserCreatedAlert(title: String, message: String){
        let alert = UIAlertController(title: "Congratulations!!!", message: "Your account is created.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        repeatPasswordField.text = ""
        fullnameField.text = ""
        bioTextField.text = ""
        websiteTextField.text = ""
        emailField.text = ""
    }
  
    //dismiss keyboard on tap
    @IBAction func onTapDismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    //call imagePicker to select image
    @objc func loadImage(recognizer:UITapGestureRecognizer) {
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
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
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
