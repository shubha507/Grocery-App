//
//  OrderTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 31/05/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    var dataManager = DataManager()
    var orderDataManager = OrderDataManager()

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var orderedProductImageView: UIImageView!
    @IBOutlet weak var itemNumberLbl: UILabel!
    @IBOutlet weak var deliveryStatusDateLbl: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var orderdProductLbl: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.shadowOpacity = 0.5
        cellView.layer.shadowColor = UIColor.systemGray.cgColor
        cellView.layer.shadowOffset = CGSize(width: 2, height: 3)
        orderStatusLabel.layer.borderColor = UIColor.green.cgColor
        orderStatusLabel.layer.borderWidth = 2
        orderStatusLabel.layer.cornerRadius = 10
        orderStatusLabel.layer.masksToBounds = true
       // orderStatusLabel.con
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func configureUI(order : Order){
        self.itemNumberLbl.text = "\(order.items!.count) Items"
        self.userNameLabel.text = "\(order.name!)"
        self.orderdProductLbl.text = "\(order.items![0].name!)"
        for i in 1..<order.items!.count {
            self.orderdProductLbl.text = self.orderdProductLbl.text! + ",\(order.items![i].name!)"
        }
        dataManager.getImageFrom(url: order.items![0].url!, imageView: orderedProductImageView)
       
        
        if order.currentStatus != "delivered"{
            self.deliveryStatusDateLbl.text = "Ordered On :\(orderDataManager.changeTimeFormat(date: order.createdAt!,format : "dd MMMM,yyyy hh:mm:s"))"
        }else{
            
        }
        if  order.currentStatus! == "placed"{
            orderStatusLabel.text = "Placed"
        }else if order.currentStatus! == "pending"{
            orderStatusLabel.text = "Pending"
        }else if order.currentStatus! == "confirmed"{
            orderStatusLabel.text = "Confirmed"
        }else if order.currentStatus! == "processing"{
            orderStatusLabel.text = "Processing"
        }else if order.currentStatus! == "delivered"{
            orderStatusLabel.text = "Delivered"
        }else if order.currentStatus! == "declined"{
            orderStatusLabel.text = "Declined"
        }
    }

}
