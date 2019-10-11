//
//  DetailViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 10/8/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import ParseUI

class DetailViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: Properties
    var imageFile: PFFile?
    var posts: PFObject?
    var date: String?
    var caption: String?
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        postImage.file = imageFile
        postImage.loadInBackground()
        dateLabel.text = date
        captionLabel.text = caption
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "Like")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationItem.title = "Back to New Feed"
    }
    
    // MARK: IBActions
    @IBAction func backButton(_ sender: Any) {
        self.view.window!.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
}
