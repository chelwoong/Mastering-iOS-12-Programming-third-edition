//
//  ContactDetailShowAnimator.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 02/11/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit

class ContactDetailShowAnimator: NSObject {
    
}


extension ContactDetailShowAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // 1
    guard let toViewController = transitionContext.viewController(forKey: .to),
      let fromViewController = transitionContext.viewController(forKey: .from),
      let overviewViewController = fromViewController as? ContactsCollectionViewController,
      let tappedIndex = overviewViewController.collectionView.indexPathsForSelectedItems?.first,
      let tappedCell = overviewViewController.collectionView.cellForItem(at: tappedIndex) as? ContactCollectionViewCell
      else { return }

    // 2
    let contactImageFrame = tappedCell.contactImageView.frame
    let startFrame = overviewViewController.view.convert(contactImageFrame, from: tappedCell)

    toViewController.view.frame = startFrame
    toViewController.view.layer.cornerRadius = startFrame.height / 2

    transitionContext.containerView.addSubview(toViewController.view)

    let animationTiming = UICubicTimingParameters(animationCurve: .easeInOut)

    let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: animationTiming)

    animator.addAnimations {
      toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
      toViewController.view.layer.cornerRadius = 0
    }

    animator.addCompletion { finished in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }

    animator.startAnimation()
  }
}
