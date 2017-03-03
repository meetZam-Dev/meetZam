//
//  SettingViewController.swift
//  MySampleApp
//
//  Created by ZuYuan Fan on 2/26/17.
//
//

import UIKit
import AWSMobileHubHelper

class SettingViewController: UIViewController {

    // ============================================
    // Variable starts here
    var new_signinObserver: AnyObject!
    var new_signoutObserver: AnyObject!
    
    fileprivate let loginStatusButton: UIButton = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 65, width: UIScreen.main.bounds.width, height: 50))
    
    // Variable ends here
    // ============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        
        handleSigninStatus()
        
        
        // ============================================
        // AWS implementation starts here
        
        // 1. first attempt to pop sign in view controller
        perform(#selector(popSignInViewController), with: nil, afterDelay: 0)
        //popSignInViewController()
        
        // 2. signinObserver: need to figure it out.
        new_signinObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AWSIdentityManagerDidSignIn,
            object: AWSIdentityManager.default(),
            queue: OperationQueue.main,
            using: { [weak self] (note: Notification) -> Void in
                guard let strongSelf = self else { return }
                print("Sign in observer observed sign in.")
                strongSelf.setloginStatusButton()
                
        })
        
        // 3. signoutObserver: need to figure it out.
        new_signoutObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AWSIdentityManagerDidSignOut,
            object: AWSIdentityManager.default(),
            queue: OperationQueue.main,
            using: { [weak self] (note: Notification) -> Void in
                guard let strongSelf = self else { return }
                print("Sign Out Observer observed sign out.")
                strongSelf.setloginStatusButton()
        })
        
        // 4. attemp to add button
        self.setloginStatusButton()
        
        // AWS implementation ends here
        // ============================================
        
    }

    // ============================================
    // AWS support functions start here
    
    deinit {
        NotificationCenter.default.removeObserver(new_signinObserver)
        NotificationCenter.default.removeObserver(new_signoutObserver)
    }
    
    // 1. set login/logout button
    func setloginStatusButton() {
        
        loginStatusButton.setTitleColor(UIColor.red, for: .normal)
        
        loginStatusButton.setTitle("NONE", for: .normal)
        loginStatusButton.backgroundColor = UIColor.white
        loginStatusButton.tag = 1
        
        
        if (AWSIdentityManager.default().isLoggedIn) {
            loginStatusButton.setTitle("Log out", for: .normal)
            loginStatusButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
            
        }
        
        self.view.addSubview(loginStatusButton)
    }
    
    // 2. handle logout
    func handleLogout() {
        if (AWSIdentityManager.default().isLoggedIn) {
            AWSIdentityManager.default().logout(
                completionHandler: { (result: Any?, error: Error?) in
                    self.setloginStatusButton()
                    //self.popSignInViewController()
                    self.animated_SignInViewController()
            })
        }
    }
    
    // 3. display sign in view controller
    func popSignInViewController() {
        if (!AWSIdentityManager.default().isLoggedIn) {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
            
            self.present(viewController, animated: false, completion: nil)
            
        }
    }
    
    func animated_SignInViewController() {
        if (!AWSIdentityManager.default().isLoggedIn) {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
            
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
    
    // ============================================
    func handleSigninStatus() {
        if (!AWSIdentityManager.default().isLoggedIn) {
            let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignIn")
            self.present(viewController, animated: true, completion: nil)
        }
    }


}
