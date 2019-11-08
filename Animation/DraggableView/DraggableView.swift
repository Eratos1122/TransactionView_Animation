//
//  DraggableView.swift
//  Animation
//
//  Created by Lee on 11/8/19.
//  Copyright © 2019 Eratos. All rights reserved.
//

import UIKit

@objc
protocol DraggableViewDelegate: class {
    @objc optional func panGestureDidBegin(_ panGesture:UIPanGestureRecognizer, originalCenter:CGPoint)
    @objc optional func panGestureDidChange(_ panGesture:UIPanGestureRecognizer,originalCenter:CGPoint, translation:CGPoint, velocityInView:CGPoint)
    @objc optional func panGestureDidEnd(_ panGesture:UIPanGestureRecognizer, originalCenter:CGPoint, translation:CGPoint, velocityInView:CGPoint)
    @objc optional func panGestureStateToOriginal(_ panGesture:UIPanGestureRecognizer,originalCenter:CGPoint,  translation:CGPoint, velocityInView:CGPoint)
}

class DraggableView: UIView {
    
    var panGestureRecognizer : UIPanGestureRecognizer?
    var originalPosition : CGPoint?
    weak var delegate : DraggableViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    
    func setUp(){
        isUserInteractionEnabled = true
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.addGestureRecognizer(panGestureRecognizer!)
    }
    
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: superview)
        let velocityInView = panGesture.velocity(in: superview)
        
        switch panGesture.state {
        case .began:
            originalPosition = self.center
            delegate?.panGestureDidBegin?(panGesture, originalCenter: originalPosition!)
            break
        case .changed:
            
            delegate?.panGestureDidChange?(panGesture, originalCenter: originalPosition!, translation: translation, velocityInView: velocityInView)
            break
        case .ended:
            delegate?.panGestureDidEnd?(panGesture, originalCenter: originalPosition!, translation: translation, velocityInView: velocityInView)
            break
        default:
            delegate?.panGestureStateToOriginal?(panGesture, originalCenter: originalPosition!, translation: translation, velocityInView: velocityInView)
            break
        }
    }
}
