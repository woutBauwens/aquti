//
//  WeatherService.swift
//  aquti
//
//  Created by Wout Bauwens on 02/01/2018.
//  Copyright © 2018 Wout Bauwens. All rights reserved.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WeatherService {
    
    private let openWeatherMapURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "15e62b062f6acadb28d9134906aa6203"
    
    private var delegate: TypeViewController
    
    init(delegate: TypeViewController) {
        self.delegate = delegate
    }
    
    func getWeahterInformation(city: String) {
        
        // *** 1 ***
        let session = URLSession.shared
        
        // *** 2 ***
        let weatherRequestURL = URL(string: "\(openWeatherMapURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        
        // *** 3 ***
        let dataTask = session.dataTask(with: weatherRequestURL) {
            (data, response, error) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
                // *** 5 ***
            else {
                // Case 2: Success
                // We got a response from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherDictionary = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! Dictionary<String, AnyObject>
                    
                        print("Date and time: \(weatherDictionary["dt"]!)")
                    
                        let weather = Weather(weatherData: weatherDictionary)
                    
                        self.delegate.didGetWeather(weather: weather)
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        
        // *** 6 ***
        dataTask.resume()
    }
    
    func getWindSpeed() -> String {
     //   if(dictionary == nil){
     //       getWeahterInformation(city: "Ghent")
     //   }
     //   return dictionary["dt"]! as! String
        
        return "Not connected"
    }
}
