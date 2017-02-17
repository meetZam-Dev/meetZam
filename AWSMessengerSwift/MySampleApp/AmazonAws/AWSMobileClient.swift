//
//  AWSMobileClient.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.4
//
import Foundation
import UIKit
import AWSCore
import AWSMobileHubHelper
import AWSMobileAnalytics

/**
 * AWSMobileClient is a singleton that bootstraps the app. It creates an identity manager to establish the user identity with Amazon Cognito.
 */
class AWSMobileClient: NSObject {
    // Amazon Mobile Analytics client - Use to generate custom or monetization analytics events.
    var mobileAnalytics: AWSMobileAnalytics!
    
    // Shared instance of this class
    static let sharedInstance = AWSMobileClient()
    fileprivate var isInitialized: Bool
    
    fileprivate override init() {
        isInitialized = false
        super.init()
    }
    
    deinit {
        // Should never be called
        print("Mobile Client deinitialized. This should not happen.")
    }
    
    /**
     * Configure third-party services from application delegate with url, application
     * that called this provider, and any annotation info.
     *
     * - parameter application: instance from application delegate.
     * - parameter url: called from application delegate.
     * - parameter sourceApplication: that triggered this call.
     * - parameter annotation: from application delegate.
     * - returns: true if call was handled by this component
     */
    func withApplication(_ application: UIApplication, withURL url: URL, withSourceApplication sourceApplication: String?, withAnnotation annotation: AnyObject) -> Bool {
        print("withApplication:withURL")
        AWSIdentityManager.defaultIdentityManager().interceptApplication(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        if (!isInitialized) {
            isInitialized = true
        }
        
        return false;
    }
    
    /**
     * Performs any additional activation steps required of the third party services
     * e.g. Facebook
     *
     * - parameter application: from application delegate.
     */
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive:")
        initializeMobileAnalytics()
    }
    
    fileprivate func initializeMobileAnalytics() {
        if (mobileAnalytics == nil) {
            mobileAnalytics = AWSMobileAnalytics.default()
        }
    }
    /**
    * Handles callback from iOS platform indicating push notification registration was a success.
    * - parameter application: application
    * - parameter deviceToken: device token
    */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        AWSPushManager.defaultPushManager().interceptApplication(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    /**
     * Handles callback from iOS platform indicating push notification registration failed.
     * - parameter application: application
     * - parameter error: error
     */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        AWSPushManager.defaultPushManager().interceptApplication(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    /**
     * Handles a received push notification.
     * - parameter userInfo: push notification contents
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        AWSPushManager.defaultPushManager().interceptApplication(application, didReceiveRemoteNotification: userInfo)
    }
    
    /**
    * Configures all the enabled AWS services from application delegate with options.
    *
    * - parameter application: instance from application delegate.
    * - parameter launchOptions: from application delegate.
    */
    func didFinishLaunching(_ application: UIApplication, withOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        print("didFinishLaunching:")

        var didFinishLaunching: Bool = AWSIdentityManager.defaultIdentityManager().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        didFinishLaunching = didFinishLaunching && AWSPushManager.defaultPushManager().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)

        if (!isInitialized) {
            AWSIdentityManager.defaultIdentityManager().resumeSession(completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
                print("Result: \(result) \n Error:\(error)")
            } as! (Any?, Error?) -> Void)
            isInitialized = true
        }

        return didFinishLaunching
    }
}
