//
//  PALoginVC.swift
//  Payments
//
//  Created by Mike Silvis on 7/25/16.
//  Copyright © 2016 Mike Silvis. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKLoginKit

class PALoginVC: UIViewController {
    @IBOutlet private weak var digitsRequestContainerView: UIView? {
        didSet {
            guard let container = digitsRequestContainerView else { return }
            
            container.addSubview(fbLoginButton)
            
            fbLoginButton.snp_makeConstraints { (make) in
                make.edges.equalTo(container)
            }
        }
    }
    private let fbLoginButton : FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email", "user_friends"]
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.delegate = self
    }
    
    //
    // MARK: Helpers
    //
    
    private func showFacebookAuthenticationError() {
        
    }
}

extension PALoginVC : FBSDKLoginButtonDelegate {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        PAUser.currentUser.authenticateWithFacebook(result.token.userID, accessToken: result.token.tokenString) { [weak self] (success) in
            if success {
                self?.navigationController?.pushViewController(PARootNC.feedVC(), animated: false)
            }
            else {
                self?.showFacebookAuthenticationError()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
