//
//  MoreViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AboutUsViewController : UIViewController {
    
    var number : String?
    var locationUrl : String?
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timingLabel: UILabel!
    
    @IBOutlet weak var phnNoLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    private let errorImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "error_image")
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    private let tryAgainButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Again" , for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "mygreen")
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let errorLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Error occurred!"
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.isHidden = true
      configureStoreData()
        }
    
    func configureStoreData(){
        let db = Firestore.firestore()
        db.collection("others").document("aboutpage").getDocument { (document, err) in
            if let err = err {
                print("error : \(err.localizedDescription)")
                self.configureErrorView()
            } else {
                self.configurePageView()
                let data = document?.data()
                self.titleLabel.text = data?["storeName"] as? String ?? ""
                self.addressLabel.text = data?["locationDescription"] as? String ?? ""
                self.phnNoLabel.text = data?["contact"] as? String ?? ""
                self.timingLabel.text = data?["timing"] as? String ?? ""
                self.number = data?["contact"] as? String ?? ""
                self.locationUrl = data?["locationUri"] as? String ?? ""
                }
            }
    }
    
    func configurePageView(){
        self.contentView.isHidden = false
        errorImageView.isHidden = true
        errorLabel.isHidden = true
        tryAgainButton.isHidden = true
        view.backgroundColor = UIColor(named: "mygreen")
    }
    
    func configureErrorView(){
        view.backgroundColor = .white
        contentView.isHidden = true
        view.addSubview(errorImageView)
        errorImageView.setDimensions(height: 100, width: 100)
        errorImageView.centerX(inView: view)
        errorImageView.centerY(inView: view)
        
        view.addSubview(errorLabel)
        errorLabel.anchor(top: errorImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 100, paddingRight: 100)
        
        view.addSubview(tryAgainButton)
        tryAgainButton.anchor(top: errorLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 5, paddingLeft: 100, paddingRight: 100)
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        print(number!)
        if let url = URL(string: "tel://\(number!)") {
             UIApplication.shared.open(url)
         }
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func addressButtonPressed(_ sender: Any) {
        if let url = URL(string: locationUrl!) {
            print(url)
            UIApplication.shared.open(url)
            }
        }
 
    @objc func profileButtonTapped(){
      configureStoreData()
    }
    
}
