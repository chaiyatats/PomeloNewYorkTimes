//
//  MostPopularUsecase.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 23/3/2565 BE.
//

import Foundation
import RxSwift

protocol MostPopularUsecase {
    func execute(periodTime: PeriodTime) -> Single<[MostPopularItem]>
}

final class MostPopularUsecaseImpl: MostPopularUsecase {
    
    private let repository: MostPopularRepository = MostPopularRepositoryImpl()
    
    func execute(periodTime: PeriodTime) -> Single<[MostPopularItem]> {
        
        var request = MostPopularRequest()
        request.apiKey = FirestoreManager.shared.getApiKey()
        
        switch periodTime {
        case .day:
            request.period = "1"
        case .week:
            request.period = "7"
        case .month:
            request.period = "30"
        }
        
        return repository.getMostPopular(request: request).flatMap { response in
            let results = response.results.sorted(by: { $0.publishedDate < $1.publishedDate })
            return Single.just(results)
        }
    }
}
