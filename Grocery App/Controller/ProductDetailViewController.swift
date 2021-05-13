//
//  ProductDetailViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 10/05/21.
//

import UIKit

class ProductDetailViewController : UIViewController, UITableViewDelegate {
    
    var url : String?
    var name : String?
    var price : String?
    
    let dataManager = DataManager()
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var tblVw: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.getImageFrom(url: url, imageView: posterImageView, defaultImage: "Vegetables")
        
        tblVw.register(UINib(nibName: "ProductDetailFirstTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailFirstTableViewCell")
        tblVw.register(UINib(nibName: "ProductDetailSecondTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailSecondTableViewCell")
        tblVw.register(UINib(nibName: "ProductDetailThirdTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailThirdTableViewCell")
        tblVw.register(UINib(nibName: "ProductDetailFourthTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductDetailFourthTableViewCell")
        tblVw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
}
}

extension ProductDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFirstTableViewCell") as? ProductDetailFirstTableViewCell
        cell?.backgroundColor = UIColor(named: "buttoncolor")
        cell?.nameLabel.text = name
    
        return cell!
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailSecondTableViewCell") as? ProductDetailSecondTableViewCell
            return cell!
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailThirdTableViewCell") as? ProductDetailThirdTableViewCell
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailFourthTableViewCell") as? ProductDetailFourthTableViewCell
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
           return 250
        }else if indexPath.row == 1{
           return 460
        }else if indexPath.row == 2{
           return 360
        }else {
            return 120
        }
    }
    
}

