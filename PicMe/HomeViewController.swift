//
//  HomeViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/26/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController{
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful loggout")
                
                // Load and show the login view controller
               /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
                self.window?.rootViewController = loginViewController*/
                self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)

            }
        })
    }
}
