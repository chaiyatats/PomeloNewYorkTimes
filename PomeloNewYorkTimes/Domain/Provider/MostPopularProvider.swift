//
//  MostPopularProvider.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 23/3/2565 BE.
//

import Foundation
import Moya

enum MostPopularProvider {
    case getMostPopular(request: MostPopularRequest)
}

extension MostPopularProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.nytimes.com")!
    }
    
    var path: String {
        switch self {
        case .getMostPopular(let request):
            return "/svc/mostpopular/v2/viewed/\(request.period).json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getMostPopular(let request):
            var parameters = request.toJSON()
            parameters.removeValue(forKey: "period")
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
