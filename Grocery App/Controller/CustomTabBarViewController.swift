//
//  CustomTabBarViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let imageView : UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 27, y: 30, width: 35, height: 35))
        iv.image = UIImage(named: "noun_cart_1533490")
        iv.tintColor = UIColor(named: "mygreen")
        return iv
    }()
    
    private let cartItemNumberView : UIView = {
        let view = UIView( frame: CGRect(x: 27, y: 0, width: 35, height: 35))
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.selectedIndex = 0
        setupMiddleButton()
        ConfigureViewController()
    }
    
    func ConfigureViewController(){
            
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Order"
        tabBar.items?[3].title = "Offer"
        tabBar.items?[4].title = "More"
        tabBar.items?[0].image = #imageLiteral(resourceName: "noun_menu_3127023")
        tabBar.items?[1].image = #imageLiteral(resourceName: "noun_Store_3499096")
        tabBar.items?[3].image = #imageLiteral(resourceName: "noun_Gift_1546455")
        tabBar.items?[4].image = #imageLiteral(resourceName: "noun_slider_125134")
        tabBar.items?[2].title = nil
        
    }
    
    func setupMiddleButton() {
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-45, y:-70 , width: 90, height: 90))
        
        middleButton.layer.borderWidth = 12
        middleButton.layer.borderColor = UIColor(named: "mygreen")?.cgColor
        middleButton.layer.cornerRadius = middleButton.frame.width/2
        middleButton.backgroundColor = .white
        middleButton.imageView?.contentMode = .center
        
        
        middleButton.addSubview(imageView)
              middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        middleButton.addSubview(cartItemNumberView)
        
        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2
        
    }
    
}
