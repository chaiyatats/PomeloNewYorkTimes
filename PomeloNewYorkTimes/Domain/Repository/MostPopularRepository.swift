//
//  MostPopularRepository.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 23/3/2565 BE.
//

import Foundation
import RxSwift
import RxMoya
import Moya
import Moya_ObjectMapper

protocol MostPopularRepository {
    func getMostPopular(request: MostPopularRequest) -> Single<MostPopularResponse>
}

final class MostPopularRepositoryImpl: MostPopularRepository {

    let provider = MoyaProvider<MostPopularProvider>()

    func getMostPopular(request: MostPopularRequest) -> Single<MostPopularResponse> {
        return provider.rx.request(.getMostPopular(request: request)).flatMap { response in
            return Single.just(try response.mapObject(MostPopularResponse.self))
        }
    }
}
