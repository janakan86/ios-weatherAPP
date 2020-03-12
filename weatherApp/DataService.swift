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
    
    //ensure only one object of the Dataservice is shared by all
    static let sharedDataService = DataService()
    
    // The shared persistentContainer reference would be assigned to this at AppDelegate
    // The value would be set to the shared object created above
    var persistentContainer:NSPersistentContainer! = nil
    
    
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
    
    
    private func getURLAccuWeatherForLocations(searchWord:String,path:String)->URL?{
        var weatherURL = URLComponents()
        
        weatherURL.scheme = "https"
        weatherURL.host = "dataservice.accuweather.com"
        weatherURL.path = "/locations/v1/"+path
        
        weatherURL.queryItems = [
            URLQueryItem(name:"q",value:searchWord),
            URLQueryItem(name:"apikey",value:Constants.API.accuweatherKey),
            URLQueryItem(name:"language",value:"en-us")
        ]
        
        guard let validURL =  weatherURL.url else {
            return nil
        }
        
        return validURL
        
    }
    
    
    func fetchthreeHourlyForecast(){
        
    }
    
    func fetchCurrentWeather(successCallback: @escaping (CurrentWeather?)->()){
        
        let storedLocation = getStoredCity()
        
        guard storedLocation != nil else{
             //"TODO a callback which redirects to the search screen"
            return
        }
        
        let url = getURLOpenWeatherMap(
            location: Location(country:storedLocation!.country,city:storedLocation!.city), path:"weather")
        
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
        
        let storedLocation = getStoredCity()
        
        guard storedLocation != nil else{
            //"TODO a callback which redirects to the search screen"
            return
        }
        
        let url = getURLWeatherBit(
            location:Location(country:storedLocation!.country,city:storedLocation!.city),
                path:"forecast/daily")
        
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
    
    
    func fetchLocations(successCallback: @escaping ([accuweatherCity]?)->(),
                        errorCallback:  @escaping  (Error)->(),
                        searchWord:String){
        
        let url = getURLAccuWeatherForLocations(
            searchWord:searchWord,
            path:"cities/autocomplete")

        guard let validURL =  url else {
            return
        }
        
        URLSession.shared.dataTask(with: validURL, completionHandler:
            
            //implemenation for closure
            { (data, urlResponse, error ) in
                
                if (urlResponse as? HTTPURLResponse) != nil {
                    
                    //guard - check for errors.error should be null and data should be present
                    guard let validData = data, error == nil else{
                        if(error != nil){
                            errorCallback(error!)
                        }
                        return
                    }
                    
                    //process received data
                    do{
                        
                        let retrivedCities  = try JSONDecoder().decode([accuweatherCity].self, from: validData)
                        
                       
                        successCallback(retrivedCities)
                        
                        
                    }
                    catch let SerializationError{
                        print(SerializationError)
                        errorCallback(SerializationError)
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
    
    
    
    func saveStoredCity(){
        let  managedContext = self.persistentContainer.viewContext
        
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
    
    
    func getStoredCity()-> Location?{
        
        let  managedContext = self.persistentContainer.viewContext
        
        let storedCityFetchRequest = NSFetchRequest<StoredCity>(entityName: "StoredCity")
        
        do{
            let storedCities = try managedContext.fetch(storedCityFetchRequest)

             //"TODO The decision on how many cities to store is pending.Untilthen , j
            // just return the first value."
            
            for city in storedCities{
                
                return Location(country: city.country_code, city: city.city_code)
            }
        }
        catch{
            print("\(error)")
        }
        
        return nil
    
    }
    
    
    func deleteAllStoredCitites(){
        
        let  managedContext = self.persistentContainer.viewContext
        
        let storedCityFetchRequest = NSFetchRequest<StoredCity>(entityName: "StoredCity")
        
        do {
            // as the storage is unlikely store many locations, it is reasonable to loop and delete
            let storedCities = try managedContext.fetch(storedCityFetchRequest)
            
            for city in storedCities{
                managedContext.delete(city)
            }
            try managedContext.save()
            
        } catch{
            managedContext.rollback()
        }
    }
    
    
}


