//
//  MyCustomTabBarController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 23/04/21.
//

import UIKit

class MyCustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let tabBar = MyTabBar()
        tabBar.delegate = self
        
        setupMiddleButton()
   }
    
    func setupMiddleButton() {

            let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            
            //STYLE THE BUTTON YOUR OWN WAY
//            middleBtn.setIcon(icon: .fontAwesomeSolid(.home), iconSize: 20.0, color: UIColor.white, backgroundColor: UIColor.white, forState: .normal)
//            middleBtn.applyGradient(colors: colorBlueDark.cgColor,colorBlueLight.cgColor])
            
            //add to the tabbar and add click event
            self.tabBar.addSubview(middleBtn)
            middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

            self.view.layoutIfNeeded()
        }

        // Menu Button Touch Action
        @objc func menuButtonAction(sender: UIButton) {
            self.selectedIndex = 2   //to select the middle tab. use "1" if you have only 3 tabs.
        }
}
