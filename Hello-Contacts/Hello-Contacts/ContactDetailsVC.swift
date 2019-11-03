//
//  ContactDetailsVC.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 14/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit


class ContactDetailsVC: UIViewController {
       
    var contact: Contact?
    @IBOutlet var contactPhoneLabel: UILabel!
    @IBOutlet var contactEmailLabel: UILabel!
    @IBOutlet var contactAddressLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        if let contact = self.contact {
           // 1
           contact.fetchImageIfNeeded { [weak self] image in
             self?.contactImage.image = image
           }

           contactNameLabel.text = "\(contact.givenName) \(contact.familyName)"
           contactPhoneLabel.text = contact.phoneNumber
           contactEmailLabel.text = contact.emailAddress
           contactAddressLabel.text = contact.address
         }
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                                    name: UIApplication.keyboardWillShowNotification,
                                                    object: nil)

             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                                    name: UIApplication.keyboardWillHideNotification,
                                                    object: nil)
             
             let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
             self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapOnScreen() {
           self.view.endEditing(true)
       }

       @objc func keyboardWillAppear(_ notification: Notification) {
         guard let userInfo = notification.userInfo,
           // 1
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
           else { return }

       
           scrollViewBottomConstraint.constant = -keyboardFrame.cgRectValue.size.height
         UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self ] in
           // 3
           self?.view.layoutIfNeeded()
         })
       }

       @objc func keyboardWillHide(_ notification: Notification) {
         guard let userInfo = notification.userInfo,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
           else { return }

           scrollViewBottomConstraint.constant = 0
         UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self ] in
           self?.view.layoutIfNeeded()
         })
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
