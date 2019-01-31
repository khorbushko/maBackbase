//
//  Animator.swift
//  maBackbase
//
//  Created by Kirill Gorbushko on 1/31/19.
//  Copyright © 2019 - present. All rights reserved.
//

import UIKit

final class Animator {

    public enum Defaults {

        static let AnimationDuration: TimeInterval = 0.3
    }

    class func fadeView(_ view: UIView, isFade: Bool, completion:(() -> ())? = nil) {
        if view.layer.opacity == 0, !isFade {
            let fadeInAnimation = Animator.fadeAnimation(0, toValue: 1)
            fadeInAnimation.onComplete = { _ in
                completion?()
            }
            view.layer.add(fadeInAnimation, forKey: nil)
            view.layer.opacity = 1
        } else if view.layer.opacity == 1, isFade {
            let fadeOutAnimation = Animator.fadeAnimation(1, toValue: 0)
            fadeOutAnimation.onComplete = {  _ in
                completion?()
            }
            view.layer.opacity = 0
            view.layer.add(fadeOutAnimation, forKey: nil)
        }
    }

    @discardableResult
    class func fadeAnimation(_ fromValue: CGFloat, toValue: CGFloat, delegate: AnyObject? = nil) -> CABasicAnimation {
        let fadeAnim: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = fromValue
        fadeAnim.toValue = toValue
        fadeAnim.duration = Defaults.AnimationDuration
        if delegate != nil {
            fadeAnim.isRemovedOnCompletion = false
            fadeAnim.delegate = delegate as? CAAnimationDelegate
        } else {
            fadeAnim.isRemovedOnCompletion = true
        }
        fadeAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        return fadeAnim
    }
}
