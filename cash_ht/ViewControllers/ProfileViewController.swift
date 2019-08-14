//
//  ProfileViewController.swift
//  cash_ht
//
//  Created by Anatolii on 7/28/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import UIKit
import MessageUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var telephoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
        backButton.layer.cornerRadius = 5
        nameLabel.layer.cornerRadius = 5
        surnameLabel.layer.cornerRadius = 5
        ageLabel.layer.cornerRadius = 5
        cityLabel.layer.cornerRadius = 5
        adressLabel.layer.cornerRadius = 5
        photoImage.layer.cornerRadius = photoImage.frame.height / 2
    }
    
    func update(user: User?) {
        currentUser = user
    }
    
    func fillData() {
        nameLabel.text = currentUser?.name
        surnameLabel.text = currentUser?.surname
        cityLabel.text = currentUser?.city
        adressLabel.text = currentUser?.adress
        ageLabel.text = String(currentUser?.age ?? 0)
        photoImage.image = UIImage(named: currentUser?.photo ?? "")
        emailButton.setTitle(currentUser?.email, for: .normal)
        telephoneButton.setTitle(currentUser?.telephone, for: .normal)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        emailButton.titleLabel?.attributedText = NSAttributedString(string: currentUser?.email ?? "e-mail", attributes: underlineAttribute)
        telephoneButton.titleLabel?.attributedText = NSAttributedString(string: currentUser?.telephone ?? "telephone", attributes: underlineAttribute)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        sendEmail(email: currentUser?.email ?? "")
    }
    
    @IBAction func telephoneButtonPressed(_ sender: Any) {
        sendMessage(number: currentUser?.telephone ?? "")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        RealmManager.sharedInstance.deleteUserSession()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfileViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func sendMessage(number: String) {
        let messageCompose = MFMessageComposeViewController()
        messageCompose.messageComposeDelegate = self
        messageCompose.recipients = [number]
        messageCompose.body = "hello"
        messageCompose.subject = "hello"
        present(messageCompose, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail(email: String) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([email])
        composeVC.setSubject("Hello! ")
        composeVC.setMessageBody("Privet?", isHTML: false)
        present(composeVC, animated: true, completion: nil)
    }
    
}
