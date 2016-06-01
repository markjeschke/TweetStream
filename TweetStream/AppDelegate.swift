//
//  AppDelegate.swift
//  TweetStream
//
//  Created by Mark Jeschke on 5/27/16.
//  Copyright © 2016 Mark Jeschke. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("detectNetworkConnection", object: self)
    }

    func applicationWillTerminate(application: UIApplication) {
        deinitialize()
    }
    
    // MARK: === Deinitialize NSNotification Observers when app is terminated ===
    
    func deinitialize() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadTweets", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "detectNetworkConnection", object: nil)
        print("Notifications were deinitialized")
    }

}

