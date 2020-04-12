//
//  Animator.swift
//  Animation
//
//  Created by Admin on 11/22/19.
//  Copyright © 2019 Eratos. All rights reserved.
//

import UIKit

class Animator: NSObject,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var duration = 0.5
    fileprivate var isPresenting = true
    var cellImageViews : [UIView?] = []
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //heavy work to be done
        guard let toViewController = transitionContext.viewController(forKey: .to) else{return}
        guard let fromViewController = transitionContext.viewController(forKey: .from) else{return}
        let container = transitionContext.containerView
        
        for (index, cellImageView) in cellImageViews.enumerated() {
            let tag = (index + 1) * 1000
            
            cellImageView?.alpha = 1
            let toTargetCopy = cellImageView?.snapShotView()
            let fromTargetCopy = cellImageView?.snapShotView()
            
            if isPresenting{
                toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
                container.addSubview(toViewController.view)
                toViewController.view.alpha = 0
                container.bringSubviewToFront(toViewController.view)
                toViewController.view.layoutIfNeeded()
                
                //add a copy at the right location in both views
                //set our frame based on the window
                if fromTargetCopy != nil && toTargetCopy != nil && cellImageView != nil && toViewController.view.viewWithTag(tag) != nil{
                    let keyWindow = UIApplication.shared.keyWindow
                    toTargetCopy?.frame = cellImageView!.convert(cellImageView!.bounds, to: keyWindow)
                    fromTargetCopy?.frame = cellImageView!.convert(cellImageView!.bounds, to: keyWindow)
                    //add from to the from view and the toTarget to the toViewController
                    fromViewController.view.addSubview(fromTargetCopy!)
                    toViewController.view.addSubview(toTargetCopy!)
                    
                    // we need to hide the real views
                    cellImageView?.alpha = 0
                    let toDetailImageView = toViewController.view.viewWithTag(tag)!
                    toDetailImageView.alpha = 0
                    //perform our animation with target frame
                    let targetFrame = toViewController.view.viewWithTag(tag)!.convert(toDetailImageView.bounds, to: keyWindow)
                    
                    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                        toTargetCopy?.frame = targetFrame
                        fromTargetCopy?.frame = targetFrame
//
                        if index > 0 {
                            toTargetCopy?.alpha = 0
                            fromTargetCopy?.alpha = 0
                        }
                    }, completion: nil)
                }
                
                
                UIView.animate(withDuration: duration, animations: {
                    toViewController.view.alpha = 1
                    
                }, completion: { (finished) in
                    transitionContext.completeTransition(true)
                    toTargetCopy?.removeFromSuperview()
                    fromTargetCopy?.removeFromSuperview()
                    if index == 0 {
                        toViewController.view.viewWithTag(tag)?.alpha = 1
                    }
                })
                
            }else{
                if fromViewController.modalPresentationStyle == UIModalPresentationStyle.none{
                    toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
                    container.addSubview(toViewController.view)
                    container.sendSubviewToBack(toViewController.view)
                }
                
                if fromTargetCopy != nil && toTargetCopy != nil && cellImageView != nil{
                    
                    let keyWindow = UIApplication.shared.keyWindow
                    
                    let detailImageView = fromViewController.view.viewWithTag(tag)!
                    toTargetCopy?.frame = detailImageView.convert(detailImageView.bounds, to: keyWindow)
                    fromTargetCopy?.frame = detailImageView.convert(detailImageView.bounds, to: keyWindow)
                    
                    
                    let targetFrame = cellImageView!.convert(cellImageView!.bounds, to: keyWindow)
                    
                    //add from to the from view and the toTarget to the toViewController
                    fromViewController.view.addSubview(fromTargetCopy!)
                    toViewController.view.addSubview(toTargetCopy!)
                    
                    cellImageView?.alpha = 0
                    detailImageView.alpha = 0
                    
                    
                    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                        toTargetCopy?.frame = targetFrame
                        fromTargetCopy?.frame = targetFrame
                        
//                        if index > 0 {
//                            toTargetCopy?.alpha = 1
//                            fromTargetCopy?.alpha = 1
//                        }
                    }, completion: nil)
                }
                
                UIView.animate(withDuration: duration, animations: {
                    fromViewController.view.alpha = 0
                    
                }, completion: { (finished) in
                    toViewController.view.viewWithTag(tag)?.alpha = 1
                    cellImageView?.alpha = 1
                    toTargetCopy?.removeFromSuperview()
                    fromTargetCopy?.removeFromSuperview()
                    
                    if index == self.cellImageViews.count - 1 {
                        transitionContext.completeTransition(true)
                    }
                })
            }
        }
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
}
