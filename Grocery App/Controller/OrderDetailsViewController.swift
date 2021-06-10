//
//  OrderDetailsViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 31/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var statusArray = ["Order Placed" , "Pending","Confirmed","Processing","Delivered"]
    
    var index : Int?
    
    var orderDataManager = OrderDataManager()
    
    @IBOutlet weak var statusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        statusTableView.delegate = self
        statusTableView.dataSource = self
        orderDataManager.fetchOrdersData { (error) in
            self.statusTableView.reloadData()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderDataManager.order.count > 0{
            return self.orderDataManager.order[index!].allStatus!.count
        }else{
            return 0
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDesignCell", for: indexPath) as? OrderStatusDesignTableViewCell else {return UITableViewCell()}
        if self.orderDataManager.order.count > 0 && self.orderDataManager.order[index!].currentStatus != "declined"{
            cell.statusLabel.text = self.orderDataManager.order[index!].allStatus?[indexPath.row].title
            if indexPath.row == self.orderDataManager.order[index!].allStatus!.count-1{
                cell.lineView.isHidden = true
            }
            cell.orderStatusDescriptionLbl.text = self.orderDataManager.order[index!].allStatus?[indexPath.row].description
            if self.orderDataManager.order[index!].allStatus?[indexPath.row].completed == true {
                cell.checkmarkView.isHidden = false
            cell.updationTimeLbl.text = "\(orderDataManager.changeTimeFormat(date: (self.orderDataManager.order[index!].allStatus?[indexPath.row].updatedAt)!,format : "hh:mm a"))"
            cell.updationDateLbl.text = "\(orderDataManager.changeTimeFormat(date: (self.orderDataManager.order[index!].allStatus?[indexPath.row].updatedAt)!,format : "dd MMMM, yyyy"))"
            }else{
                cell.updationTimeLbl.text = "Not updated yet"
                cell.updationDateLbl.text = "Not updated yet"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
