//
//  CartViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class CartViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, passQuantityChangeData {
    
    //Mark :- properties
    var dataManager = DataManager()
    let defaults = UserDefaults.standard
    var orderDataManager = OrderDataManager()
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
    
    //Mark :- Lifecycle method

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
        if AppSharedDataManager.shared.productAddedToCart.count != 0 {
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
    
    //Mark :- Helper Method

    func totalPriceInCart()->Double?{
        var sum = 0.0
        for products in AppSharedDataManager.shared.productAddedToCart {
            sum = sum + (products.price! * products.quantity)
        }
        return sum
    }
    
    func totalDiscountInCart()->Double?{
        var totalDiscount = 0.0
        for products in AppSharedDataManager.shared.productAddedToCart {
            totalDiscount = totalDiscount + (products.price! * (products.discount!/100))
        }
        return totalDiscount
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
    
    func removeAllProductsAfterCheckout(){
        for products in AppSharedDataManager.shared.productAddedToCart {
            products.quantity = 0
            products.isQuantityViewOpen = false
            products.isAddedToCart = false
        }
        AppSharedDataManager.shared.productAddedToCart.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
    }
    
    //Mark :- passQuantityChangeData delegate method

    func quantityChanged(cellIndex: Int?, quant: Double?, isQuantViewOpen: Bool?) {
        if quant! > 0 {
            AppSharedDataManager.shared.productAddedToCart[cellIndex!].quantity = quant!
            print(quant!)
            cartTblView.reloadData()
            totalLabel.text = "₹\(totalPriceInCart()!)"
        }else{
            AppSharedDataManager.shared.productAddedToCart[cellIndex!].quantity = quant!
            AppSharedDataManager.shared.productAddedToCart[cellIndex!].isAddedToCart = false
            AppSharedDataManager.shared.productAddedToCart[cellIndex!].isQuantityViewOpen = false
            AppSharedDataManager.shared.productAddedToCart.remove(at: cellIndex!)
            totalLabel.text = "₹\(totalPriceInCart()!)"
            if AppSharedDataManager.shared.productAddedToCart.count == 0 {
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
        if AppSharedDataManager.shared.productAddedToCart.count != 0 {
            return AppSharedDataManager.shared.productAddedToCart.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as? CartTableViewCell else {return UITableViewCell()}
        cell.configureCellUI(product: AppSharedDataManager.shared.productAddedToCart[indexPath.row])
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
    
    //Mark :- Action Method

    func deleteAction(at indexPath : IndexPath)->UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            AppSharedDataManager.shared.productAddedToCart[indexPath.row].isAddedToCart = false
            AppSharedDataManager.shared.productAddedToCart[indexPath.row].isQuantityViewOpen = false
            AppSharedDataManager.shared.productAddedToCart[indexPath.row].quantity = 0
            AppSharedDataManager.shared.productAddedToCart.remove(at: indexPath.row)
            self.cartTblView.deleteRows(at: [indexPath], with: .automatic)
            if AppSharedDataManager.shared.productAddedToCart.count == 0 {
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
        configureEmptyCartViewUI()
        noProductInCartView.isHidden = false
        checkoutButtonView.isHidden = true
        cartTblView.isHidden = true
        createOrder()
        removeAllProductsAfterCheckout()
    }
    
    func createOrder(){
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("orders").document()
        if let docId = ref?.documentID {
            let orderStatusArray = self.orderDataManager.getData(id: docId)
            ref?.setData([
            "name" : defaults.string(forKey: "name"),
            "contact" : Auth.auth().currentUser?.phoneNumber,
            "createdAt" : Timestamp(date: Date()),
            "createdBy" : Auth.auth().currentUser?.uid,
            "currentStatus" : "placed",
            "deliveryAddress" : defaults.string(forKey: "address"),
            "total" : totalPriceInCart(),
            "updatedAt" : Timestamp(date: Date()),
                "id": ref?.documentID,
                "allStatus" : orderStatusArray,
                "items" : dataManager.getData(productArray: AppSharedDataManager.shared.productAddedToCart),
                "totalDiscount" : totalDiscountInCart(),
                            "payableAmount" : (totalPriceInCart() ?? 0.0) - (totalDiscountInCart() ?? 0.0)
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
               
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let orderDetailVC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
                orderDetailVC.modalPresentationStyle = .fullScreen
                orderDetailVC.index = 0
                self.present(orderDetailVC, animated: true) {
                    self.tabBarController?.selectedIndex = 1
                }            }
        }
    }
    }
}
