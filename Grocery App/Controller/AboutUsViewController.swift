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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timingLabel: UILabel!
    
    @IBOutlet weak var phnNoLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        db.collection("others").document("aboutpage").getDocument { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
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
        
    }

