//
//  TwitterManager.swift
//  TweetStream
//
//  Created by Mark Jeschke on 5/27/16.
//  Copyright © 2016 Mark Jeschke. All rights reserved.
//

import Foundation
import Social
import Accounts

class TwitterManager {
    
    // MARK: === Set Variables ===
    
    var screenName:String = "StarWars"
    var tweetCount:Int = 20
    var dataSource = [AnyObject]()
    
    // MARK: === Get Timeline Stream of Screen Name User ===
        
    func getTimeline() {
        
        let account = ACAccountStore()
        
        let accountType = account.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil,
            completion: {(success: Bool, error: NSError!) -> Void in
                
            if success {
                let arrayOfAccounts = account.accountsWithAccountType(accountType)
                
                if arrayOfAccounts.count > 0 {
                    let twitterAccount = arrayOfAccounts.last as! ACAccount
                    
                    let requestURL = NSURL(string:
                        "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(self.screenName)&count=\(self.tweetCount)")
                    
                    let postRequest = SLRequest(forServiceType:
                        SLServiceTypeTwitter,
                        requestMethod: SLRequestMethod.GET,
                        URL: requestURL,
                        parameters: nil)
                    
                    postRequest.account = twitterAccount
                    
                    postRequest.performRequestWithHandler({(
                        responseData: NSData!,
                        urlResponse: NSHTTPURLResponse!,
                        error: NSError!) -> Void in
                        let err = NSError.self
                        do {
                            try self.dataSource = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves) as! [AnyObject]
                        } catch {
                            print(err)
                        }
                        
                        if self.dataSource.count != 0 {
                            dispatch_async(dispatch_get_main_queue()) {
                                // Notify the TweetResultsTableViewController that the data is ready to be displayed, so reload the Tweets Table View.
                                NSNotificationCenter.defaultCenter().postNotificationName("reloadTweets", object: self)
                            }
                        }
                    })
                }
            } else {
                print("Failed to access account")
            }
        })
    }
    
}
