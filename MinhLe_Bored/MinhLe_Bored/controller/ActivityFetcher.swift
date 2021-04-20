//
//  ActivityFetcher.swift
//  MinhLe_Bored
//
//  Created by Minh Le on 2021-04-20.
//

import Foundation
class ActivitiesFetcher : ObservableObject{
    var apiURL = "https://www.boredapi.com/api/activity"
    
    @Published var activityList = Activity()
    
    //singleton instance
    private static var shared : ActivitiesFetcher?
    
    static func getInstance() -> ActivitiesFetcher{
        if shared != nil{
            //instance already exists
            return shared!
        }else{
            return ActivitiesFetcher()
        }
    }
    
    func fetchDataFromApi(){
        guard let api = URL(string: apiURL)else{
            return
        }
        
        URLSession.shared.dataTask(with: api){
            (data: Data?, response: URLResponse?, error: Error?) in
            if let err = error{
                print(#function, "Couldn't fetch data", err)
            }else{
                do{
                    if let jsonData = data{
                        let decoder = JSONDecoder()
                        let decodedList = try decoder.decode(Activity.self, from: jsonData)
                        self.activityList = decodedList
                    }else{
                        print(#function, "No JSON data received")
                    }
                }catch let error{
                    print(#function, error)
                }
            }
        }.resume()
    }
    
}
