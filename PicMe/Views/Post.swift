//
//  Post.swift
//  PicMe
//
//  Created by Pann Cherry on 10/1/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import Parse

class Post: PFObject, PFSubclassing {

    @NSManaged var avatarImg : PFFile
    @NSManaged var postImage : PFFile
    @NSManaged var author: PFUser
    @NSManaged var caption: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    @NSManaged var date: String
    
    //returns the Parse name that should be used
    class func parseClassName() -> String {
        return "Post"
    }
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        let post = Post()
        post.author = PFUser.current()!
        post.caption = caption!
        post.likesCount = 0
        post.commentsCount = 0
        post.postImage = getPFFileFromImage(image: image)!
        post.saveInBackground(block: completion)
    }
    
    /*class func displayUseImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        let post = Post()
        post.postImage = getPFFileFromImage(image: image)!
        post.author = PFUser.current()!
        post.saveInBackground(block: completion)
    }
        */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = image.pngData() {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
}
