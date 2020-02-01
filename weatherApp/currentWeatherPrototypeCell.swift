//
//  currentWeatherPrototypeCell.swift
//  weatherApp
//
//  Created by K Janakan on 29/1/20.
//  Copyright © 2020 K Janakan. All rights reserved.
//

import UIKit

class currentWeatherPrototypeCell: UITableViewCell {
    
    @IBOutlet var minimumTemperature: UILabel!
    @IBOutlet var maximumTemperature:UILabel!
    @IBOutlet var weatherIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
