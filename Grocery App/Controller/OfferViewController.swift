//
//  OfferViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class OfferViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var discountArray = [Discount]()
    
    @IBOutlet weak var offerTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDiscountData()
        offerTableView.delegate = self
        offerTableView.dataSource = self
       
    }
    
    func fetchDiscountData(){
        let db = Firestore.firestore()
        db.collection("discounts").order(by: "rank").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data()["rank"] as! Int)")
                    let newDiscount = Discount(data: document.data() )
                    self.discountArray.append(newDiscount)
                }
                self.offerTableView.reloadData()
            
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discountArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferPageTableViewCell") as? OfferPageTableViewCell else { return UITableViewCell() }
        cell.configureCellUI(discount: discountArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
