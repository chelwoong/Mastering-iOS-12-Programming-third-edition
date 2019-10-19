//
//  StackViewContactDetailsViewController.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 14/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit

class StackViewContactDetailsViewController: ContactDetailsVC {

    let dampingRatio: CGFloat = 0.5
    @IBOutlet var drawer: UIView!
    var isDrawerOpen = false
    var drawerPanStart: CGFloat = 0
    var animator: UIViewPropertyAnimator?
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanOnDrawer(recognizer:)))
        self.view.addGestureRecognizer(panGesture)
        // Do any additional setup after loading the view.
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


extension StackViewContactDetailsViewController {
    @IBAction func toggleDrawerClicked(_ sender: Any) {
        setupAnimation()
        animator?.startAnimation()
    }
    
    func setupAnimation() {
        guard animator == nil || animator?.isRunning == false else { return }
        let spring: UISpringTimingParameters
         if self.isDrawerOpen {
           spring = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: CGVector(dx: 0, dy: 10))
         } else {
           spring = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: CGVector(dx: 0, dy: -10))
         }
        animator = UIViewPropertyAnimator(duration: 1, timingParameters: spring)
        animator?.addAnimations { [weak self] in
            guard let self = self else { return }
            if self.isDrawerOpen {
                self.drawer.transform = CGAffineTransform.identity
            } else {
                self.drawer.transform = CGAffineTransform(translationX: 0, y: -305)
            }
        }
        animator?.addCompletion { [weak self ](postion) in
            guard let self = self else { return }
            self.animator = nil
            self.isDrawerOpen = !(self.drawer.transform == CGAffineTransform.identity)
        }
        
    }
    
    @objc func didPanOnDrawer(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            setupAnimation()
            animator?.pauseAnimation()
            drawerPanStart = animator?.fractionComplete ?? 0
        case .changed:
            
            print("\(recognizer.translation(in: drawer).y) + \(drawerPanStart) = \((recognizer.translation(in: drawer).y / -305) + drawerPanStart)")
            if self.isDrawerOpen {
                
                animator?.fractionComplete = (recognizer.translation(in: drawer).y / 305) + drawerPanStart
            } else {
                
                animator?.fractionComplete = (recognizer.translation(in: drawer).y / -305) + drawerPanStart
            }
        default:
            drawerPanStart = 0
            let currentVelocity = recognizer.velocity(in: drawer)
            let spring = UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: CGVector(dx: 0, dy: currentVelocity.y))
            
            animator?.continueAnimation(withTimingParameters: spring, durationFactor: 0)
            let isSwipingDown = currentVelocity.y > 0
            if isSwipingDown == !isDrawerOpen {
                animator?.isReversed = true
            }
        }
    }
    
}
