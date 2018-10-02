//
//  FeedViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 10/1/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class FeedViewController: UIViewController, UITableViewDataSource{
    
    var window: UIWindow?
    var alertController: UIAlertController!
    
    @IBOutlet weak var tableView: UITableView!
    
    var refresher = UIRefreshControl()
    
    // arrays to hold server data
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [Date?]()
    var picArray = [PFFile]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    var followArray = [String]()
    var refreshControl: UIRefreshControl!
    // page size
    var page : Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // title at the top
        self.navigationItem.title = "FEED"
        
        // automatic row height - dynamic cell
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(FeedViewController.loadPosts), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
        // receive notification from postsCell if picture is liked, to update tableView
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
        
        // indicator's x(horizontal) center
        //indicator.center.x = tableView.center.x
        
        // receive notification from uploadVC
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.uploaded(_:)), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.didPullToRefresh(_:)), for: UIControl.Event.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        // calling function to load posts
        loadPosts()
        logOutAlert()
        
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl ) {
        loadPosts()
    }
    
    // cell numb
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    
    // cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        // connect objects with our information from arrays
        cell.username_Button.setTitle(usernameArray[indexPath.row], for: UIControl.State())
        cell.username_Button.sizeToFit()
        cell.uuidLabel.text = uuidArray[indexPath.row]
        cell.captionLabel.text = titleArray[indexPath.row]
        cell.captionLabel.sizeToFit()
        
        // place profile picture
        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            cell.avatarImage.image = UIImage(data: data!)
        }
        
        // place post picture
        picArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            cell.postImage.image = UIImage(data: data!)
        }
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
        // logic what to show: seconds, minuts, hours, days or weeks
        if difference.second! <= 0 {
            cell.dateLabel.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLabel.text = "\(String(describing: difference.second))s."
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLabel.text = "\(String(describing: difference.minute))m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLabel.text = "\(String(describing: difference.hour))h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLabel.text = "\(String(describing: difference.day))d."
        }
        if difference.weekOfMonth! > 0 {
            cell.dateLabel.text = "\(String(describing: difference.weekOfMonth))w."
        }
        
        
        // manipulate like button depending on did user like it or not
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.current()!.username!)
        didLike.whereKey("to", equalTo: cell.uuidLabel.text!)
        didLike.countObjectsInBackground { (count, error) -> Void in
            // if no any likes are found, else found likes
            if count == 0 {
                cell.likeButton.setTitle("unlike", for: UIControl.State())
                cell.likeButton.setBackgroundImage(UIImage(named: "unlike.png"), for: UIControl.State())
            } else {
                cell.likeButton.setTitle("like", for: UIControl.State())
                cell.likeButton.setBackgroundImage(UIImage(named: "like.png"), for: UIControl.State())
            }
        }
        
        // count total likes of shown post
        let countLikes = PFQuery(className: "likes")
        countLikes.whereKey("to", equalTo: cell.uuidLabel.text!)
        countLikes.countObjectsInBackground { (count, error) -> Void in
            cell.likeLabel.text = "\(count)"
        }
        
        
        // asign index
        cell.username_Button.layer.setValue(indexPath, forKey: "index")
        cell.commentButton.layer.setValue(indexPath, forKey: "index")
        cell.moreButton.layer.setValue(indexPath, forKey: "index")
        
        
        return cell
    }
    
    // refreshign function after like to update degit
    @objc func refresh() {
        tableView.reloadData()
    }
    
    // reloading func with posts  after received notification
    @objc func uploaded(_ notification:Notification) {
        loadPosts()
    }
    
    // scrolled down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }
    
    
    // load posts
    @objc func loadPosts() {
        let query = PFQuery(className: "posts")
        query.includeKey("username")
        query.order(byDescending: "_created_at")
        query.limit = self.page
        
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if error == nil {
                // clean up
                self.usernameArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.usernameArray.append(object.object(forKey: "username") as! String)
                    self.avaArray.append(object.object(forKey: "avatar") as! PFFile)
                    self.dateArray.append(object.createdAt)
                    self.picArray.append(object.object(forKey: "pic") as! PFFile)
                    self.titleArray.append(object.object(forKey: "title") as! String)
                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
                }
                
                // reload tableView & end spinning of refresher
                self.tableView.reloadData()
                self.refresher.endRefreshing()
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    // pagination
    func loadMore() {
        
        // if posts on the server are more than shown
        if page <= uuidArray.count {
            
            // start animating indicator
            // indicator.startAnimating()
            
            // increase page size to load +10 posts
            page = page + 10
            
            // STEP 1. Find posts realted to people who we are following
            let followQuery = PFQuery(className: "posts")
            followQuery.whereKey("follower", equalTo: PFUser.current()!.username!)
            followQuery.findObjectsInBackground (block: { (objects, error) -> Void in
                if error == nil {
                    
                    // clean up
                    self.followArray.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.followArray.append(object.object(forKey: "following") as! String)
                    }
                    
                    // append current user to see own posts in feed
                    self.followArray.append(PFUser.current()!.username!)
                    
                    // STEP 2. Find posts made by people appended to followArray
                    let query = PFQuery(className: "posts")
                    query.whereKey("username", containedIn: self.followArray)
                    query.limit = self.page
                    query.addDescendingOrder("createdAt")
                    query.findObjectsInBackground(block: { (objects, error) -> Void in
                        if error == nil {
                            
                            // clean up
                            self.usernameArray.removeAll(keepingCapacity: false)
                            self.avaArray.removeAll(keepingCapacity: false)
                            self.dateArray.removeAll(keepingCapacity: false)
                            self.picArray.removeAll(keepingCapacity: false)
                            self.titleArray.removeAll(keepingCapacity: false)
                            self.uuidArray.removeAll(keepingCapacity: false)
                            
                            // find related objects
                            for object in objects! {
                                self.usernameArray.append(object.object(forKey: "username") as! String)
                                self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                                self.dateArray.append(object.createdAt)
                                self.picArray.append(object.object(forKey: "pic") as! PFFile)
                                self.titleArray.append(object.object(forKey: "title") as! String)
                                self.uuidArray.append(object.object(forKey: "uuid") as! String)
                            }
                            
                            // reload tableView & stop animating indicator
                            self.tableView.reloadData()
                            //self.indicator.stopAnimating()
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                } else {
                    print(error!.localizedDescription)
                }
            })
            
        }
        
    }
    
    
    @IBAction func username_Button_Clicked(_ sender: Any) {
        // call index of button
        let i = (sender as AnyObject).layer.value(forKey: "index") as! IndexPath
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i) as! PostCell
        // if user tapped on himself go home
        if cell.username_Button.titleLabel?.text == PFUser.current()?.username {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    
    @IBAction func logOutBtn_Clicked(_ sender: Any) {
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
