//
//  ContactDetailHideAnimator.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 02/11/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit


class ContactDetailHideAnimator: NSObject {
    var animator: UIViewImplicitlyAnimating?
}



extension ContactDetailHideAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    

    
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
      if let currentAnimator = self.animator {
        return currentAnimator
      }

      guard let toViewController = transitionContext.viewController(forKey: .to),
        let fromViewController = transitionContext.viewController(forKey: .from),
        let overviewViewController = toViewController as? ContactsCollectionViewController,
        let tappedIndex = overviewViewController.collectionView.indexPathsForSelectedItems?.first,
        let tappedCell = overviewViewController.collectionView.cellForItem(at: tappedIndex) as? ContactCollectionViewCell
        else { return UIViewPropertyAnimator() }
      

      transitionContext.containerView.addSubview(toViewController.view)
      transitionContext.containerView.addSubview(fromViewController.view)

      let animationTiming = UICubicTimingParameters(animationCurve: .easeInOut)

      let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: animationTiming)

      animator.addAnimations {
        let imageFrame = tappedCell.contactImageView.frame
        
        let targetFrame = overviewViewController.view.convert(imageFrame, from: tappedCell)
        
        fromViewController.view.frame = targetFrame
        fromViewController.view.layer.cornerRadius = tappedCell.contactImageView.frame.height / 2
      }

      animator.addCompletion { finished in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }

      self.animator = animator

      return animator
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      let animator = interruptibleAnimator(using: transitionContext)
      animator.startAnimation()
    }
    
    
}
