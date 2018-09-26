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

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: userNameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("You are logged in.")
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
            
        }
    }
    
    
    @IBAction func OnSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = userNameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackground{(success: Bool
            , error: Error?) in
            if success {
                print("Created a new user!!")
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
                if error?._code == 202 {
                    print("User name is already taken!")
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
