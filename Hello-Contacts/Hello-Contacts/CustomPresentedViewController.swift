//
//  CustomPresentedViewController.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 17/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit

class CustomPresentedViewController: UIViewController, UIViewControllerTransitioningDelegate {


 var hideAnimator: CustomModalHideAnimator?

  override func viewDidLoad() {
    super.viewDidLoad()
    transitioningDelegate = self
    hideAnimator = CustomModalHideAnimator(withViewController: self)
  }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return hideAnimator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      return hideAnimator
    } 
}


