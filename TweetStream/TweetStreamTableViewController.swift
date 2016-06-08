//
//  TweetStreamTableViewController.swift
//  TweetStream
//
//  Created by Mark Jeschke on 5/31/16.
//  Copyright © 2016 Mark Jeschke. All rights reserved.
//

import UIKit

class TweetStreamTableViewController: UITableViewController {
    
    // MARK: === Import External Classes ===
    
    let tweetCell = TweetCell()
    let twitterManager = TwitterManager()
    
    // MARK: === Set Empty imageCache dictionary ===
    
    var imageCache = [String:UIImage]()
    
    // MARK: === View Lifecyle ===

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detectNetworkConnection()
        
        // Register the NSNotification listeners that are triggered from other classes.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTweets), name: "reloadTweets", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.detectNetworkConnection), name: "detectNetworkConnection", object: nil)
        
        self.title = "@\(twitterManager.screenName)"
        
        self.tableView.estimatedRowHeight = 150;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    }
    
    // MARK: === Detect Network Connection ===
    
    func detectNetworkConnection() {
        if Reachability.isConnectedToNetwork() == true {
            twitterManager.getTimeline()
            print("Connection was successful")
        } else {
            failedConnectionAlert()
            print("Connection failed")
        }
    }
    
    // MARK: === Reload Tweets Table View ===
    
    func reloadTweets() {
        self.tableView.reloadData()
        print("Tweets table view was reloaded")
    }
    
    // MARK: === Failed Connection Alert ===
    
    func failedConnectionAlert() {
        let alertController = UIAlertController(title: nil, message: "Can't connect to the internet. Please make sure that your data or Wi-Fi connection is enabled.", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: === TableView Data Source ===
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitterManager.dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Custom TableViewCell.
        let ResultCellIdentifier = "ResultCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ResultCellIdentifier) as! TweetCell
        
        // Extract data for each cell.
        let tweet = twitterManager.dataSource[indexPath.row] as! NSDictionary
        let userNameDict = tweet.objectForKey("user") as! NSDictionary
        let twitterName = userNameDict.objectForKey("name") as! String
        let screenName = userNameDict.objectForKey("screen_name") as! String
        let profileImage = userNameDict.objectForKey("profile_image_url") as! String
        
        // Display the Tweets for each cell property.
        cell.twitterNameLabel!.text = twitterName
        cell.screenNameLabel!.text = "@\(screenName)"
        cell.textMessageLabel!.text = tweet.objectForKey("text") as? String
        
        /// Remove '_normal' from picture url to get the full size image.
        let replaced = profileImage.stringByReplacingOccurrencesOfString("_normal", withString: "")
        let imgURL: NSURL = NSURL(string: replaced)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if (error == nil && data != nil) {
                func display_image() {
                    cell.profileImage!.image = UIImage(data: data!)
                }
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
        }
        
        task.resume()
        
        return cell
    }
    
    // MARK: === Alternate Table View Cell Row Colors ===
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
    }

}
