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
    
    @IBOutlet weak var totalDiscountLbl: UILabel!
    @IBOutlet weak var payableAmountLbl: UILabel!
    @IBOutlet weak var totalBillAmountLbl: UILabel!
    var statusArray = ["Order Placed" , "Pending","Confirmed","Processing","Delivered"]
    
    var index : Int?
    
    var orderDataManager = OrderDataManager()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var descriptionTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionTableView: UITableView!
    @IBOutlet weak var statusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        statusTableView.delegate = self
        statusTableView.dataSource = self
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        orderDataManager.fetchOrdersData { [self] (error) in
            self.heightConstraint.constant = CGFloat(105 * self.orderDataManager.order[index!].allStatus!.count)
            
            self.payableAmountLbl.text = "₹\(self.orderDataManager.order[index!].payableAmount!)"
            self.totalDiscountLbl.text = "-₹\(self.orderDataManager.order[index!].totalDiscount!)"
            self.totalBillAmountLbl.text = "₹\(self.orderDataManager.order[index!].total!)"
            self.statusTableView.reloadData()
            self.descriptionTableView.reloadData()
        }
        descriptionTableView.layer.cornerRadius = 30
        descriptionTableView.tableFooterView = priceView
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderDataManager.order.count > 0{
            if tableView == self.statusTableView {
            return self.orderDataManager.order[index!].allStatus!.count
            }else{
            return self.orderDataManager.order[index!].items!.count
            }
        }else{
            return 0
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.orderDataManager.order.count > 0 {
            if tableView == self.statusTableView{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDesignCell", for: indexPath) as? OrderStatusDesignTableViewCell else { return UITableViewCell() }
            cell.configureCellUI(order: self.orderDataManager.order[index!], index: indexPath.row)
                return cell
            }else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell else { return UITableViewCell() }
                cell.configureCellUI(order: self.orderDataManager.order[index!], index: indexPath.row)
                return cell
                }
        }
      return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.statusTableView{
         return 105
        }else{
            return UITableView.automaticDimension
        }
    }
    
}
