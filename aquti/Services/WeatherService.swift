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
    
    // Followed tutorial to use openweathermaps
    // Adapted code to fit requirements
    // Source: http://www.globalnerdy.com/2016/04/02/how-to-build-an-ios-weather-app-in-swift-part-1-a-very-bare-bones-weather-app/
    private let openWeatherMapURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "15e62b062f6acadb28d9134906aa6203"
    
    private var delegate: TypeViewController
    
    init(delegate: TypeViewController) {
        self.delegate = delegate
    }
    
    func getWeahterInformation(lat: String, long: String, updateView: Bool) {
        
        let session = URLSession.shared
        
        let url = URL(string: "\(openWeatherMapURL)?APPID=\(openWeatherMapAPIKey)&lat=\(lat)&lon=\(long)")!
        
        let dataTask = session.dataTask(with: url) {
            (data, response, error) in
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherDictionary = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers) as! Dictionary<String, AnyObject>
                    
                        let weather = Weather(weatherData: weatherDictionary)
                    
                    if(updateView){
                        self.delegate.didGetWeather(weather: weather)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        
        dataTask.resume()
    }
}
