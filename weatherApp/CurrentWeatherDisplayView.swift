//
//  CurrentWeatherDisplayView.swift
//  weatherApp
//
//  Created by K Janakan on 7/12/19.
//  Copyright © 2019 K Janakan. All rights reserved.
//

import UIKit

class CurrentWeatherDisplayView: UIView {

    @IBOutlet weak var currentWeatherDescription: UILabel!

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        // standard initialization logic
        Bundle.main.loadNibNamed("CurrentWeatherDisplayView", owner: self, options:nil)
        addSubview(currentWeatherDescription)
        
        // custom initialization logic
        
    }

}
