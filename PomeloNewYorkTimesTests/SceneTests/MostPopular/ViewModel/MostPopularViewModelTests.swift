//
//  MostPopularViewModelTests.swift
//  PomeloNewYorkTimesTests
//
//  Created by Chaiyatat Saiphin on 27/3/2565 BE.
//

import XCTest
import RxSwift
@testable import PomeloNewYorkTimes

class MostPopularViewModelTests: XCTestCase {
    
    private var mostPopularResponse: MostPopularResponse = MostPopularResponse()
    
    override func setUp() {
        let mostPopularJsonResponse = DataMockManager.getDataFromFile(name: "MostPopularJsonResponse")
        
        if let mostPopularResponse = MostPopularResponse(JSON: mostPopularJsonResponse.first ?? [:]) {
            self.mostPopularResponse = mostPopularResponse
        }
    }
    
    func test_FirebaseConfig_FetchFirebaseConfig_ApiKeyShouldNotEmpty() {
        //Given
        let expectation = expectation(description: "test_FirebaseConfig_FetchFirebaseConfig_ApiKeyShouldNotEmpty")
        let mostPopularViewModel = MostPopularViewModel()
        
        //When
        mostPopularViewModel.fetchFirebaseConfig()
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        //Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertFalse(FirestoreManager.shared.getApiKey().isEmpty)
    }
    
    func test_PeriodTimeDay_FetchMostPopular_DataShouldNotEmpty() {
        //Given
        let spy = MostPopularUsecaseSpy()
        spy.stubbedExecuteResult = .just(mostPopularResponse.results)
        let mostPopularViewModel = MostPopularViewModel(mostPopularUsecase: spy)
        
        //When
        mostPopularViewModel.fetchMostPopular(periodTime: .day)
        
        //Then
        XCTAssertTrue(mostPopularViewModel.getNumberOfRow() > 0)
    }
    
    func test_PeriodTimeDay_FetchMostPopular_DataShouldEmpty() {
        //Given
        let spy = MostPopularUsecaseSpy()
        spy.stubbedExecuteResult = .error(ErrorMock.error)
        let mostPopularViewModel = MostPopularViewModel(mostPopularUsecase: spy)
        
        //When
        mostPopularViewModel.fetchMostPopular(periodTime: .day)
        
        //Then
        XCTAssertTrue(mostPopularViewModel.getNumberOfRow() == 0)
    }

}

enum ErrorMock: Error {
    case error
}

class MostPopularUsecaseSpy: MostPopularUsecase {

    var invokedExecute = false
    var invokedExecuteCount = 0
    var invokedExecuteParameters: (periodTime: PeriodTime, Void)?
    var invokedExecuteParametersList = [(periodTime: PeriodTime, Void)]()
    var stubbedExecuteResult: Single<[MostPopularItem]>!

    func execute(periodTime: PeriodTime) -> Single<[MostPopularItem]> {
        invokedExecute = true
        invokedExecuteCount += 1
        invokedExecuteParameters = (periodTime, ())
        invokedExecuteParametersList.append((periodTime, ()))
        return stubbedExecuteResult
    }
}
