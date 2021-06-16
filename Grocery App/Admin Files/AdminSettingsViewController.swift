//
//  AdminSettingsViewController.swift
//  Grocery App
//
//  Created by Souryadeep Sadhukhan on 14/06/21.
//

import UIKit

class AdminSettingsViewController: UIViewController {

    @IBOutlet weak var logoutButtonAdminSettingsController: UIButton!
    @IBOutlet weak var saveButtonAdminSettingsController: UIButton!
    @IBOutlet weak var profileAddressTextField: UITextField!
    @IBOutlet weak var profileNumberTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButtonAdminSettingsController.layer.cornerRadius = 10
        saveButtonAdminSettingsController.layer.cornerRadius = 10
        
        profileImage.layer.cornerRadius = 5
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
    
}
