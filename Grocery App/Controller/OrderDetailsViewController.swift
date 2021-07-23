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
    var checkoutDoneRecently : Bool?
    
    var orderDataManager = OrderDataManager()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
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
        descriptionTableView.backgroundColor = UIColor(named: "buttoncolor")
        
        descriptionTableView.register(CustomHeaderView.self,
               forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        descriptionTableView.register(CustomFooterView.self,
               forHeaderFooterViewReuseIdentifier: "sectionFooter")
        
        orderDataManager.fetchOrdersData { [self] (error) in
            self.heightConstraint.constant = CGFloat(105 * self.orderDataManager.order[index!].allStatus!.count)
            self.descriptionTableViewHeightConstraint.constant = CGFloat(130 * self.orderDataManager.order[index!].items!.count) + 200
            self.statusTableView.reloadData()
            self.descriptionTableView.reloadData()
        }
        descriptionTableView.layer.cornerRadius = 30
        
    }
    
        
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.descriptionTableView{
       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                   "sectionHeader") as! CustomHeaderView
       view.title.text = "Description"
       return view
    }
    return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.descriptionTableView{
            return 50
        }
        return 0
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
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == self.descriptionTableView{
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                        "sectionFooter") as! CustomFooterView
            if self.orderDataManager.order.count > 0 {
            view.totalBillAmountValueLbl.text = "₹\(self.orderDataManager.order[index!].total!)"
            view.totalDiscountValueLbl.text = "-₹\(self.orderDataManager.order[index!].totalDiscount!)"
            view.payableAmountValueLbl.text = "₹\(self.orderDataManager.order[index!].payableAmount!)"
            return view
        }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == self.descriptionTableView{
            return 150
        }
        return 0
    }
    
}
