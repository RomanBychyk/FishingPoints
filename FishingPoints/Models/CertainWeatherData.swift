//
//  CertainWheatherData.swift
//  FishingPoints
//
//  Created by Roman Torry on 10.05.22.
//

import Foundation

struct CertainWeatherData: Codable {
    
    let lat: Double
    let lon: Double
    let current: Current
}

struct Current: Codable {
    let temp: Double
    let pressure: Int
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
}


