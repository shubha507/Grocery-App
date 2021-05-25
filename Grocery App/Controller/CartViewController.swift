//
//  CartViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit

class CartViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cartTblView: UITableView!
    
    var productAddedToCart = ["Apple","Grapes","Mango","Papaya"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTblView.layer.cornerRadius = 30
        cartTblView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.backgroundColor = UIColor(named: "mygreen")
        cartTblView.delegate = self
        cartTblView.dataSource = self
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productAddedToCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell
        cell.productNameLabel.text = "\(productAddedToCart[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at : indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath : IndexPath)->UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.productAddedToCart.remove(at: indexPath.row)
            self.cartTblView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .white
        action.image = UIImage(named: "noun_Delete_920406")
       return action
    }
}

