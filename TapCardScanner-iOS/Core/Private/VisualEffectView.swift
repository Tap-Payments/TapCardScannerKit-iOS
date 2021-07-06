//
//  VisualEffectView.swift
//  VisualEffectView
//
//  Created by Osama Rabie on 10/07/2020.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit
/// VisualEffectView is a dynamic background blur view.
public class VisualEffectView: UIVisualEffectView {
    
    /// Returns the instance of UIBlurEffect.
    // private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    /**
     Tint color.
     
     The default value is nil.
     */
    public var colorTint: UIColor? {
        get { return _value(forKey: "colorTint") as? UIColor }
        set { _setValue(newValue, forKey: "colorTint") }
    }
    
    /**
     Tint color alpha.
     
     The default value is 0.0.
     */
    public var colorTintAlpha: CGFloat {
        get { return _value(forKey: "colorTintAlpha") as! CGFloat }
        set { _setValue(newValue, forKey: "colorTintAlpha") }
    }
    
    /**
     Blur radius.
     
     The default value is 0.0.
     */
    public var blurRadius: CGFloat {
        get { return _value(forKey: "blurRadius") as! CGFloat }
        set { _setValue(newValue, forKey: "blurRadius") }
    }
    
    /**
     Scale factor.
     
     The scale factor determines how content in the view is mapped from the logical coordinate space (measured in points) to the device coordinate space (measured in pixels).
     
     The default value is 1.0.
     */
    public var scale: CGFloat {
        get { return _value(forKey: "scale") as! CGFloat }
        set { _setValue(newValue, forKey: "scale") }
    }
    
    // MARK: - Initialization
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        scale = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scale = 1
    }
    
    
    /// Listen to light/dark mde changes and apply the correct theme based on the new style
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        adjustBlurType()
    }
    
    internal func adjustBlurType() {
        self.effect = (self.traitCollection.userInterfaceStyle == .dark) ? UIBlurEffect(style: .dark) : UIBlurEffect(style: .light)
    }
    
}

// MARK: - Helpers

private extension VisualEffectView {
    
    /// Returns the value for the key on the blurEffect.
    func _value(forKey key: String) -> Any? {
        return effect
    }
    
    /// Sets the value for the key on the blurEffect.
    func _setValue(_ value: Any?, forKey key: String) {
        //blurEffect.setValue(value, forKeyPath: key)
        //self.effect = blurEffect
    }
    
}
