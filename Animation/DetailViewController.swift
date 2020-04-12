//
//  DetailViewController.swift
//  Animation
//
//  Created by Admin on 11/22/19.
//  Copyright © 2019 Eratos. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: -- Attributes
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: DraggableView!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationLeftConstraint: NSLayoutConstraint!
    
    var fadeView : UIImageView?
    
    // MARK: -- Override
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .clear
        fadeView = UIImageView(frame: view.bounds)
        fadeView?.image = UIImage(named: "background")
        fadeView?.contentMode = .scaleAspectFill
        fadeView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        fadeView?.backgroundColor = UIColor.white
        if let fv = fadeView{
            self.view.insertSubview(fv, at: 0)
        }
        
        // -- DraggableView --
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        
        containerView.delegate = self
    }

}

// MARK: -- UIScrollView Delegate
extension DetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustScrollViewInsets()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func adjustScrollViewInsets() {
        if scrollView.contentOffset.y < 0 {
            let leftMargin = (scrollView.frame.size.width - self.containerView.frame.size.width) * 0.5
            let topMargin = (scrollView.frame.size.height - self.containerView.frame.size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: topMargin, left: leftMargin, bottom: 0, right: 0)
        } else {
            if scrollView.contentInset != .zero {
                scrollView.contentInset = .zero
            }
        }
    }
}

// MARK: -- DraggableView Delegate
extension DetailViewController: DraggableViewDelegate {
    func panGestureDidBegin(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint) {
        //no need
    }
    
    func panGestureDidChange(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, velocityInView: CGPoint) {
        containerView?.center = CGPoint(
            x: containerView?.center.x ?? originalCenter.x,
            y: (containerView?.center.y ?? originalCenter.y) + translation.y)
        panGesture.setTranslation(CGPoint.zero, in: self.view)
        
        if containerView.center.y > containerView.bounds.height/2 {
            let alpha = 1 - (abs(containerView.bounds.height/2 - containerView.center.y)/(self.view.bounds.height))
            self.fadeView?.alpha = alpha
            self.navigationView.alpha = 1 - alpha
            self.descriptionView.alpha = 1 - alpha
            self.navigationLeftConstraint.constant = -75.0 * alpha
            self.descriptionLeftConstraint.constant = -175.0 * alpha
            self.view.layoutIfNeeded()
        }else{
            self.fadeView?.alpha = 1
            self.navigationView.alpha = 0
            self.descriptionView.alpha = 0
            self.navigationLeftConstraint.constant = -75.0
            self.descriptionLeftConstraint.constant = -175.0
            self.view.layoutIfNeeded()
        }
    }
    
    func panGestureDidEnd(_ panGesture: UIPanGestureRecognizer, originalCenter: CGPoint, translation: CGPoint, velocityInView: CGPoint) {
        if containerView.center.y >= containerView.bounds.height * 0.66{
            if let _ = transitioningDelegate{
                self.dismiss(animated: true, completion: nil)
            } else{
                //handle non custom presentation
                self.navigationLeftConstraint.constant = 0.0
                self.descriptionLeftConstraint.constant = 32.0
                UIView.animate(withDuration: 0.3, animations: {
                    self.navigationView.alpha = 1.0
                    self.descriptionView.alpha = 1.0
                    self.containerView.frame.origin.y = self.view.bounds.height
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    self.dismiss(animated: false, completion: nil)
                })
            }
            
            ///// Press Effect
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            
        } else if containerView.bounds.height > self.view.bounds.height {
            let y = (containerView.bounds.height * 0.5) - containerView.center.y
            let limit = (containerView.bounds.height - self.view.bounds.height)
            if (y < 0) {
                self.navigationLeftConstraint.constant = -75.0
                self.descriptionLeftConstraint.constant = -175.0
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                    self.containerView.center.y = (self.containerView.bounds.height * 0.5)
                    self.fadeView?.alpha = 1
                    self.navigationView.alpha = 0.0
                    self.descriptionView.alpha = 0.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else if (y > limit) {
                self.navigationLeftConstraint.constant = -75.0
                self.descriptionLeftConstraint.constant = -175.0
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                    self.containerView.center.y = (self.containerView.bounds.height * 0.5) - limit
                    self.fadeView?.alpha = 1
                    self.navigationView.alpha = 0.0
                    self.descriptionView.alpha = 0.0
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                // no need
            }
        } else {
            self.navigationLeftConstraint.constant = -75.0
            self.descriptionLeftConstraint.constant = -175.0
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
                self.containerView.center = originalCenter
                self.fadeView?.alpha = 1
                self.navigationView.alpha = 0.0
                self.descriptionView.alpha = 0.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
