//
//  ArticleSearchResponse.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 24/3/2565 BE.
//

import Foundation
import ObjectMapper

struct ArticleSearchResponse: Mappable {
    
    var status: String?
    var response: [ArticleSearchItem] = []
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        status      <-  map["status"]
        response    <-  map["response.docs"]
    }
}

struct ArticleSearchItem: Mappable {
    
    var webUrl: URL?
    var leadParagraph: String?
    var abstract: String?
    var source: String?
    var publishedDate: String = ""
    var multimedia: [ArticleSearchMultimedia]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        webUrl          <- (map["web_url"], URLTransform())
        leadParagraph   <- map["lead_paragraph"]
        abstract        <- map["abstract"]
        source          <- map["source"]
        publishedDate   <- map["pub_date"]
        multimedia      <- map["multimedia"]
    }
}

struct ArticleSearchMultimedia: Mappable {
    
    var url: String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        url     <- map["url"]
    }
}
