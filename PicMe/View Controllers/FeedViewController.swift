//
//  FeedViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 10/1/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import NotificationCenter
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    var refreshControl: UIRefreshControl!
    var window: UIWindow?
    var alertController: UIAlertController!
    
    // arrays to hold server data
    var array: [PFObject] = []
    var page : Int = 0
    var offset : Int = 20
    var isMoreDataLoading = false
    
    var loadingMoreView: InfiniteScrollActivityView!
    
   // @IBOutlet weak var showActivity: UIActivityIndicatorView!
    
    let query = Post.query()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Feed"

        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView.isHidden = true
        tableView.addSubview(loadingMoreView)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        fetchPosts()
        logOutAlert()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let posts = array[indexPath.row]
        let user = posts["author"] as? PFUser
        cell.usernameLabel.text = user?.username
        cell.avatarImg.image = posts["avatarImg"] as? UIImage
        cell.postImage.image = posts["postImg"] as? UIImage
        cell.captionLabel.text = posts["caption"] as? String
        cell.dateLabel.text = posts["createAt"] as? String
        return cell
    }
    
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl ) {
        fetchPosts()
    }
    
    // refreshign function after like to update degit
    @objc func refresh() {
        tableView.reloadData()
    }
    
    // fetch posts
    func fetchPosts(){
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.includeKey("author")
        
        query.findObjectsInBackground(){
            (posts: [PFObject]?, error: Error?) in
            if error == nil {
                if let newfeed = posts {
                    self.array = newfeed
                }
            } else {
                print("Problem fetching posts: \(error!.localizedDescription)")
            }
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
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
