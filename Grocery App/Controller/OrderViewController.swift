//
//  OrderViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit

class OrderViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    let orderStatusArray = ["All Order","Pending","Processing","Confirmed","Delivered"]
    
    @IBOutlet weak var orderStatusCollectionView: UICollectionView!
    
    @IBOutlet weak var orderStatusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderStatusCollectionView.delegate = self
        orderStatusCollectionView.dataSource = self
        orderStatusCollectionView.layer.cornerRadius = 20
        orderStatusTableView.delegate = self
        orderStatusTableView.dataSource = self
        orderStatusTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderStatusArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderStatusCell", for: indexPath) as? OrderStatusCollectionViewCell
        cell!.orderStatusLabel.text = orderStatusArray[indexPath.row]
        cell!.layer.borderWidth = 1
        cell!.layer.borderColor = UIColor.systemGray5.cgColor
        cell!.layer.cornerRadius = 10
        return cell!
    }
}

extension OrderViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 20, bottom: 0, right: 0)
    }
    
}

extension OrderViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderTableViewCell
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let orderDetailVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        orderDetailVC.modalPresentationStyle = .fullScreen
        self.present(orderDetailVC, animated: true, completion: nil)
    }

    
    
}
