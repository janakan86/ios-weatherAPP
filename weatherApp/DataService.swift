//
//  DataService.swift
//  weatherApp
//
//  Created by K Janakan on 6/11/19.
//  Copyright © 2019 K Janakan. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class DataService{
    
    
    static let sharedDataService = DataService()
    
    
    private func getURLOpenWeatherMap(location:Location, path:String)->URL?{
        var weatherURL = URLComponents()
        
        weatherURL.scheme = "https"
        weatherURL.host = "api.openweathermap.org"
        weatherURL.path = "/data/2.5/"+path
        
        weatherURL.queryItems = [
            URLQueryItem(name:"q",value:(location.city + "," + location.country)),
            URLQueryItem(name:"APPID",value:Constants.API.openweatherMapKey),
            URLQueryItem(name:"units",value:"metric")
        ]
        
        guard let validURL =  weatherURL.url else {
            return nil
        }
        
        return validURL
    
    }
    
    private func getURLWeatherBit(location:Location,path:String)->URL?{
        var weatherURL = URLComponents()
        
        weatherURL.scheme = "https"
        weatherURL.host = "api.weatherbit.io"
        weatherURL.path = "/v2.0/"+path
        
        weatherURL.queryItems = [
            URLQueryItem(name:"city",value:(location.city + "," + location.country)),
            URLQueryItem(name:"key",value:Constants.API.weatherbitKey),
            URLQueryItem(name:"units",value:"M")
        ]
        
        guard let validURL =  weatherURL.url else {
            return nil
        }
        
        return validURL
        
    }
    
    
    func fetchthreeHourlyForecast(){
        
    }
    
    func fetchCurrentWeather(successCallback: @escaping (CurrentWeather?)->()){
        
        let url = getURLOpenWeatherMap(location: Location(country:"AU",city:"Geelong"),path:"weather")
        
        guard let validURL =  url else {
            return
        }
        
        URLSession.shared.dataTask(with: validURL, completionHandler:
            
            //implemenation for closure
            { (data, urlResponse, error ) in
                
                if (urlResponse as? HTTPURLResponse) != nil {
                    
                    //guard - check for errors.error should be null and data should be present
                    guard let validData = data, error == nil else{
                        //print (error!.localizedDescription)
                        return
                    }

                    //process received data
                    do{
                        
                        let currentWeather  = try JSONDecoder().decode(CurrentWeather.self, from: validData)
                        
                        successCallback(currentWeather)
                        
                    }
                    catch let SerializationError{
                        print(SerializationError.localizedDescription)
                    }
                    
                }
        }).resume()
    }
    
    func fetchSixteenDayForecast(successCallback: @escaping (SixteenDayForecast?)->()){
        let url = getURLWeatherBit(location: Location(country:"AU",city:"Geelong"),path:"forecast/daily")
        
        guard let validURL =  url else {
            return
        }
        
        URLSession.shared.dataTask(with: validURL, completionHandler:
            
            //implemenation for closure
            { (data, urlResponse, error ) in
                
                if (urlResponse as? HTTPURLResponse) != nil {
                    
                    //guard - check for errors.error should be null and data should be present
                    guard let validData = data, error == nil else{
                        //print (error!.localizedDescription)
                        return
                    }
                    
                    //process received data
                    do{
                    
                        let weatherForecast  = try JSONDecoder().decode(SixteenDayForecast.self, from: validData)
                        successCallback(weatherForecast)
                        
                    }
                    catch let SerializationError{
                        print(SerializationError.localizedDescription)
                    }
                    
                }
        }).resume()
        
        
    }
    
    

    func fetchIconCurrentWeather(successCallback: @escaping (UIImage?)->(),iconName:String){
        
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "openweathermap.org"
        url.path = "/img/wn/"+iconName+".png"
        
        fetchIcon(successCallback:successCallback, iconName: iconName, url: url)
        
    }
    
    func fetchIconForecast(successCallback: @escaping (UIImage?)->(),iconName:String){
        
        var url = URLComponents()
        
        url.scheme = "https"
        url.host = "weatherbit.io"
        url.path = "/static/img/icons/"+iconName+".png"
        
        fetchIcon(successCallback:successCallback, iconName: iconName, url: url)
        
    }
    
    func fetchIcon(successCallback: @escaping (UIImage?)->(),iconName:String,url:URLComponents){
        
        guard let validURL =  url.url else {
            return
        }
        URLSession.shared.dataTask(with: validURL, completionHandler:
            
            //implemenation for closure
            { (data, urlResponse, error ) in
                
                if (urlResponse as? HTTPURLResponse) != nil {
                    
                    //guard - check for errors.error should be null and data should be present
                    guard let validData = data, error == nil else{
                        return
                    }
                    
                let image = UIImage(data: validData)
                successCallback(image)
                        
                  
                    
                }
        }).resume()
    }
    
    
    
    func saveStoredCity(persistentContainer:NSPersistentContainer){
        let  managedContext = persistentContainer.viewContext
        
        let storedCity =  NSEntityDescription.insertNewObject(forEntityName: "StoredCity", into: managedContext) as! StoredCity
        
        storedCity.country_code = "AU"
        storedCity.city_code = "Geelong"
        storedCity.name = "Geelong"
        
        do {
            try managedContext.save()
            
        } catch{
            managedContext.rollback()
        }
    
    }
    
    
    func getStoredCity(persistentContainer:NSPersistentContainer){
        
        let  managedContext = persistentContainer.viewContext
        
        let storedCityFetchRequest = NSFetchRequest<StoredCity>(entityName: "StoredCity")
        
        do{
            let storedCity = try managedContext.fetch(storedCityFetchRequest)
            print (storedCity)
        }
        catch{
            print("\(error)")
        }
    
    }
    
    
}


