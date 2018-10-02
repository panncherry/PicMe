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
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var username_Button: UIButton!
    
    //buttons
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    //main post image
    @IBOutlet weak var postImage: PFImageView!
    
    //labels
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var uuidLabel: UILabel!
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
