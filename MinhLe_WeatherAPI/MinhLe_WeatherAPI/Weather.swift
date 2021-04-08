//
//  Weather.swift
//  MinhLe_WeatherAPI
//
//  Created by Minh Le on 2021-04-03.
//

import Foundation

struct Weather : Codable{
    let current_temp_c : Double
    var current_feelslike_c : Double
    var current_wind_kph : Double
    var current_wind_dir : String
    var current_uv : Double
    
    init(){
        self.current_temp_c = 0
        self.current_feelslike_c = 0
        self.current_wind_kph = 0
        self.current_wind_dir = ""
        self.current_uv = 0
    }
    
    enum CodingKeys : String, CodingKey {
        case current_temp_c = "temp_c"
        case current_feelslike_c = "feelslike_c"
        case current_wind_kph = "wind_kph"
        case current_wind_dir = "wind_dir"
        case current_uv = "uv"
        case current = "current"
    }
    
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        let currentContainer = try response.decodeIfPresent(Current.self, forKey: .current)
        self.current_temp_c = currentContainer?.temp_c ?? 0
        self.current_feelslike_c = currentContainer?.feelslike_c ?? 0
        self.current_wind_kph = currentContainer?.wind_kph ?? 0
        self.current_wind_dir = currentContainer?.wind_dir ?? "Unavailable"
        self.current_uv = currentContainer?.uv ?? 0
        
    }
}

struct Current : Codable{
    var temp_c : Double
    var feelslike_c : Double
    var wind_kph : Double
    var wind_dir : String
    var uv : Double
    
    enum CodingKeys : String, CodingKey {
        case temp_c = "temp_c"
        case feelslike_c = "feelslike_c"
        case wind_kph = "wind_kph"
        case wind_dir = "wind_dir"
        case uv = "uv"
    }
    func encode(to encoder: Encoder) throws {
        //nothing to encode
    }
    
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.temp_c = try response.decodeIfPresent(Double.self, forKey: .temp_c) ?? 0
        self.feelslike_c = try response.decodeIfPresent(Double.self, forKey: .feelslike_c) ?? 0
        self.wind_kph = try response.decodeIfPresent(Double.self, forKey: .wind_kph) ?? 0
        self.wind_dir = try response.decodeIfPresent(String.self, forKey: .wind_dir) ?? "Unavailable"
        self.uv = try response.decodeIfPresent(Double.self, forKey: .uv) ?? 0
    }
}




