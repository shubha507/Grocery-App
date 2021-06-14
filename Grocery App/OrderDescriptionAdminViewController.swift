//
//  OrderDescriptionAdminViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 07/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
protocol MoveToNextStateProtocol {
    func confirmTapped(index: Int)
}
class OrderDescriptionAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var presentState = String()
    @IBOutlet weak var moveOrderButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var moveOrderButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var moveOrderButtonLeading: NSLayoutConstraint!
    var confirmTappedProtocol: MoveToNextStateProtocol?
    let dataManager = DataManager()
    @IBOutlet weak var moveOrderNextStateButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var lowerViewProductDescription: UIView!
    @IBOutlet weak var productDescriptionTableView: UITableView!
    var id = String()
    var indexSelected = Int()
    var order = [Order]()
    var status = [Status]()

    var statusList: [String: Any] = [:]
   
        
    func setButtonLayout( name : String)
    {
        moveOrderButtonTrailing.constant = 0
        moveOrderButtonLeading.constant = 0
        moveOrderButtonBottom.constant = 0
        moveOrderNextStateButton.tintColor = UIColor.white
        moveOrderNextStateButton.isEnabled = false
        if name == "declined"
                {
            moveOrderNextStateButton.setTitle("Declined", for: .normal)
            moveOrderNextStateButton.backgroundColor = UIColor.red
                }
                
                else if name == "delivered"
                    {
                        
                        moveOrderNextStateButton.setTitle("Delivered", for: .normal)
                        moveOrderNextStateButton.backgroundColor = UIColor.green
                    
                    }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setButtonLayout(name: presentState)
        self.tabBarController?.tabBar.isHidden = true
        productDescriptionTableView.delegate = self
        productDescriptionTableView.dataSource = self
        self.productDescriptionTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        moveOrderNextStateButton.layer.cornerRadius = 5
        print("id is:" , id)
        self.productDescriptionTableView.allowsSelection = false
        
        self.totalPriceLabel.text = "Rs. " + "\(order[indexSelected].payableAmount ?? 0)"
    }
    
    let arr: [String] = [ "placed" , "confirmed" , "processing" , "delivered"]
    func setStatevalues ()
    {
        let db = Firestore.firestore()
        
        var i = 0
        var j = Int()
        while i < arr.count
        {
            if order[indexSelected].currentStatus == arr[i]
            {
                j = i + 1
            }
            i = i + 1
        }
        status = order[indexSelected].allStatus!
        status[j].completed = true
        status[j].updatedAt = Timestamp(date: Date())
       
        var array = [[String : Any]]()
        for item in self.status
        {
            
            array.append(item.getData())
        }
        
        print("status is" , status)
        
        db.collection("orders").document("\(id)").setData([
            "allStatus" : array,
            "currentStatus" : "\(arr[j])",
            "updatedAt": Timestamp(date: Date()),
        ],  merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
        

    }
    
    func setStatevaluesDeclined ()
    {
        let db = Firestore.firestore()
        
        var i = 0
        
       
        status = order[indexSelected].allStatus!
        
        status[i].updatedAt = Timestamp(date: Date())
        let declinedStatus : [String:Any] = ["completed": true , "createdAt": Timestamp(date: Date()), "description": "Seller has declined your order" , "status": "declined" ,"title": "Order Declined" , "updatedAt": Timestamp(date: Date()) ]
        var array = [[String : Any]]()
        for item in self.status
        {
            if i == 0
            {
            array.append(item.getData())
                
            i = i + 1
            }
        }
        array.append(declinedStatus)
        print("status is" , status)
        
        db.collection("orders").document("\(id)").setData([
            "allStatus" : array,
            "currentStatus" : "declined",
            "updatedAt": Timestamp(date: Date()),
        ],  merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
            }
        }
        

    }
   
    func showCompletion()
    {
    
        let alert = UIAlertController(title: nil, message: "Move Order???", preferredStyle: .actionSheet)
        
        alert.view.tintColor = UIColor.brown
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (handle) in
            self.setStatevalues()
            if self.presentState == "processing"
            {
                self.presentState = "delivered"
                self.setButtonLayout(name: self.presentState)
                
            }
            self.confirmTappedProtocol?.confirmTapped(index: self.indexSelected)
            alert.dismiss(animated: true, completion: nil)
            self.presentState = ""
        }))
        alert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (handle) in
            self.setStatevaluesDeclined()
            self.confirmTappedProtocol?.confirmTapped(index: self.indexSelected)
            alert.dismiss(animated: true, completion: nil)
            self.presentState = ""
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (handle) in
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func moveToNextStateButtonClicked(_ sender: Any) {
        showCompletion()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.order[indexSelected].items?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDescriptionCell", for: indexPath) as! OrderDescriptionTableViewCell
    
        
        dataManager.getImageFrom(url: "\(order[indexSelected].items?[indexPath.row].url ?? "")", imageView: cell.productOrderImage )
        cell.cartProductName.text = "\(order[indexSelected].items?[indexPath.row].name ?? "")"
        cell.countProduct.text = "\(order[indexSelected].items?[indexPath.row].count ?? 0)" + "X"
        
        if (Int(order[indexSelected].items?[indexPath.row].discount ?? 0)) != 0 {
       
        cell.cartProductPrice.text = "Rs. " + "\(Int(order[indexSelected].items?[indexPath.row].price ?? 0))"
            cell.cartProductPrice.attributedText = cell.cartProductPrice.text?.strikeThrough()
            cell.cartProductDiscount.text = "\(Int(order[indexSelected].items?[indexPath.row].discount ?? 0))" + "% off"
        let percentValue = ( (order[indexSelected].items?[indexPath.row].price ?? 0) * (order[indexSelected].items?[indexPath.row].discount ?? 0) / 100)
        let valueAfterDiscount = Int((order[indexSelected].items?[indexPath.row].price ?? 0) - percentValue)
        
        cell.cartDiscountPrice.text = "Rs. " + "\(valueAfterDiscount)"
        }
        else {
            //cell.countProduct.text = "\(order[indexSelected].items?[indexPath.row].count ?? 0)" + "X"
            cell.cartDiscountPrice.text = "Rs. " + "\(Int(order[indexSelected].items?[indexPath.row].price ?? 0))"
                cell.cartProductDiscount.text = ""
            
            
            cell.cartProductPrice.text = ""
        }

        return cell
    }
    
    
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
