//
//  Activity.swift
//  MinhLe_Bored
//
//  Created by Minh Le on 2021-04-20.
//

import Foundation

struct Activity : Codable{
    let activity : String
   
    init(){
        self.activity = ""
    }
    
    enum CodingKeys : String, CodingKey{
        case activity = "activity"
    }
    
    func encode(to encoder: Encoder) throws{
        
    }
    init(from decoder: Decoder) throws {
        let response = try decoder.container(keyedBy: CodingKeys.self)
        self.activity = try response.decodeIfPresent(String.self, forKey: .activity) ?? "Unavailable"
    }
}
