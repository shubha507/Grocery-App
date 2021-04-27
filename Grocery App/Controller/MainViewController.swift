//
//  ViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 22/04/21.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.delegate = self
        self.selectedIndex = 2
        ConfigureViewController()
        
        }
    
    func ConfigureViewController(){
        
        tabBar.barTintColor = UIColor(named: "mygreen")
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor(named: "mylightgreen")
        
        
        let home = HomeViewController()
        home.tabBarItem.image = #imageLiteral(resourceName: "noun_menu_3127023")
        home.tabBarItem.title = "Home"
        
        
        let order = OrderViewController()
        order.tabBarItem.image = #imageLiteral(resourceName: "noun_Store_3499096")
        order.tabBarItem.title = "Order"
        
        let cart = CartViewController()
        cart.tabBarItem.image = #imageLiteral(resourceName: "noun_cart_1864278")
        cart.tabBarItem.title = "Cart"
        
        let offer = OfferViewController()
        offer.tabBarItem.image = #imageLiteral(resourceName: "noun_Gift_1546455")
        offer.tabBarItem.title = "Offer"
        
        let more = MoreViewController()
        more.tabBarItem.image = #imageLiteral(resourceName: "noun_slider_125134")
        more.tabBarItem.title = "More"
        
        viewControllers = [home,order,cart,offer,more]
        
        
    }


}

