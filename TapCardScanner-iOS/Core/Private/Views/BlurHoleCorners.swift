//
//  BlurHoleCorners.swift
//  TapCardScanner-iOS
//
//  Created by Osama Rabie on 7/12/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import UIKit

class BlurHoleCorners: UIView {

    @IBOutlet var contentView:UIView!
    
    // Mark:- Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        self.backgroundColor = .clear
        commonInit()
    }
    
    
    internal func commonInit() {
        // Add the XIB
        loadXIB()
    }
    
    // MARK:- Public methods
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }
    
    /// Add the XIB
    internal func loadXIB() {
        guard let nibs = Bundle(for: Self.self).loadNibNamed("BlurHoleCorners", owner: self, options: nil),
            nibs.count > 0, let loadedView:UIView = nibs[0] as? UIView else { fatalError("Couldn't load Xib BlurHoleCorners") }
        
        let newContainerView = loadedView
        
        //Set the bounds for the container view
        newContainerView.frame = bounds
        newContainerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        // Check if needed to add it as subview
        addSubview(newContainerView)
        contentView = newContainerView
    }

}
