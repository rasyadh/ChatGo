//
//  UIViewExtension.swift
//  ChatGo
//
//  Created by Rasyadh Abdul Aziz on 07/03/19.
//  Copyright © 2019 rasyadh. All rights reserved.
//

import UIKit

extension UIView {
    func setRoundedCorner(cornerRadius: CGFloat = 0.0, isCircular: Bool = false) {
        if isCircular {
            self.layer.cornerRadius = CGFloat(roundf(Float(self.frame.size.width / 2.0)))
        }
        else {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    func setCardView(cornerRadius: CGFloat, shadowSizeOffset: CGSize, shadowOpacity: Float, shadowColor: UIColor) {
        self.setRoundedCorner(cornerRadius: cornerRadius)
        let shadowPath = UIBezierPath(
            roundedRect: self.bounds,
            cornerRadius: cornerRadius)
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowSizeOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = shadowPath.cgPath
    }
}
