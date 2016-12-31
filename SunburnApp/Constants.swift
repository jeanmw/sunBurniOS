//
//  Constants.swift
//  SunburnApp
//
//  Created by Jean Weatherwax on 12/30/16.
//  Copyright © 2016 Jean Weatherwax. All rights reserved.
//

import Foundation

struct WeatherURL {
    private let baseURL = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
    private let key = "&key=YOUR_KEY_HERE"
    private let numDaysForecast = "&num_of_days=1"
    private let format = "&format=json"
    
    private var coordinateString = ""
    
    init (lat: String, long: String) {
        self.coordinateString = "?q=\(lat),\(long)"
    }
    
    func getFullURL() -> String {
        return baseURL + coordinateString + key + numDaysForecast + format
    }
}

struct SkinType {
    
    let type1 = "Type 1 - Pale/Light"
    let type2 = "Type 2 - White/Fair"
    let type3 = "Type 3 - Medium"
    let type4 = "Type 4 - Olive"
    let type5 = "Type 5 - Dark/Brown"
    let type6 = "Type 6 - Dark/Black"
    
}

struct BurnTime {
    //all times in minutes
    let burn1: Double = 67
    let burn2: Double = 100
    let burn3: Double = 200
    let burn4: Double = 300
    let burn5: Double = 400
    let burn6: Double = 500
}

struct defaultsKeys {
    static let skinType = "skinType"
}
