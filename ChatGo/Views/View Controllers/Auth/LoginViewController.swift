//
//  LoginViewController.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subviewSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameField.setRoundedCorner(cornerRadius: 8.0)
        loginButton.setRoundedCorner(cornerRadius: loginButton.bounds.height / 2)
    }
    
    // MARK: - IBAction
    @IBAction func loginTouchUpInside(_ sender: Any) {
        if validateField() {
            UserDefaults.standard.set(nameField.text!, forKey: Preferences.userData)
            Auth.auth().signInAnonymously(completion: nil)
            managerViewController?.showHomeScreen()
        }
    }
    
    // MARK: - Private Function
    private func subviewSettings() {
        titleLabel.text = Localify.get("app.name")
        nameLabel.text = Localify.get("auth.label.name")
        nameField.placeholder = Localify.get("auth.field.placeholder.name")
        loginButton.setTitle(Localify.get("auth.button.login"), for: .normal)
    }
    
    private func validateField() -> Bool {
        var errors = [String]()
        
        if nameField.text!.isEmpty {
            errors.append("Display Name cannot be empty")
        }
        
        if errors.isEmpty {
            return true
        }
        else {
            let message = errors.joined(separator: "\n")
            Alertify.displayAlert(
                title: "Field Invalid",
                message: message,
                sender: self)
            
            return false
        }
    }
}
