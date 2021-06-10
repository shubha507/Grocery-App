//
//  AdminOrderViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 06/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class AdminOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var orderTableView: UITableView!
    let dataManager = DataManager()
    private var order = [Order]()

    var imageid = String()
    var sortedOrder = [Order]()
    
    func fetchData(){
       
        let db = Firestore.firestore()
        db.collection("orders").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            
            for document in querySnapshot!.documents {
                
               let newOrder = Order(data: document.data())
              // let newCategory = Categories1(docId: data)
               // print("document is" , document)
                var item = newOrder.items
                
               
                //print(newOrder.name)
                
             self.order.append(newOrder)
            }
          
            
           
            self.sortedOrder = self.order.sorted(by: { $0.createdAt?.dateValue() ?? NSDate.distantPast > $1.createdAt?.dateValue() ?? NSDate.distantPast })
            
            self.orderTableView.reloadData()
           
           
        }
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = false
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        self.orderTableView.rowHeight = UITableView.automaticDimension
        self.orderTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.orderTableView.estimatedRowHeight = 100
        
        fetchData()
        
        self.orderTableView.allowsSelection = true
       // self.orderTableView.selectionFollowsFocus = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        //fetchData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedOrder.count
    }
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //      return 170
        
  //  }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminOrderCell", for: indexPath) as! AdminOrderTableViewCell
        cell.selectionStyle = .none
        cell.orderAddressLabel.text = "\(sortedOrder[indexPath.row].deliveryAddress!)"
        let date = (sortedOrder[indexPath.row].createdAt!).dateValue()
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,YYYY hh:mm a"
        let stringDate  = dateFormatterPrint.string(from: date)
        cell.orderDateLabel.text = "Ordered on:  " + "\(stringDate)"
        cell.orderNameLabel.text = "\(sortedOrder[indexPath.row].name!)"
        let count = sortedOrder[indexPath.row].items?.count
        print("sorted order: " , sortedOrder[indexPath.row].items)
        if  sortedOrder[indexPath.row].items?.count != 0
            {
        dataManager.getImageFrom(url: "\(sortedOrder[indexPath.row].items?[0].url ?? "")", imageView: cell.orderImage )
        }
        cell.orderItemsLabel.text = "\(count ?? 0)" + " Items"
        cell.orderStatusLabel.text = "\(sortedOrder[indexPath.row].currentStatus!)"
        if "\(sortedOrder[indexPath.row].currentStatus!)" == "placed"
        {
            cell.orderStatusLabel.textColor = UIColor.systemIndigo
            cell.orderStatusLabel.text = "Placed"
            cell.orderStatusLabel.layer.borderColor = UIColor.systemIndigo.cgColor
        }
        else if "\(sortedOrder[indexPath.row].currentStatus!)" == "processing"
        {
            cell.orderStatusLabel.textColor = UIColor.systemOrange
            cell.orderStatusLabel.text = "Processing"
            cell.orderStatusLabel.layer.borderColor = UIColor.systemOrange.cgColor
        }
        else if "\(sortedOrder[indexPath.row].currentStatus!)" == "confirmed"
        {
            cell.orderStatusLabel.textColor = UIColor.systemYellow
            cell.orderStatusLabel.text = "Confirmed"
            cell.orderStatusLabel.layer.borderColor = UIColor.systemYellow.cgColor
        }
        else if "\(sortedOrder[indexPath.row].currentStatus!)" == "delivered"
        {
            cell.orderStatusLabel.textColor = UIColor.systemGreen
            cell.orderStatusLabel.text = "Delivered"
            cell.orderStatusLabel.layer.borderColor = UIColor.systemGreen.cgColor
        }
        else if "\(sortedOrder[indexPath.row].currentStatus!)" == "declined"
        {
            cell.orderStatusLabel.textColor = UIColor.systemRed
            cell.orderStatusLabel.text = "Declined"
            cell.orderStatusLabel.layer.borderColor = UIColor.systemRed.cgColor
        }
        return cell
    }
    var i = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let adminOrderObject:OrderDescriptionAdminViewController = self.storyboard?.instantiateViewController(identifier: "OrderDescriptionAdminViewController") as! OrderDescriptionAdminViewController
        adminOrderObject.confirmTappedProtocol = self
        adminOrderObject.id = sortedOrder[indexPath.row].id ?? ""
        adminOrderObject.order = sortedOrder
         
        i = i + 1
        adminOrderObject.indexSelected = indexPath.row
        print("order status array:" , order[indexPath.row].allStatus ?? "")
        self.navigationController?.pushViewController(adminOrderObject, animated: true)
       
        
    }
   
}
extension AdminOrderViewController: MoveToNextStateProtocol
{
    func confirmTapped(index: Int) {
        order = []
       fetchData()
        
        
        self.orderTableView.reloadData()
        
       //orderTableView.reloadRows(at: IndexPath(index: index), with: .none)
    }
    
    
    
    
}
