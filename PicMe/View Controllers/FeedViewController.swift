//
//  FeedViewController.swift
//  PicMe
//
//  Created by Pann Cherry on 10/1/18.
//  Copyright © 2018 Pann Cherry. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    var refreshControl: UIRefreshControl!
    var window: UIWindow?
    var alertController: UIAlertController!
    var array: [PFObject] = []
    var isZooming = false
    var originalImageCenter:CGPoint?
    var page : Int = 0
    var offset : Int = 20
    var isMoreDataLoading = false
    
    var loadingMoreView: InfiniteScrollActivityView!
    
   // @IBOutlet weak var showActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Feed"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
       // tableView.rowHeight = 650
        
        refreshControl = UIRefreshControl()
        tableView.insertSubview(refreshControl, at: 0)
        
        refreshControl.addTarget(self, action: #selector(FeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        
       
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView.isHidden = true
        tableView.addSubview(loadingMoreView)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        //MBProgressHUD.showAdded(to: self.view, animated: true)

        refreshScreen()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshScreen), userInfo: nil, repeats: true)
        
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
        cell.avatarImg.file = posts["avatarImg"] as? PFFile
        cell.postImage.file = posts["postImage"] as? PFFile
        cell.avatarImg.loadInBackground()
        cell.postImage.loadInBackground()
        cell.captionLabel.text = posts["caption"] as? String
        
        let date = posts.createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a" //Input Format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let stringDate = dateFormatter.string(from: date!)
        let currentDate = self.UTCToLocal(UTCDateString: stringDate)
        
        cell.dateLabel.text = currentDate as? String
        return cell
    }
    
    @objc func refreshScreen() {
        tableView.reloadData()
        fetchPosts()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl ) {
        fetchPosts()
    }
    
    func fetchPosts() {
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKey("author")
        
        query?.findObjectsInBackground { (allPosts, error) in
            if error == nil {
                if let posts = allPosts {
                    self.array.removeAll()
                    for post in posts {
                        self.array.append(post)
                        //print("Posts are showing the new feed now.")
                    }
                }
            } else {
                print("Problem fetching posts: \(error?.localizedDescription)")
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a" //Input Format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm:ss a" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let posts = array[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.posts = posts
            detailViewController.imageFile = posts["postImage"] as? PFFile
            detailViewController.caption = posts["caption"] as? String
            let date = posts.createdAt
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss a" //Input Format
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let stringDate = dateFormatter.string(from: date!)
            let currentDate = self.UTCToLocal(UTCDateString: stringDate)
            detailViewController.date = currentDate as? String
         
        }
    }
    
    //code to customize navigation bar
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "camera-1")
        imageView.image = image
        navigationItem.titleView = imageView
        navigationItem.title = "Back to New Feed"
    }
}
