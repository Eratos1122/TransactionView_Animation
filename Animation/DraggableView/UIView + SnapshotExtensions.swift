//
//  UIView + SnapshotExtensions.swift
//  Animation
//
//  Created by Lee on 11/8/19.
//  Copyright © 2019 Eratos. All rights reserved.
//

import UIKit

extension UIView{
    func snapShotImage() -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
//        guard let context = UIGraphicsGetCurrentContext() else{ return nil}
//        context.translateBy(x: -bounds.origin.x, y: -bounds.origin.y)
//        self.layoutIfNeeded()
//        layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func snapShotView() -> UIView? {
        if let imageView = self as? UIImageView {
            let v = UIImageView(image: imageView.image)
            v.contentMode = .scaleAspectFit
            v.bounds = self.bounds
            v.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            v.layer.masksToBounds = true
            return v
        } else if let snapshotImage = snapShotImage() {
            let v = UIImageView(image: snapshotImage)
            v.contentMode = .center
            v.bounds = self.bounds
            v.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            v.layer.masksToBounds = true
            return v
        }
        return nil
    }
}

