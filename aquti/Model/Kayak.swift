//
//  Kayak.swift
//  aquti
//
//  Created by Wout Bauwens on 07/01/2018.
//  Copyright © 2018 Wout Bauwens. All rights reserved.
//

import Foundation

struct Kayak {
    
    var WaterType: String
    var NotWaterType: String
    
    var firstSuggestion: String
    var secondSuggestion: String
    
    var firstImage: String
    var secondImage: String
    
    init(first: String, second: String, heavyCondition: Bool){
        WaterType = first
        NotWaterType = second
        if(WaterType == "Zee"){
            if(heavyCondition){
                firstSuggestion = "Het is ideaal surfweer!"
                firstImage = "wave.jpg"
            } else {
                firstSuggestion = "Geen surfweer maar wel ideaal voor een tochtje!"
                firstImage = "sun.jpg"
            }
            secondSuggestion = "Je kan ook altijd wildwater varen!"
            secondImage = "1866771-650x300.jpg"
        } else {
            if(heavyCondition){
                firstSuggestion = "De rivieren staang hoog! Wildwater tijd!"
                firstImage = "test2.jpg"
            } else {
                firstSuggestion = "De rivieren staan niet zo hoog maar toch goed voor wildwater"
                firstImage = "1866771-650x300.jpg"
            }
            secondSuggestion = "Je kan ook altijd op zee gaan varen!"
            secondImage = "sun.jpg"
            }
        }
}
