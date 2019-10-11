//
//  ProfileViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 9/30/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UICollectionViewController {
    
    // MARK: Properties
    var array: [PFObject] = []
    
    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
       //collectionView.backgroundColor = .white
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath as IndexPath) as! ProfileHeaderView
     
        header.fullNameLabel.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.websiteTextField.text = PFUser.current()?.object(forKey: "website") as? String
        header.websiteTextField.sizeToFit()
        header.bioLabel.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLabel.sizeToFit()
        header.button.setTitle("Edit Profile", for: UIControl.State.normal)
        
        let profileQuery = PFUser.current()?.object(forKey: "avatar") as! PFFile
        profileQuery.getDataInBackground { (data:Data?, error:Error?) in
            header.avatarImg.image = UIImage(data: data!)
        }
        return header
    }

}
