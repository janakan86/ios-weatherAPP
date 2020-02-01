//
//  HourlyViewController.swift
//  weatherApp
//
//  Created by K Janakan on 7/11/19.
//  Copyright © 2019 K Janakan. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController,UITableViewDataSource {
 
    
    
    @IBOutlet weak var currentWeatherDisplay: CurrentWeatherDisplay!
    
    @IBOutlet var forecastTableView: UITableView!
    
    var weatherForecast: [WeatherForecastData] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadWeatherForecast()
    }
    
    
    private func loadWeatherForecast(){
        
        DataService.sharedDataService.fetchSixteenDayForecast(
            
            successCallback:{ (weatherForecast:SixteenDayForecast?)->() in
                
                guard let retrievedWeatherForecast = weatherForecast else{
                    return
                }
                
                if (retrievedWeatherForecast.data.count > 4){
                    self.weatherForecast.removeAll()
                    for index in 0...4 {
                        self.weatherForecast.append( retrievedWeatherForecast.data[index])
                    }
                }
                
                DispatchQueue.main.async {
                    self.forecastTableView.reloadData()
                }

            }
        )
    }
    
    
    
    //data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx: Int = indexPath.row
        
        //  let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "currentWeatherPrototype",for:indexPath) as! currentWeatherPrototypeCell
        
        if self.weatherForecast.count == 0 {
            return cell
        }
        
        cell.minimumTemperature?.text = String(format:"%.0f",weatherForecast[idx].min_temp ??  0) + " °c"
        
        cell.maximumTemperature?.text = String(format:"%.0f",weatherForecast[idx].max_temp ??  0) + " °c"

        let iconName = weatherForecast[idx].weather.icon
        self.loadIcon(weatherIconName: iconName,cell:cell)
        
        return cell
    }
    
    //return the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //end of data source methods
    
    
    
    private func loadIcon(weatherIconName:String, cell:currentWeatherPrototypeCell){
        //fetch the icon
        
        DataService.sharedDataService.fetchIconForecast(
            successCallback: { (icon)->() in
                DispatchQueue.main.async {
                    cell.weatherIcon.image = icon
                }
                
        }, iconName: weatherIconName
            
        )
        
    }
}


