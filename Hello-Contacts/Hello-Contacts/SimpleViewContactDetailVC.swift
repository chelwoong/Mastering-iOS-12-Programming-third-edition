//
//  ContactDetailViewController.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 13/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit



class SimpleViewContactDetailVC: ContactDetailsVC {

    var oldBottomInset: CGFloat = 0.0
    var compactWidthConstraint: NSLayoutConstraint!
    var compactHeightConstraint: NSLayoutConstraint!
    var regularWidthConstraint: NSLayoutConstraint!
    var regularHeightConstraint: NSLayoutConstraint!
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
        regularWidthConstraint = contactImage.widthAnchor.constraint(equalToConstant: 120)
        regularHeightConstraint = contactImage.heightAnchor.constraint(equalToConstant: 120)
        
        let verticalPositioningConstraints = NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-[contactImage]-[contactNameLabel]",
        options: [.alignAllCenterX], metrics: nil, views: views)
        allConstraints += verticalPositioningConstraints
        let centerXConstraint = contactImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        allConstraints.append(centerXConstraint)
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            allConstraints.append(compactWidthConstraint)
            allConstraints.append(compactHeightConstraint)
        } else {
            allConstraints.append(regularWidthConstraint)
            allConstraints.append(regularHeightConstraint)
        }
        NSLayoutConstraint.activate(allConstraints)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)

      // 1
      guard let previousTraitCollection = previousTraitCollection,
         (previousTraitCollection.horizontalSizeClass != traitCollection.horizontalSizeClass ||
          previousTraitCollection.verticalSizeClass != traitCollection.verticalSizeClass)
        else { return}

      // 2
      if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
        NSLayoutConstraint.deactivate([compactHeightConstraint, compactWidthConstraint])
        NSLayoutConstraint.activate([regularHeightConstraint, regularWidthConstraint])
      } else {
        NSLayoutConstraint.deactivate([regularHeightConstraint, regularWidthConstraint])
        NSLayoutConstraint.activate([compactHeightConstraint, compactWidthConstraint])
      }
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
