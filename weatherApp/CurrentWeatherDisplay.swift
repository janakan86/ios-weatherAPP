//
//  CurrentWeatherDisplay.swift
//  weatherApp
//
//  Created by K Janakan on 17/12/19.
//  Copyright © 2019 K Janakan. All rights reserved.
//

import UIKit

class CurrentWeatherDisplay: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    
    var weatherIconName: String?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CurrentWeatherDisplay", owner: self, options:nil)
        
        //add myself as a sub view
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        loadCurrentWeather()
        
    }
    
    private func loadCurrentWeather(){
        
        
        DataService.sharedDataService.fetchCurrentWeather(
            
            successCallback:{ (currentWeather:CurrentWeather?)->() in
                
                guard let retrievedWeather = currentWeather else{
                    return
                }
                DispatchQueue.main.async {

                    self.descriptionLabel.text = retrievedWeather.weather[0].description
                    self.humidityLabel.text = String(format:"%.0f",retrievedWeather.main.humidity ??  0) + " %"
                    self.temperatureLabel.text = String(format:"%.0f",retrievedWeather.main.temp ??  0) + " °c"
                    
                    self.weatherIconName = retrievedWeather.weather[0].icon
                    self.loadIcon()
                
                }
                
            }
        )
    
    }
    
    
    private func loadIcon(){
        //fetch the icon
        guard let icon = weatherIconName else{
            return
        }
        
        
        DataService.sharedDataService.fetchIconCurrentWeather(
            successCallback: { (icon)->() in
                DispatchQueue.main.async {
                    self.weatherIcon.image = icon
                }
                
        }, iconName: icon
            
        )
        
    }

}
