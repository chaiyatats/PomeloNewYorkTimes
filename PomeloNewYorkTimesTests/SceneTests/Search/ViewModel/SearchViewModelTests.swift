//
//  SearchViewModelTests.swift
//  PomeloNewYorkTimesTests
//
//  Created by Chaiyatat Saiphin on 27/3/2565 BE.
//

import XCTest
import RxSwift
@testable import PomeloNewYorkTimes

class SearchViewModelTests: XCTestCase {
    
    private var articleSearchResponse: ArticleSearchResponse = ArticleSearchResponse()
    
    override func setUp() {
        let articleSearchJsonResponse = DataMockManager.getDataFromFile(name: "ArticleSearchJsonResponse")
        
        if let articleSearchResponse = ArticleSearchResponse(JSON: articleSearchJsonResponse.first ?? [:]) {
            self.articleSearchResponse = articleSearchResponse
        }
    }
    
    func test_ElecticKeywordFirstPage_fetchArticleSearch_DataShouldNotEmpty() {
        //Given
        let spy = ArticleSearchUsecaseSpy()
        spy.stubbedExecuteResult = .just(articleSearchResponse.response)
        let searchViewModel = SearchViewModel(articleSearchUsecase: spy)
        
        //When
        searchViewModel.fetchArticleSearch(keyWord: "electic", isSeeMore: false)
        
        //Then
        XCTAssertTrue(searchViewModel.page == 1)
        XCTAssertTrue(searchViewModel.getNumberOfRow() > 0)
    }
    
    func test_EmptyKeyword_fetchArticleSearch_DataShouldEmpty() {
        //Given
        let searchViewModel = SearchViewModel()
        
        //When
        searchViewModel.fetchArticleSearch(keyWord: "", isSeeMore: false)
        
        //Then
        XCTAssertTrue(searchViewModel.getNumberOfRow() == 0)
    }
    
    func test_ElecticKeywordSeemorePage_fetchArticleSearch_DataShouldNotEmptyAndPageMoreThanOne() {
        //Given
        let spy = ArticleSearchUsecaseSpy()
        spy.stubbedExecuteResult = .just(articleSearchResponse.response)
        let searchViewModel = SearchViewModel(articleSearchUsecase: spy)
        
        //When
        searchViewModel.fetchArticleSearch(keyWord: "electic", isSeeMore: false)
        searchViewModel.fetchArticleSearchSeeMore()
        
        //Then
        XCTAssertTrue(searchViewModel.page > 1)
        XCTAssertTrue(searchViewModel.getNumberOfRow() > 0)
    }
    
    func test_EmptyData_fetchArticleSearchSeeMore_DataShouldEmpty() {
        //Given
        let searchViewModel = SearchViewModel()
        
        //When
        searchViewModel.fetchArticleSearchSeeMore()
        
        //Then
        XCTAssertTrue(searchViewModel.getNumberOfRow() == 0)
    }
    
}

class ArticleSearchUsecaseSpy: ArticleSearchUsecase {

    var invokedExecute = false
    var invokedExecuteCount = 0
    var invokedExecuteParameters: (keyWord: String, page: Int)?
    var invokedExecuteParametersList = [(keyWord: String, page: Int)]()
    var stubbedExecuteResult: Observable<[ArticleSearchItem]>!

    func execute(keyWord: String, page: Int) -> Observable<[ArticleSearchItem]> {
        invokedExecute = true
        invokedExecuteCount += 1
        invokedExecuteParameters = (keyWord, page)
        invokedExecuteParametersList.append((keyWord, page))
        return stubbedExecuteResult
    }
}
