//
//  weather.swift
//  weatherApp
//
//  Created by K Janakan on 13/11/19.
//  Copyright © 2019 K Janakan. All rights reserved.
//

import Foundation
import UIKit


//for openweather map current Weather - https://openweathermap.org/current
struct CurrentWeather    : Codable {
    var name:String
    var weather:[Weather]
    var main:Main
}

struct Weather : Codable {
    var main:String
    var description:String
    var icon:String
}

struct Main : Codable {
    var temp:Double
    var humidity:Double
}


//16 day forecast from weather bit - https://www.weatherbit.io/api/weather-forecast-16-day
struct SixteenDayForecast : Codable {
    var data:[WeatherForecastData]
    var city_name:String
}

struct WeatherForecastData : Codable {
    var valid_date:String
    var max_temp:Double
    var min_temp:Double
    var weather:forecastWeather
    
}


struct forecastWeather : Codable {
    var description:String
    var icon:String
}



