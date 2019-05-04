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
    
    
    /*:
     # Returns the Parse name that should be used
     * Create new account
     */
    class func parseClassName() -> String {
        return "Post"
    }
    
    
    /*:
     # Post User Image
     * Get current user
     * Get post caption, like count, comments count, profile image and post image
     * Save in the background
     */
    class func postUserImage(profile: UIImage? = UIImage(named: "home"),image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        let post = Post()
        post.author = PFUser.current()!
        post.caption = caption!
        post.likesCount = 0
        post.commentsCount = 0
        post.avatarImg = getPFFileFromImage(image: profile)!
        post.postImage = getPFFileFromImage(image: image)!
        post.saveInBackground(block: completion)
    }
    
    
    /*:
     # Display Image
     * Retrieve image from database
     */
    class func displayPostImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        let post = Post()
        post.postImage = getPFFileFromImage(image: image)!
        post.author = PFUser.current()!
        post.saveInBackground(block: completion)
    }
    
    
    /*:
     # Get PFFile From Image
     * return PFFile
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
