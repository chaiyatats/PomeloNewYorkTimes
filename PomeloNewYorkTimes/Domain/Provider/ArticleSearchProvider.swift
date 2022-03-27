//
//  ArticleSearchProvider.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 24/3/2565 BE.
//

import Foundation
import Moya

enum ArticleSearchProvider {
    case getArticleSearch(request: ArticleSearchRequest)
}

extension ArticleSearchProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.nytimes.com")!
    }
    
    var path: String {
        switch self {
        case .getArticleSearch:
            return "/svc/search/v2/articlesearch.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getArticleSearch(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
