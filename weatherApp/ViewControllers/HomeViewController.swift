//
//  HourlyViewController.swift
//  weatherApp
//
//  Created by K Janakan on 7/11/19.
//  Copyright © 2019 K Janakan. All rights reserved.
//

import UIKit
import CoreData


class HomeViewController: UIViewController {
    
    
    var container: NSPersistentContainer!
 
    
    @IBOutlet weak var currentWeatherDisplay: CurrentWeatherDisplay!
    
    @IBOutlet var forecastTableView: UITableView!
    
    var weatherForecast: [WeatherForecastData] = []

    let cellSpacingHeight: CGFloat = 10

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
                self.weatherForecast.removeAll()
                
                if (retrievedWeatherForecast.data.count > 4){
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
            
        //repeat for all possible segue story boards
        case "viewSearch":
            //cast it to the relevant ViewController
            if let nextVC = segue.destination as? SearchViewController {
                nextVC.container = self.container
            }
        default:
            break
        }
    }


}


extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx: Int = indexPath.section
        
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
        return 5
    }
}


extension HomeViewController : UITableViewDelegate{
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
}
