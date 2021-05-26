//
//  CustomTabBarViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let imageView : UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 11, y: 14, width: 40, height: 40))
        iv.image = UIImage(named: "noun_cart_1533490")
        iv.tintColor = UIColor(named: "mygreen")
        return iv
    }()
    
    private let cartItemNumberImageView : UIImageView = {
        let view = UIImageView( frame: CGRect(x: 45, y: -10, width: 30, height: 40))
       // view.backgroundColor = .red
        view.image = UIImage(named: "pop")
        return view
    }()
    
    private let cartItemNumberLabel : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.selectedIndex = 0
        setupMiddleButton()
        ConfigureViewController()
        cartItemNumberImageView.isHidden = true
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
        let buttonView = UIView(frame: CGRect(x: (self.view.bounds.width / 2)-45, y:-70 , width: 90, height: 90))
       // buttonView.layer.borderWidth = 12
       // buttonView.layer.borderColor = UIColor(named: "mygreen")?.cgColor
        buttonView.layer.cornerRadius = buttonView.frame.width/2
        buttonView.backgroundColor = UIColor(named: "mygreen")
        
        let middleButton = UIButton()
        middleButton.layer.cornerRadius = 30
        buttonView.addSubview(middleButton)
        middleButton.anchor(top: buttonView.topAnchor, left: buttonView.leftAnchor, bottom: buttonView.bottomAnchor, right: buttonView.rightAnchor, paddingTop: 13, paddingLeft: 13, paddingBottom: 13, paddingRight: 13)
        
        middleButton.clipsToBounds = true
        middleButton.backgroundColor = .white
        middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        middleButton.imageView?.contentMode = .center
        middleButton.addSubview(imageView)
              middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.1
        middleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        cartItemNumberImageView.addSubview(cartItemNumberLabel)
        cartItemNumberLabel.anchor(top: cartItemNumberImageView.topAnchor, left: cartItemNumberImageView.leftAnchor, bottom: cartItemNumberImageView.bottomAnchor, right: cartItemNumberImageView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 17, paddingRight: 5)
        NotificationCenter.default.addObserver(self, selector: #selector(numberOfProductAddedToCart), name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
       // cartItemNumberLabel.text = "10"
        
        buttonView.addSubview(cartItemNumberImageView)
        self.tabBar.addSubview(buttonView)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func numberOfProductAddedToCart(){
        if CartManager.shared.productAddedToCart.count == 0{
            cartItemNumberImageView.isHidden = true
        }else{
            cartItemNumberImageView.isHidden = false
        cartItemNumberLabel.text = "\(CartManager.shared.productAddedToCart.count)"
       }
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2
        
    }
    
}
