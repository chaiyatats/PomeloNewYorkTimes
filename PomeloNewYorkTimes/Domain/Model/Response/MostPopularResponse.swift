//
//  MostPopularResponse.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 23/3/2565 BE.
//

import Foundation
import ObjectMapper

struct MostPopularResponse: Mappable {
    
    var numResults: Int?
    var results: [MostPopularItem] = []
    
    init() {}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        numResults          <-  map["num_results"]
        results             <-  map["results"]
    }
}

struct MostPopularItem: Mappable {
    
    var url: URL?
    var publishedDate: String = ""
    var title: String?
    var abstract: String?
    var media: [MostPopularMedia]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        url                 <- (map["url"], URLTransform())
        publishedDate       <- map["published_date"]
        title               <- map["title"]
        abstract            <- map["abstract"]
        media               <- map["media"]
    }
}

struct MostPopularMedia: Mappable {
    
    var mediaMetaData: [MostPopularMediaData]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        mediaMetaData   <- map["media-metadata"]
    }
}

struct MostPopularMediaData: Mappable {
    
    var url: URL?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        url                 <- (map["url"], URLTransform())
    }
}
