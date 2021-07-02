//
//  OrderViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit

class OrderViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var orderDataManager = OrderDataManager()
    var index : Int?
    
    @IBOutlet weak var contentView: UIView!
    
    private let noOrderImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "empty cart"))
        iv.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let noOrderView : UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
        uv.layer.cornerRadius = 30
        uv.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        return uv
    }()
    
    private let noOrderLbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
    return lbl
    }()
    
    let orderStatusArray = ["All Order","Placed","Pending","Processing","Confirmed","Delivered","Declined"]
    
    @IBOutlet weak var orderStatusCollectionView: UICollectionView!
    
    @IBOutlet weak var orderStatusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        orderStatusCollectionView.delegate = self
        orderStatusCollectionView.dataSource = self
        orderStatusCollectionView.layer.cornerRadius = 20
        orderStatusTableView.delegate = self
        orderStatusTableView.dataSource = self
        
        orderStatusTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        collectionView(orderStatusCollectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderStatusArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderStatusCell", for: indexPath) as? OrderStatusCollectionViewCell else { return UICollectionViewCell()
            
        }
        cell.orderStatusLabel.text = orderStatusArray[indexPath.row]
        if index == indexPath.row {
            cell.backgroundColor = UIColor(named: "mygreen")
            cell.orderStatusLabel.textColor = .white
        }else{
            cell.backgroundColor = .white
            cell.orderStatusLabel.textColor = .black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath.row
        if indexPath.row == 0 {
            fetchOrder()
        }else if indexPath.row == 1 {
            fetchOrder(status: "placed")
        }else if indexPath.row == 2 {
            fetchOrder(status: "pending")
        }else if indexPath.row == 3 {
            fetchOrder(status: "processing")
        }else if indexPath.row == 4 {
            fetchOrder(status: "confirmed")
        }else if indexPath.row == 5 {
            fetchOrder(status: "delivered")
        }else if indexPath.row == 6 {
            fetchOrder(status: "declined")
        }
        orderStatusCollectionView.scrollToItem(at: IndexPath(item: index ?? 0, section: 0), at: .centeredHorizontally, animated: true)
        orderStatusCollectionView.reloadData()
        
    }
    
    func fetchOrder(){
        DispatchQueue.main.async {
            self.orderDataManager.fetchOrdersData { (error) in
                if self.orderDataManager.order.count == 0{
                    self.noOrderView.isHidden = false
                    self.orderStatusTableView.isHidden = true
                    self.configureNoOrderView(status: nil)
                }else{
                    self.noOrderView.isHidden = true
                    self.orderStatusTableView.isHidden = false
                }
                self.orderStatusTableView.reloadData()
            }
        }
    }
        
        func fetchOrder(status : String){
            DispatchQueue.main.async {
                self.orderDataManager.fetchOrdersDataAccordingStatus(status: status){ (error) in
                    if self.orderDataManager.order.count == 0{
                        self.noOrderView.isHidden = false
                        self.orderStatusTableView.isHidden = true
                        self.configureNoOrderView(status: self.orderStatusArray[self.index ?? 0])
                    }else{
                        self.noOrderView.isHidden = true
                        self.orderStatusTableView.isHidden = false
                    }
                    self.orderStatusTableView.reloadData()
                }
            }
        }
    
    func configureNoOrderView(status : String?){
        self.contentView.addSubview(self.noOrderView)
        self.noOrderView.anchor(top: orderStatusCollectionView.bottomAnchor, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, right: self.contentView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        self.noOrderView.addSubview(self.noOrderImageView)
        self.noOrderImageView.anchor(top: self.noOrderView.topAnchor, left: self.noOrderView.leftAnchor, right: self.noOrderView.rightAnchor, paddingTop: 100, paddingLeft: 60, paddingRight: 60, width: self.noOrderView.frame.width - 120, height: 200)
        self.noOrderView.addSubview(self.noOrderLbl)
        self.noOrderLbl.anchor(top: self.noOrderImageView.bottomAnchor, left: self.noOrderView.leftAnchor, right: self.noOrderView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: self.noOrderView.frame.width - 40, height: 60)
        if status != nil {
            self.noOrderLbl.text = "No \(String(describing: status!)) Order"
        }else{
            self.noOrderLbl.text = "No Order"
        }
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
        return UIEdgeInsets(top:0, left: 20, bottom: 0, right: 70)
    }
    
}

extension OrderViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderDataManager.order.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderTableViewCell else {return UITableViewCell() }
        cell.configureUI(order: self.orderDataManager.order[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let orderDetailVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        orderDetailVC.index = indexPath.row
        orderDetailVC.modalPresentationStyle = .fullScreen
        self.present(orderDetailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
