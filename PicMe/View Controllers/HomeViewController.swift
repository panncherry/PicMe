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
    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        logOutAlert()
    }
  
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.present(self.alertController, animated: true)
                print("Successful loggout")
                //self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)

            }
        })
    }
    
    func logOutAlert() {
        alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logoutButton = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(logoutButton)
        alertController.addAction(cancelButton)
    }
}
