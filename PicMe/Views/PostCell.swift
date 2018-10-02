//
//  PostCell.swift
//  PicMe
//
//  Created by Pann Cherry on 9/30/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import ParseUI

class PostCell: UITableViewCell {
    //user profile image and name
    @IBOutlet weak var avatarImg: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    //buttons
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    //main post image
    @IBOutlet weak var postImage: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    //labels
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImg.clipsToBounds = true
        avatarImg.layer.cornerRadius = 15
        avatarImg.layer.borderColor = #colorLiteral(red: 0.8831892449, green: 0.8831892449, blue: 0.8831892449, alpha: 0.7984535531)
        avatarImg.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
