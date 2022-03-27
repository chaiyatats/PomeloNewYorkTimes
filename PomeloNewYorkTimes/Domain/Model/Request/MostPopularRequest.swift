//
//  MostPopularRequest.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 23/3/2565 BE.
//

import Foundation
import ObjectMapper

enum PeriodTime {
    case day
    case week
    case month
}

struct MostPopularRequest: Mappable {
    
    var apiKey: String?
    var period: String = "1"
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        apiKey  <-  map["api-key"]
        period  <-  map["period"]
    }
}
