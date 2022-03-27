//
//  ArticleSearchUsecase.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 24/3/2565 BE.
//

import Foundation
import RxSwift

protocol ArticleSearchUsecase {
    func execute(keyWord: String, page: Int) -> Observable<[ArticleSearchItem]>
}

final class ArticleSearchUsecaseImpl: ArticleSearchUsecase {
    
    private let repository: ArticleSearchRepository = ArticleSearchRepositoryImpl()
    
    func execute(keyWord: String, page: Int) -> Observable<[ArticleSearchItem]> {
        
        var request = ArticleSearchRequest()
        request.apiKey = FirestoreManager.shared.getApiKey()
        request.keyWord = keyWord
        request.page = page
        
        return repository.getArticleSearch(request: request).flatMap { response in
            return Observable.just(response.response)
        }
    }
}
