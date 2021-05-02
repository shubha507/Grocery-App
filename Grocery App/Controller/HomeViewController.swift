//
//  HomeViewController.swift
//  Grocery App
//
//  Created by Shubha Sachan on 28/04/21.
//

import UIKit
import FirebaseAuth

class HomeViewController : UIViewController, UITableViewDelegate {
    
    private let imageView : UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iv.image = UIImage(named: "bird2")
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    private let hiLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Hey"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let searchFoodLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Lets search your grocery food."
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let profileButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func profileButtonTapped(){
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
       } catch let signOutError as NSError {
         print ("Error signing out: %@", signOutError)
       }
    }
    
    private let searchTextField : UISearchTextField = {
        let stf = UISearchTextField()
        stf.layer.cornerRadius = 20
        stf.placeholder = "Search your daily grocery food..."
        stf.backgroundColor = .white
        return stf
    }()
    
    private let tblView : UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(named: "buttoncolor")
        tv.register(FirstTableViewCell.self, forCellReuseIdentifier: "cell")
        tv.layer.cornerRadius = 30
        tv.register(SecondTableViewCell.self, forCellReuseIdentifier: "cell1")
        tv.alwaysBounceVertical = false
        return tv
    }()

    override func viewDidLoad() {
        super .viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mygreen")
        tblView.delegate = self
        tblView.dataSource = self
        configureUI()
        
        
    }
    
    @objc func seeDetailView(){
        let controller = CategoriesViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func configureUI(){
        view.addSubview(profileButton)
        profileButton.setDimensions(height: 50, width: 50)
        profileButton.addSubview(imageView)
        profileButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 60, paddingRight: 30)
        profileButton.layer.cornerRadius = 25
        imageView.anchor(top: profileButton.topAnchor, left: profileButton.leftAnchor, bottom: profileButton.bottomAnchor, right: profileButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        view.addSubview(hiLabel)
        hiLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 60, paddingLeft: 30,width: view.frame.width - 100, height: 25)
        
        view.addSubview(searchFoodLabel)
        searchFoodLabel.anchor(top: hiLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 30,width: view.frame.width - 90, height: 25)
        
        view.addSubview(searchTextField)
        searchTextField.anchor(top: searchFoodLabel.bottomAnchor, left: view.leftAnchor, paddingTop : 25, paddingLeft: 30, width: view.frame.width - 60, height: 55)
        
        view.addSubview(tblView)
        tblView.anchor(top: searchTextField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        tblView.separatorStyle = .none
        tblView.allowsSelection = false
        
    }
}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row%2 == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FirstTableViewCell
            cell.seeAllButton.addTarget(self, action: #selector(seeDetailView), for: .touchUpInside)
            cell.firstCellCollection.reloadData()
        return cell
        }else{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1") as! SecondTableViewCell
            return cell1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row%2 == 0{
           return 250
        }else {
            return 180
        }
        
    }

}
 

