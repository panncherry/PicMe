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
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper.jpg")!)
        
        userNameField.attributedPlaceholder = NSAttributedString(string: "username",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        label.font = UIFont(name: "Pacifico", size: 60)
        label2.font = UIFont(name: "Pacifico", size: 20)
    }
    
    
    /*:
     # Sign In
     * Check user creditials
     * Display log in error alert if user name is empty
     * If user is not empty, perform segue and show FeedViewController
     */
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
    
    
    /*:
     # Log In Error Alert
     * Notify using action sheet for error
     * Clear username and password textfileds, so that user can enter again
     */
    func loginErrorAlert(){
        let alert = UIAlertController(title: "Login Error", message: "Hmm..something went wrong. or Username/Email is missing.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        userNameField.text = ""
        passwordField.text = ""
    }
    
    
    /*:
     # Dismiss Keyboard
     * Dismiss the keyboard on tapping anywhere on the screen
     */
    @IBAction func onTapDismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
}
