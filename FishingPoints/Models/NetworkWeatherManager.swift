//
//  NetworkWheatherManager.swift
//  FishingPoints
//
//  Created by Roman Torry on 9.05.22.
//

import Foundation

class NetworkWeatherManager {
    
    func fetchWeather (forTime time: Int,
                       byCoordinates latitude: String, and longitude: String,
                       completionHandler: @escaping (CertainWeather) -> Void) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=\( latitude)&lon=\(longitude)&dt=\(time)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    completionHandler(currentWeather)
                    }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> CertainWeather? {
        let decoder = JSONDecoder()
        
        do {
            let certainWeatherData = try decoder.decode(CertainWeatherData.self, from: data)
            //print(certainWeatherData.current.temp)
            guard let certainWeather = CertainWeather(certainWeather: certainWeatherData)
                else { return nil }
            return certainWeather
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}
