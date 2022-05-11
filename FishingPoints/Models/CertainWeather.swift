//
//  CertainWeather.swift
//  FishingPoints
//
//  Created by Roman Torry on 10.05.22.
//

import Foundation

struct CertainWeather {
    
    let lat: Double
    let lon: Double
    
    let temp: Double
    var tempStr: String {
        return String(format: "%.1f", temp)
    }
    
    let pressure: Int
    var presStr: String {
        return "\(pressure)"
    }
    
    var conditionCode: Int
    var conditionCodeString: String {
        switch conditionCode {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.heavyrain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 700...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.fill"
        default:
            return "xmark.octagon.fill"
        }
    }
    
    init?(certainWeather: CertainWeatherData){
        lat = certainWeather.lat
        lon = certainWeather.lon
        temp = certainWeather.current.temp
        pressure = certainWeather.current.pressure
        conditionCode = certainWeather.current.weather.first!.id
    }
}
