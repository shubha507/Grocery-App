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

class OrderDescriptionAdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
   
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        productDescriptionTableView.delegate = self
        productDescriptionTableView.dataSource = self
        self.productDescriptionTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        moveOrderNextStateButton.layer.cornerRadius = 5
        print("id is:" , id)
        self.productDescriptionTableView.allowsSelection = false
        
        self.totalPriceLabel.text = "Rs. " + "\(order[indexSelected].payableAmount ?? 0)"
    }
    //func getData(index = Int) -> [[String :  Any]]
    //{
      //  if index == 0
      //  {
        //    let placedStatusDict : [String : Any] = ["completed": true, "createdAt": Timestamp(date: Date()), "updatedAt": Timestamp(date: Date()), "title":"Placed", "status": ]
     //   }
   // }
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
       
       
       // if let arr = data["allStatus"] as? [[String : Any]] {
        //    for item in arr
       //     {
        //        let status = Status(data: item)
         //       self.allStatus?.append(status)
         //   }
       // }
        
        
       // var ref: DatabaseReference!
        
       // ref = Firestore.firestore().
        statusList = status.toDictionary { $0.title ?? "" }
        let anyDict = statusList["Order Placed"] as Any
        let anyDict1 = statusList["Confirmed"] as Any
        let anyDict2 = statusList["Processing"] as Any
        let anyDict3 = statusList["Delivered"] as Any
        let array: [[String : Any]] = [anyDict,anyDict1,anyDict2,anyDict3]
        let placedStatusDict : [String : Any]? = anyDict as? [String : Any]
        
        print("status is" , status)
        
        
        print("status List:" , statusList)
        
        //print("placedStatusDict" , placedStatusDict)
       // db.collection("orders").document("\(id)").setData(status, merge: true)
        //let query = db.collection("orders/*/\(id)").whereField(<#T##field: String##String#>, in: <#T##[Any]#>)
        db.collection("orders").document("\(id)").setData([
            "allStatus" : statusList,
            "currentStatus" : "\(arr[j])",
            
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
    
        let alert = UIAlertController(title: nil, message: "Move Order???", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (handle) in
            self.setStatevalues()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { (handle) in
            alert.dismiss(animated: true, completion: nil)
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
extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
