//
//  SignUpViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse

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
    

    //show the keyboard
    @objc func showKeyboard(notification: NSNotification){
        keyboard = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    //hide the keyboard
    @objc func hideKeyboard(notification: NSNotification){
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    //dismiss the current viewController when click on close button
    @IBAction func closeButton(_ sender: Any) {
        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        print("create account pressed")
        
        //if user enter empty
        if(userNameField.text!.isEmpty || passwordField.text!.isEmpty || repeatPasswordField.text!.isEmpty || emailField.text!.isEmpty || fullnameField.text!.isEmpty || bioTextField.text!.isEmpty || websiteTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Invalid Entry", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
            let okay = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        
        //if password doesn't match
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
        
        //send data to server
        let newUser = PFUser()
        newUser.username = userNameField.text?.lowercased()
        newUser.password = passwordField.text
        newUser.email = emailField.text?.lowercased()
        newUser["fullname"] = fullnameField.text?.lowercased()
        newUser["bio"] = bioTextField.text
        newUser["website"] = websiteTextField.text?.lowercased()
        
        //will be assigned in Edit Profile
        newUser["telephone"] = ""
        newUser["gender"] = ""
        
        //compress the image and send to server
        let data = avatarImg.image!.jpegData(compressionQuality: 0.5)
        let avatarFile = PFFile(name: "avatar.jpg", data: data!)
        newUser["avatar"] = avatarFile
        
        //save data in server
        newUser.signUpInBackground{(success: Bool
            , error: Error?) in
            if success {
                print("Created a new user!!")
                //self.performSegue(withIdentifier: "logInSegue", sender: nil)
                //remember logged user in app memory
                UserDefaults.standard.set(newUser.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                //call login function from AppDelegate
               // let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
               // appDelegate.logIn()
                
               // self.newUserCreatedAlert(title: "Congrats!", message: "Created a new user.")

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
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)

    }
    
    //connect selected image to our imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        avatarImg.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
}
