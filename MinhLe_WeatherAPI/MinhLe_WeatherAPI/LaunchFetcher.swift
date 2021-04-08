//
//  LaunchFetcher.swift
//  MinhLe_WeatherAPI
//
//  Created by Minh Le on 2021-04-03.
//

import Foundation
class LaunchesFetcher : ObservableObject{
    private let apiURL = "http://api.weatherapi.com/v1/current.json"
    private let APIKey = "f0e3304e6f7d48a2bd245647210404"
        
    @Published var weatherList = Weather()
    
    //singleton instance
    private static var shared : LaunchesFetcher?
    
    static func getInstance() -> LaunchesFetcher{
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            //create a new singleton instance
            return LaunchesFetcher()
        }
    }
    
    func fetchDataFromAPI(country : String){
        let weatherRequestURL = "\(apiURL)?key=\(APIKey)&q=\(country)&aqi=no"
        guard let api = URL(string : weatherRequestURL) else{
            return
        }
        
        URLSession.shared.dataTask(with: api){ (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error{
                print(#function, "Couldn't fetch data", err)
            }else{
                //received data or response
                do{
                    if let jsonData = data{
                        let decoder = JSONDecoder()
                        let decodedList = try decoder.decode(Weather.self, from: jsonData)
                        self.weatherList = decodedList
                    }else{
                        print(#function, "No JSON data received ")
                    }
                }catch let error{
                    print(#function, error)
                }
            }
        }.resume()
        
    }
}
