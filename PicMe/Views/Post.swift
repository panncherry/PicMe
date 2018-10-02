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

    @NSManaged var imagePickedView : PFFile
    @NSManaged var user: PFUser
    @NSManaged var title: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    
    //returns the Parse name that should be used
    class func parseClassName() -> String {
        return "Post"
    }
    
    class func postUserImage(image: UIImage?, withCaption title: String?, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let post = Post()
        post.imagePickedView = getPFFileFromImage(image: image)!
        post.user = PFUser.current()!
        post.title = title!
        post.saveInBackground(block: completion)
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                return PFFile(name: "image.jpeg", data: imageData)
            }
        }
        return nil
    }
}
