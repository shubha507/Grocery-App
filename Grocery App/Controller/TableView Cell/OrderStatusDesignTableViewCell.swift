//
//  OrderStatusDesignTableViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 31/05/21.
//

import UIKit

class OrderStatusDesignTableViewCell: UITableViewCell {
    
    var orderDataManager = OrderDataManager()
    
    let crossRedView : UIImageView = {
        let vw = UIImageView(image: UIImage(systemName:"multiply.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold, scale: .large)))
        vw.tintColor = .red
        vw.layer.masksToBounds = true
        return vw
    }()

    @IBOutlet weak var orderStatusDescriptionLbl: UILabel!
    @IBOutlet weak var updationDateLbl: UILabel!
    @IBOutlet weak var updationTimeLbl: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = statusView.frame.width/2
        statusView.layer.borderWidth = 1
        statusView.layer.borderColor = UIColor.systemGray3.cgColor
        checkmarkView.isHidden = true
        updationDateLbl.isHidden = true
        updationTimeLbl.isHidden = true
        updationDateLbl.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/414 * 15)
        updationTimeLbl.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/414 * 17)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellUI(order : Order , index : Int){
            statusLabel.text = order.allStatus?[index].title
            if index == order.allStatus!.count-1{
                lineView.isHidden = true
            }
            orderStatusDescriptionLbl.text = order.allStatus?[index].description
            if order.allStatus?[index].completed == true {
                updationDateLbl.isHidden = false
                updationTimeLbl.isHidden = false
            updationTimeLbl.text = "\(orderDataManager.changeTimeFormat(date: (order.allStatus?[index].updatedAt)!,format : "hh:mm a"))"
            updationDateLbl.text = "\(orderDataManager.changeTimeFormat(date: (order.allStatus?[index].updatedAt)!,format : "dd MMMM, yyyy"))"
                if order.allStatus?[index].status != "declined" {
                    checkmarkView.isHidden = false
                }else{
                    checkmarkView.isHidden = false
                    checkmarkView.image = UIImage(systemName: "multiply.circle.fill")
                    checkmarkView.tintColor = .red
                }
            }
    }

}
