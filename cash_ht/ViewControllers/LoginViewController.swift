//
//  LoginViewController.swift
//  cash_ht
//
//  Created by Anatolii on 7/25/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import UIKit

enum warningLabel {
    case login
    case password
    case loginAndPassword
}

enum warningType: String {
    case fieldIsEmpty = "field is empty. Please fill it"
    case userNotFound = "user is not found with such login"
    case userFound = "user found"
    case incorrectPassword = "wrong password for this user"
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginWarningLAbel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    @IBOutlet weak var loginLineView: UIView!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var loginWarningLabelConstrain: NSLayoutConstraint!
    @IBOutlet weak var passwordWarningLabelConstrain: NSLayoutConstraint!
    
    var userArray: [User] = []
    var currentUser: User?
    var cashManager = RealmManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        loginButton.layer.cornerRadius = 8
    }
    
    func update(userArrayFromDB: [User]) {
        userArray = userArrayFromDB
    }
    
    func userValidation() -> Bool {
        constrainPriorities(constrainLabel: .loginAndPassword)
        guard !(loginTextField.text?.isEmpty ?? false) else {
            showWarning(warningFied: .login, warningText: .fieldIsEmpty)
            return false
        }
        guard !(passwordTextField.text?.isEmpty ?? false) else {
            showWarning(warningFied: .password, warningText: .fieldIsEmpty)
            return false
        }
        let userFoundStatus = findUserByLoginAndPassword()
        guard userFoundStatus == .userFound else {
            if userFoundStatus == .userNotFound {
                showWarning(warningFied: .login, warningText: userFoundStatus)
            }
            else if userFoundStatus == .incorrectPassword {
                showWarning(warningFied: .password, warningText: userFoundStatus)
            }
            return false
        }
        return true
    }
    
    func findUserByLoginAndPassword() -> warningType {
        var currentUserArray = userArray.filter {$0.login.contains(loginTextField.text ?? "")}
        if currentUserArray.count == 1 {
            if let current = currentUserArray.first {
                guard current.login == loginTextField.text else {
                    return .userNotFound
                }
            }
        }
        else {
            return .userNotFound
        }
        currentUserArray = currentUserArray.filter {$0.password.contains(passwordTextField.text ?? "")}
        if currentUserArray.count == 1 {
            if let current = currentUserArray.first {
                guard current.password == passwordTextField.text else {
                    return .incorrectPassword
                }
                currentUser = current
                return .userFound
            }
        }
        else {
            return .incorrectPassword
        }
        return .userFound
    }
    
    func showWarning(warningFied: warningLabel, warningText: warningType) {
        switch warningFied {
        case .login:
            loginWarningLAbel.text = warningText.rawValue
            constrainPriorities(constrainLabel: .login)
        case .password:
            passwordWarningLabel.text = warningText.rawValue
            constrainPriorities(constrainLabel: .password)
        default:
            true
        }
    }
    
    func constrainPriorities(constrainLabel: warningLabel) {
        switch constrainLabel {
        case .login:
            loginWarningLabelConstrain.priority = UILayoutPriority(rawValue: 600)
            loginLineView.backgroundColor = .red
        case .password:
            passwordWarningLabelConstrain.priority = UILayoutPriority(rawValue: 600)
            passwordLineView.backgroundColor = .red
        case .loginAndPassword:
            loginWarningLabelConstrain.priority = UILayoutPriority(rawValue: 800)
            passwordWarningLabelConstrain.priority = UILayoutPriority(rawValue: 800)
            loginLineView.backgroundColor = .white
            passwordLineView.backgroundColor = .white
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard userValidation() else {
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.update(user: currentUser)
        cashManager.writeUser(object: currentUser)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
