//
//  ArticleSearchRequest.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 24/3/2565 BE.
//

import Foundation
import ObjectMapper

struct ArticleSearchRequest: Mappable {
    
    var apiKey: String?
    var keyWord: String?
    var page: Int?
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        apiKey      <-  map["api-key"]
        keyWord     <-  map["q"]
        page        <-  map["page"]
    }
}
