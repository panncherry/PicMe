//
//  LogInViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIView()
        
    }
    
    // MARK: - IBActions
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: userNameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user == nil {
                print("Username/email is required.")
                self.loginErrorAlert()
            }
            if user != nil {
                print("You are logged in.")
                self.userNameField.text = ""
                self.passwordField.text = ""
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
        }
    }
    
    // Dismiss Keyboard
    @IBAction func onTapDismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    // MARK: - Helper Functions
    private func setUpUIView() {
        label.font = UIFont(name: "Pacifico", size: 60)
        label2.font = UIFont(name: "Pacifico", size: 20)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper.jpg")!)
        userNameField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        userNameField.layer.cornerRadius = 15.0
        userNameField.layer.borderWidth = 2.0
        userNameField.layer.borderColor = UIColor.red.cgColor
        userNameField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.layer.cornerRadius = 15.0
        passwordField.layer.borderWidth = 2.0
        passwordField.layer.borderColor = UIColor.red.cgColor
        passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
    }
    
    func loginErrorAlert(){
        let alert = UIAlertController(title: "Login Error", message: "Hmm..something went wrong. or Username/Email is missing.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
    }
    
}
