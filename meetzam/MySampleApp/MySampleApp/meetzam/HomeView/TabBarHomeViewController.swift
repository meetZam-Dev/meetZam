//
//  TabBarHomeViewController.swift
//  MySampleApp
//
//  Created by ZuYuan Fan on 2/20/17.
//
//

import UIKit
import AWSMobileHubHelper

class TabBarHomeViewController: UIViewController {
    
    // ============================================
    // Variable starts here
    var new_signinObserver: AnyObject!
    var new_signoutObserver: AnyObject!
    
    // Variable ends here
    // ============================================
    // Change status bar type to default.
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ============================================
        // AWS implementation starts here
        
        // 1. first attempt to pop sign in view controller
        perform(#selector(popSignInViewController), with: nil, afterDelay: 0)
        
        // 2. signinObserver: need to figure it out.
        new_signinObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AWSIdentityManagerDidSignIn,
            object: AWSIdentityManager.default(),
            queue: OperationQueue.main,
            using: { [weak self] (note: Notification) -> Void in
                guard let strongSelf = self else { return }
                print("Sign in observer observed sign in.")
                //strongSelf.setloginStatusButton()
                
            })
        
        // 3. signoutObserver: need to figure it out.
        new_signoutObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AWSIdentityManagerDidSignOut,
            object: AWSIdentityManager.default(),
            queue: OperationQueue.main,
            using: { [weak self] (note: Notification) -> Void in
                guard let strongSelf = self else { return }
                print("Sign Out Observer observed sign out.")
                //strongSelf.setloginStatusButton()
        })
        
        // AWS implementation ends here
        // ============================================
        
    }
    
    // ============================================
    // AWS support functions start here
    deinit {
        NotificationCenter.default.removeObserver(new_signinObserver)
        NotificationCenter.default.removeObserver(new_signoutObserver)
    }
    
    
    // display sign in view controller
    func popSignInViewController() {
        if (!AWSIdentityManager.default().isLoggedIn) {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")

            self.present(viewController, animated: false, completion: nil)

        }
    }
    // AWS support functions end here
    // ============================================

}
