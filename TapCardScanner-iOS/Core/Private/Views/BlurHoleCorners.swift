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
    var reverseCorners:Bool = false
    
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
    
    @IBOutlet var corners: [UIImageView]!
    
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
    
    internal func updateCorners(with status:ScanningCornersColors) {
        let bundle = Bundle(for: Self.self)
        corners.forEach{ $0.image = UIImage(named: status.imageName(for: ScanningCorner.init(rawValue: $0.tag) ?? .topLeft), in: bundle, compatibleWith: nil) }
    }
    
}

/// Enum to decide the current state of the scanner to reflect this on border corners colors
enum ScanningCornersColors {
    /// Scanner is running
    case normal
    /// Card is scanned
    case scanned
    /**
     Generates the name of the correct image based on status and corner position
     - Parameter corner: The corner we want to generate the asset for
     - Returns: The name of the image that correctly reflects the status and the corner
     */
    func imageName(for corner:ScanningCorner) -> String {
        return "\(corner.toString())\(self.toString())"
    }
    
    func toString() -> String {
        switch self {
        case .normal:
            return "Corner.png"
        case .scanned:
            return "SuccessCorner.png"
        }
    }
}

/// Enum to decide a corner to avoid typos and the code looks more elegant
enum ScanningCorner: Int {
    case topLeft = 1
    case topRight = 2
    case bottomRight = 3
    case bottomLeft = 4
    
    
    func toString() -> String {
        switch self {
        case .topLeft:
            return "TopLeft"
        case .topRight:
            return "TopRight"
        case .bottomRight:
            return "BottomRight"
        case .bottomLeft:
            return "BottomLeft"
        }
    }
}
