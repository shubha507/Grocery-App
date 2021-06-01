//
//  OrderDetailsViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 31/05/21.
//

import UIKit

class OrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var statusArray = ["Order Placed" , "Pending","Confirmed","Processing","Delivered"]
    
    @IBOutlet weak var statusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusTableView.delegate = self
        statusTableView.dataSource = self
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDesignCell", for: indexPath) as? OrderStatusDesignTableViewCell
        if indexPath.row == 4{
            cell!.lineView.isHidden = true
        }
        if indexPath.row != 0 {
            cell!.checkmarkView.isHidden = true
        }
        cell!.statusLabel.text = statusArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
