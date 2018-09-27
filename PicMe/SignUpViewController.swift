//
//  SignUpViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    var window: UIWindow?
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var reTypePasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        newUser.email = emailField.text

        newUser.signUpInBackground{(success: Bool
            , error: Error?) in
            if success {
                print("Created a new user!!")
                //self.performSegue(withIdentifier: "logInSegue", sender: nil)
                self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                self.newUserCreatedAlert(title: "Congrats!", message: "Created a new user.")
                
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
        emailField.text = ""
    }
    
    func userTakenAlert(title: String, message: String){
        let alert = UIAlertController(title: "Error", message: "Username is already taken. OR Account already exists for this email address.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        emailField.text = ""
    }
    
    func passwordRequiredAlert(title: String, message: String){
        let alert = UIAlertController(title: "Error", message: "Password is required.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        emailField.text = ""
    }
    
    func accountExistAlert(title: String, message: String){
        let alert = UIAlertController(title: "Error", message: "Account already exists for this email address.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        emailField.text = ""
    }
    
    func newUserCreatedAlert(title: String, message: String){
        let alert = UIAlertController(title: "Congratulations!!!", message: "Your account is created.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
        emailField.text = ""
    }
  
    @IBAction func onTapDismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
}
