//
//  resetPasswordViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/30/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse

class resetPasswordViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.font = UIFont(name: "Pacifico", size: 60)
        label2.font = UIFont(name: "Pacifico", size: 20)
    }
    
    @IBAction func resetBtn_clicked(_ sender: Any) {
        self.view.endEditing(true)
        if (emailField.text!.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "Email address is required.", preferredStyle: UIAlertController.Style.alert)
            let okay = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        
        PFUser.requestPasswordResetForEmail(inBackground: emailField.text!) { (success: Bool, error: Error?) in
            if success {
                let alert = UIAlertController(title: "Email for resetting password", message: "has been sent to provided email.", preferredStyle: UIAlertController.Style.alert)
                let okay = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription )
            }
        }
}
    
    
    @IBAction func cancelBtn_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
