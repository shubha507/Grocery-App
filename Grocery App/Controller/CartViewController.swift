//
//  CartViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit

class CartViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, passQuantityChangeData {
    
    var dataManager = DataManager()
    
    @IBOutlet weak var cartTblView: UITableView!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var checkoutButtonView: UIView!
    @IBOutlet weak var backViewInCart: UIView!
    
    private let noProductInCartImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "no-product"))
        iv.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let noProductInCartView : UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
        uv.layer.cornerRadius = 30
        return uv
    }()
    
    private let oopsLblInCart : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 35)
        lbl.textColor = .red
        lbl.text = "Oops!"
        lbl.textAlignment = .center
    return lbl
    }()
    
    private let noProductLblInCart : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 25)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
    return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTblView.layer.cornerRadius = 30
        cartTblView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.backgroundColor = UIColor(named: "mygreen")
        cartTblView.delegate = self
        cartTblView.dataSource = self
        cartTblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        configureEmptyCartViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CartManager.shared.productAddedToCart.count != 0 {
            cartTblView.isHidden = false
            checkoutButtonView.isHidden = false
            noProductInCartView.isHidden = true
            backViewInCart.backgroundColor = UIColor(named: "buttoncolor")
            totalLabel.text = "₹\(totalPriceInCart()!)"
        cartTblView.reloadData()
        }else{
            cartTblView.isHidden = true
            checkoutButtonView.isHidden = true
            noProductInCartView.isHidden = false
            configureEmptyCartViewUI()
        }
    }
    
    func totalPriceInCart()->Int?{
        var sum = 0
        for products in CartManager.shared.productAddedToCart {
            sum = sum + (products.price! * products.quantity)
        }
        return sum
    }
    
    func configureEmptyCartViewUI(){
        self.backViewInCart.backgroundColor = UIColor(red: 163/255, green: 194/255, blue: 194/255, alpha: 1)
        self.backViewInCart.addSubview(self.noProductInCartView)
        self.noProductInCartView.anchor(top: self.backViewInCart.topAnchor, left: self.backViewInCart.leftAnchor, bottom: self.backViewInCart.bottomAnchor, right: self.backViewInCart.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        self.noProductInCartView.addSubview(self.noProductInCartImageView)
        self.noProductInCartImageView.anchor(top: self.noProductInCartView.topAnchor, left: self.noProductInCartView.leftAnchor, right: self.noProductInCartView.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20, width: self.noProductInCartView.frame.width - 40, height: 250)
        self.noProductInCartView.addSubview(self.oopsLblInCart)
        self.oopsLblInCart.anchor(top: self.noProductInCartImageView.bottomAnchor, left: self.noProductInCartView.leftAnchor, right: self.noProductInCartView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, width: self.noProductInCartView.frame.width - 40, height: 40)
        self.noProductInCartView.addSubview(self.noProductLblInCart)
        self.noProductLblInCart.anchor(top: self.oopsLblInCart.bottomAnchor, left: self.noProductInCartView.leftAnchor, right: self.noProductInCartView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, width: self.noProductInCartView.frame.width - 40, height: 60)
        self.noProductLblInCart.text = "Your Cart is Empty, Add products"
    }
    
    func quantityChanged(cellIndex: Int?, quant: Int?, isQuantViewOpen: Bool?) {
        if quant! > 0 {
            CartManager.shared.productAddedToCart[cellIndex!].quantity = quant!
            print(quant!)
            cartTblView.reloadData()
            totalLabel.text = "₹\(totalPriceInCart()!)"
        }else{
            CartManager.shared.productAddedToCart[cellIndex!].quantity = quant!
            CartManager.shared.productAddedToCart[cellIndex!].isAddedToCart = false
            CartManager.shared.productAddedToCart[cellIndex!].isQuantityViewOpen = false
            CartManager.shared.productAddedToCart.remove(at: cellIndex!)
            totalLabel.text = "₹\(totalPriceInCart()!)"
            if CartManager.shared.productAddedToCart.count == 0 {
                self.cartTblView.isHidden = true
                self.checkoutButtonView.isHidden = true
                self.configureEmptyCartViewUI()
                self.noProductInCartView.isHidden = false
                NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
            }
            cartTblView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CartManager.shared.productAddedToCart.count != 0 {
            return CartManager.shared.productAddedToCart.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTableViewCell
        cell.configureCellUI(product: CartManager.shared.productAddedToCart[indexPath.row])
        cell.cellIndex = indexPath.row
        cell.delegate = self
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
            CartManager.shared.productAddedToCart[indexPath.row].isAddedToCart = false
            CartManager.shared.productAddedToCart[indexPath.row].isQuantityViewOpen = false
            CartManager.shared.productAddedToCart[indexPath.row].quantity = 0
            CartManager.shared.productAddedToCart.remove(at: indexPath.row)
            self.cartTblView.deleteRows(at: [indexPath], with: .automatic)
            if CartManager.shared.productAddedToCart.count == 0 {
                self.cartTblView.isHidden = true
                self.checkoutButtonView.isHidden = true
                self.configureEmptyCartViewUI()
                self.noProductInCartView.isHidden = false
                NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
            }
            completion(true)
        }
        action.backgroundColor = .white
        action.image = UIImage(named: "noun_Delete_920406")
       return action
    }
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        removeAllProductsAfterCheckout()
        configureEmptyCartViewUI()
        noProductInCartView.isHidden = false
        checkoutButtonView.isHidden = true
        cartTblView.isHidden = true
        
    }
    
    func removeAllProductsAfterCheckout(){
        for products in CartManager.shared.productAddedToCart {
            products.quantity = 0
            products.isQuantityViewOpen = false
            products.isAddedToCart = false
        }
    CartManager.shared.productAddedToCart.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
    }
}

