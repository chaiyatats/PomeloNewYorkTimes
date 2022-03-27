//
//  ArticleSearchRepository.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 24/3/2565 BE.
//

import Foundation
import RxSwift
import RxMoya
import Moya
import Moya_ObjectMapper

protocol ArticleSearchRepository {
    func getArticleSearch(request: ArticleSearchRequest) -> Observable<ArticleSearchResponse>
}

final class ArticleSearchRepositoryImpl: ArticleSearchRepository {

    let provider = MoyaProvider<ArticleSearchProvider>()

    func getArticleSearch(request: ArticleSearchRequest) -> Observable<ArticleSearchResponse> {
        return provider.rx.request(.getArticleSearch(request: request)).flatMap { response in
            return Single.just(try response.mapObject(ArticleSearchResponse.self))
        }.asObservable()
    }
}
