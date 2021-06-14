//
//  ProductCollectionViewCell.swift
//  Grocery App
//
//  Created by Shubha Sachan on 05/05/21.
//

import UIKit

class ProductCollectionViewCell : UICollectionViewCell {
    
    var isQuantityViewOpen : Bool?
    
    var cellNumber : Int?
    
    var quantity : Double?
    
    var dataManager = DataManager()
    
    var delegate : passQuantityChangeData?
    
    let minusButton : UIButton = {
        let uv = UIButton(type: .system)
        uv.setImage(UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .large)), for: .normal)
        uv.tintColor = .white
        uv.backgroundColor = UIColor(named: "mygreen")
        uv.layer.cornerRadius = 10
        uv.layer.maskedCorners = [.layerMinXMinYCorner]
        uv.setDimensions(height: 35, width: 35)
        return uv
    }()
    
    let quantityLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.setDimensions(height: 35, width: 35)
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(named: "mygreen")
       return lbl
    }()
    
    
    
    let plusGreenViewButton : UIButton = {
        let uv = UIButton(type: .system)
        uv.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .large)), for: .normal)
        uv.tintColor = .white
        uv.backgroundColor = UIColor(named: "mygreen")
        uv.layer.cornerRadius = 10
        uv.layer.maskedCorners = [.layerMinXMinYCorner]
        uv.setDimensions(height: 35, width: 35)
        return uv
    }()
    
    let plusButton : UIButton = {
        let uv = UIButton(type: .system)
        uv.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold, scale: .large)), for: .normal)
        uv.tintColor = .white
        uv.backgroundColor = UIColor(named: "mygreen")
        uv.layer.cornerRadius = 10
        uv.layer.maskedCorners = [.layerMinXMinYCorner]
        return uv
    }()
    
    let cellImage : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
       return iv
   }()
    
    let nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let strikeOutPriceLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = .systemGray2
        lbl.textAlignment = .left
        return lbl
    }()
    
    let priceLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = UIColor(named: "mygreen")
        lbl.textAlignment = .left
        return lbl
    }()
    
    let discountLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textColor = UIColor(named: "mygreen")
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let cellBorderView : UIView = {
        let vw = UIView()
        vw.backgroundColor = .lightGray
        return vw
    }()
    
    private let cellHorizntalBorderView : UIView = {
        let vw = UIView()
        vw.backgroundColor?.withAlphaComponent(0.5)
        vw.backgroundColor = .lightGray
        return vw
    }()
    
    let greenView : UIView = {
        let gv = UIView()
        gv.backgroundColor = UIColor(named: "mygreen")
        gv.layer.cornerRadius = 10
        gv.layer.maskedCorners = [.layerMinXMinYCorner]
        gv.isHidden = true
        return gv
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(cellImage)
        cellImage.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, width: 80, height: 160)
        
        contentView.addSubview(nameLabel)
        nameLabel.anchor(top: cellImage.bottomAnchor, left: leftAnchor, paddingTop:5, paddingLeft: 10, width: frame.width-37)
//        nameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        
        contentView.addSubview(priceLabel)
        priceLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor,  paddingTop: 5, paddingLeft: 10, width: frame.width-37)
        
        contentView.addSubview(strikeOutPriceLabel)
        strikeOutPriceLabel.anchor(top: priceLabel.bottomAnchor, left: leftAnchor,bottom: bottomAnchor,  paddingTop: 5, paddingLeft: 10,paddingBottom: 5)
        
        contentView.addSubview(discountLabel)
        discountLabel.anchor(top: priceLabel.bottomAnchor, left: strikeOutPriceLabel.rightAnchor,bottom: bottomAnchor,  paddingTop: 5, paddingLeft: 10,paddingBottom: 5)
        
        contentView.addSubview(plusButton)
        plusButton.anchor( bottom: bottomAnchor, right: rightAnchor, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(greenView)
        greenView.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 0, paddingRight: 0, width: 35, height: 115)
        
        configureStackView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addVerticalView(){
        contentView.addSubview(cellBorderView)
        cellBorderView.anchor(top: topAnchor, right: rightAnchor, paddingTop: 0, paddingRight: 0, width: 0.3, height: 300)
    }
    
    func addHorizontalView(){
        contentView.addSubview(cellHorizntalBorderView)
        cellHorizntalBorderView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: frame.width, height: 0.3)
    }
    
    @objc func plusButtonTapped(){
        plusButton.isHidden = true
        greenView.isHidden = false
        quantity = quantity!+1
        quantityLabel.text = "\(Int(quantity!))"
        isQuantityViewOpen = true
        delegate?.quantityChanged(cellIndex: cellNumber, quant: quantity, isQuantViewOpen: isQuantityViewOpen)
    }
    
    func configureStackView(){
        let stack = UIStackView(arrangedSubviews: [minusButton,quantityLabel,plusGreenViewButton])
        stack.spacing = 5
        stack.axis = .vertical
        plusGreenViewButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        greenView.addSubview(stack)
        stack.anchor(top: greenView.topAnchor, left: greenView.leftAnchor, bottom: greenView.bottomAnchor, right: greenView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 35, height: 115)
    }

    @objc func increaseQuantity(){
        quantity = quantity!+1
        quantityLabel.text = "\(Int(quantity!))"
        isQuantityViewOpen = true
        delegate?.quantityChanged(cellIndex: cellNumber, quant: quantity, isQuantViewOpen: isQuantityViewOpen)
    }
    
    @objc func decreaseQuantity(){
        if quantity! > 1{
            quantity = quantity!-1
            quantityLabel.text = "\(Int(quantity!))"
            delegate?.quantityChanged(cellIndex: cellNumber, quant: quantity, isQuantViewOpen: isQuantityViewOpen)
            isQuantityViewOpen = true
        }else{
            quantity = 0
            plusButton.isHidden = false
            greenView.isHidden = true
            isQuantityViewOpen = false
            delegate?.quantityChanged(cellIndex: cellNumber, quant: quantity, isQuantViewOpen: isQuantityViewOpen)
        }
    }
    
    func configureCellUI(product : Product){
        nameLabel.text = product.name!
        if let discount = product.discount, discount != 0.0 {
            discountLabel.isHidden = false
            strikeOutPriceLabel.isHidden = false
       let exactPriceAfterDiscount = product.price!-(product.price!*(product.discount!/100))
        priceLabel.text = "₹\(Int(exactPriceAfterDiscount))"
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₹\(Int(product.price!))")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        discountLabel.text = "\(Int(product.discount!))% off"
        strikeOutPriceLabel.attributedText = attributeString
        }else {
            priceLabel.text = "₹\(Int(product.price!))"
            discountLabel.isHidden = true
            strikeOutPriceLabel.isHidden = true
        }
       
        quantity = product.quantity
        quantityLabel.text = "\(Int(product.quantity))"
        isQuantityViewOpen = product.isQuantityViewOpen
        dataManager.getImageFrom(url: product.url!, imageView: cellImage)
        if isQuantityViewOpen! {
            plusButton.isHidden = true
            greenView.isHidden = false
        }else{
            plusButton.isHidden = false
            greenView.isHidden = true
        }
        if !product.isAddedToCart  && isQuantityViewOpen! {
            AppSharedDataManager.shared.productAddedToCart.append(product)
            NotificationCenter.default.post(name: NSNotification.Name("NumberOfProductsAddedToCart"), object: nil)
            product.isAddedToCart = true
        }
    }
}
