//
//  HomeViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 23/04/21.
//

import UIKit
import FirebaseAuth

class HomeViewController : UIViewController {

    override func viewDidLoad() {
        super .viewDidLoad()
        
        view.backgroundColor = .red
        view.addSubview(logoutButton)
        logoutButton.centerX(inView: view)
        logoutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
    }
    
    private let logoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out" , for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(named: "myyellow")
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setDimensions(height: 50, width: 150)
        button.addTarget(self, action: #selector(logoutButtonPushed), for: .touchUpInside)
        return button
    }()
    
    @objc func logoutButtonPushed(){
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
    }
    
    
    
}

