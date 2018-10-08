//
//  ProfileHeaderView.swift
//  PicMe
//
//  Created by Pann Cherry on 9/30/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import ParseUI

class ProfileHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var avatarImg: PFImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var websiteTextField: UITextView!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var postsTitleLabel: UILabel!
    @IBOutlet weak var followersTitileLabel: UILabel!
    @IBOutlet weak var followingTitileLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        
        avatarImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
        
        posts.frame = CGRect(x: width / 2.5, y: avatarImg.frame.origin.y, width: 50, height: 30)
        followers.frame = CGRect(x: width / 1.7, y: avatarImg.frame.origin.y, width: 50, height: 30)
        following.frame = CGRect(x: width / 1.25, y: avatarImg.frame.origin.y, width: 50, height: 30)
        
        postsTitleLabel.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
        followersTitileLabel.center = CGPoint(x: followers.center.x, y: followers.center.y + 20)
        followingTitileLabel.center = CGPoint(x: following.center.x, y: following.center.y + 20)
        
        button.frame = CGRect(x: postsTitleLabel.frame.origin.x, y: postsTitleLabel.center.y + 20, width: width - postsTitleLabel.frame.origin.x - 10, height: 30)
        button.layer.cornerRadius = button.frame.size.width / 50
        
        fullNameLabel.frame = CGRect(x: avatarImg.frame.origin.x, y: avatarImg.frame.origin.y + avatarImg.frame.size.height, width: width - 30, height: 30)
        websiteTextField.frame = CGRect(x: avatarImg.frame.origin.x - 5, y: fullNameLabel.frame.origin.y + 15, width: width - 30, height: 30)
        bioLabel.frame = CGRect(x: avatarImg.frame.origin.x, y: websiteTextField.frame.origin.y + 30, width: width - 30, height: 30)
        
        // round ava
        avatarImg.layer.cornerRadius = avatarImg.frame.size.width / 2
        avatarImg.clipsToBounds = true
    }
}
