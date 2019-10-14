//
//  ContactDetailViewController.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 13/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    var oldBottomInset: CGFloat = 0.0
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    var compactWidthConstraint: NSLayoutConstraint!
    var compactHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        self.view.addGestureRecognizer(tapGesture)
        
        let views: [String: UIView] = ["contactImage": contactImage, "contactNameLabel": contactNameLabel]
        var allConstraints = [NSLayoutConstraint]()
        compactWidthConstraint = contactImage.widthAnchor.constraint(equalToConstant: 60)
        compactHeightConstraint = contactImage.heightAnchor.constraint(equalToConstant: 60)
        let verticalPositioningConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-[contactImage]-[contactNameLabel]",
        options: [.alignAllCenterX], metrics: nil, views: views)
        allConstraints += verticalPositioningConstraints
        let centerXConstraint = contactImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        allConstraints.append(centerXConstraint)
        allConstraints.append(compactWidthConstraint)
        allConstraints.append(compactHeightConstraint)
        NSLayoutConstraint.activate(allConstraints)
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
