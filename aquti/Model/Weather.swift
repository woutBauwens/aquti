//
//  Weather.swift
//  aquti
//
//  Created by Wout Bauwens on 02/01/2018.
//  Copyright © 2018 Wout Bauwens. All rights reserved.
//

import Foundation

struct Weather {
    
    private let temp: Double
    var tempCelsius: Int {
        get {
            return Int(temp - 273.15)
        }
    }

    let windSpeed: Double
    
    let windDirection: Double?
    let rainfallInLast3Hours: Double
    
    let sunrise: NSDate
    let sunset: NSDate
    
    init(weatherData: [String: AnyObject]) {
        
        let mainDict = weatherData["main"] as! [String: AnyObject]
        temp = mainDict["temp"] as! Double
        
        let windDict = weatherData["wind"] as! [String: AnyObject]
        windSpeed = pow(((windDict["speed"] as! Double)/0.836), 2/3)
        windDirection = windDict["deg"] as? Double   // is useful for the waves but hard to implement
        
        if weatherData["rain"] != nil {   // rain is bugged in OpenWeatherMap and is possibly nil
            let rainDict = weatherData["rain"] as! [String: AnyObject]
            let fallInLast3Hours = rainDict["3h"] as? Double
            if(fallInLast3Hours == nil){
                rainfallInLast3Hours = 0
            } else {
                rainfallInLast3Hours = fallInLast3Hours!
            }
        }
        else {
            rainfallInLast3Hours = 0
        }
        
        let sysDict = weatherData["sys"] as! [String: AnyObject]
        sunrise = NSDate(timeIntervalSince1970: sysDict["sunrise"] as! TimeInterval)
        sunset = NSDate(timeIntervalSince1970:sysDict["sunset"] as! TimeInterval)
    }
    
}
