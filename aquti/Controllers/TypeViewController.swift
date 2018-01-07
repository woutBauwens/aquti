//
//  TypeController.swift
//  aquti
//
//  Created by Wout Bauwens on 28/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//

import Foundation
import UIKit

class TypeViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var firstSuggestion: UILabel!
    @IBOutlet weak var secondSuggestion: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    private var firstType: String!
    private var secondType: String!
    private var secondsToSunset: Int!
    
    @IBAction func firstAction(_ sender: Any) {
        selectedType = firstType
        imageToNext = firstButton.imageView?.image
        performSegue(withIdentifier: "segueToNextView", sender: self)
    }
    
    @IBAction func secondAction(_ sender: Any) {
        selectedType = secondType
        imageToNext = secondButton.imageView?.image
        performSegue(withIdentifier: "segueToNextView", sender: self)
    }
    
    private var selectedType: String!
    private var weatherService: WeatherService!
    private var imageToNext: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coord = LocationService.sharedInstance.currentLocation.coordinate
        
       setupConstraits()
        
        weatherService = WeatherService(delegate: self)
        
        self.titelLabel.text = (Calendar.current.component(.hour, from: Date())  > 12 ? "Goeienamiddag!": "Goeiemorgen!")
        
        weatherService.getWeahterInformation(lat: coord.latitude.description, long: coord.longitude.description, updateView: true)
    }
    
    func didGetWeather(weather: Weather) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the code
        // that updates all the labels in a dispatch_async() call.
        DispatchQueue.main.async() {
            let coord = LocationService.sharedInstance.currentLocation.coordinate
            
            self.weatherService.getWeahterInformation(lat: coord.latitude.description, long: coord.longitude.description, updateView: false)
            
             self.tempLabel.text = weather.tempCelsius.description + "°C"

            print(weather.windSpeed.description)
            print(weather.rainfallInLast3Hours.description)
            
            var kayak: Kayak!
            if(weather.windSpeed >= Double(weather.rainfallInLast3Hours)){
                kayak = Kayak.init(first: "Zee", second: "Wildwater", heavyCondition: (weather.windSpeed > 3))
            } else {
                kayak = Kayak.init(first: "Wildwater", second: "Zee", heavyCondition: weather.rainfallInLast3Hours > 3)
            }
            
            self.firstType = kayak.WaterType
            self.secondType = kayak.NotWaterType
            self.firstSuggestion.text = kayak.firstSuggestion
            self.firstButton.setImage(UIImage(named: kayak.firstImage), for: .normal)
            self.secondSuggestion.text = kayak.secondSuggestion
            self.secondButton.setImage(UIImage(named: kayak.secondImage), for: .normal)

            if(weather.windSpeed > 14){
                self.firstType = "Whitewater"
                self.secondType = "Sea"
                self.secondSuggestion.text = "Do not go seakayaking today, unless you know what you are doing. The weather appears to be stormy (up to 7 beaufort)"
                self.firstSuggestion.text = "You can go whitewater kayaking!"
                self.firstButton.setImage(UIImage(named: "1866771-650x300.jpg"), for: .normal)
                self.secondButton.setImage(UIImage(named: "lawson_s_stormy_sea_by_powderakacaseyjones-d7r4k6m.png"), for: .normal)
            }
            self.secondsToSunset = -Int(weather.sunset.timeIntervalSince(Date()))
        }
    }
    
    @objc private func setupConstraits() {
        firstSuggestion.translatesAutoresizingMaskIntoConstraints = false
        firstSuggestion.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        firstSuggestion.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        firstSuggestion.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 75).isActive = true
        firstSuggestion.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.15).isActive = true
        
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        firstButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        firstButton.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 140).isActive = true
        firstButton.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.30).isActive = true
        
        secondSuggestion.translatesAutoresizingMaskIntoConstraints = false
        secondSuggestion.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        secondSuggestion.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        secondSuggestion.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: 0).isActive = true
        secondSuggestion.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.70).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToNextView" {
            if let toMainController = segue.destination as? PageViewController {
                if(self.secondsToSunset<0){
                    self.secondsToSunset = 12*3600+secondsToSunset
                }
                toMainController.secondsToSunset = self.secondsToSunset
                toMainController.image = imageToNext
                toMainController.waterType = selectedType
            }
        }
    }
}
