//
//  LoadingIndicator.swift
//  Yelp
//
//  Created by Nguyen Xuan Gieng on 9/8/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {
    
    @IBOutlet weak var logo: UIImageView!
    
    override func awakeFromNib() {
        self.animate()
    }
    
    func animate() {
        logo.image = UIImage.animatedImageNamed("AnimatedLogo", duration: 0.4)
    }
    
    func stopAnimating() {
        logo.image = UIImage(named: "Logo")
    }
    
}