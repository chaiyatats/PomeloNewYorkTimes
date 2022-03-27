//
//  DetailViewModelTests.swift
//  PomeloNewYorkTimesTests
//
//  Created by Chaiyatat Saiphin on 27/3/2565 BE.
//

import XCTest
@testable import PomeloNewYorkTimes

class DetailViewModelTests: XCTestCase {
    
    func test_CorrectWebUrl_GetUrl_ShouldGetCorrectUrl() {
        //Given
        let detailViewModel = DetailViewModel(webUrl: URL(string: "https://www.google.co.th/"))
        
        //When
        let url = detailViewModel.getUrl()
        
        //Then
        XCTAssertEqual(url.absoluteString, "https://www.google.co.th/")
    }
    
    func test_EmptyWebUrl_GetUrl_ShouldGetDefaultUrl() {
        //Given
        let detailViewModel = DetailViewModel(webUrl: nil)
        
        //When
        let url = detailViewModel.getUrl()
        
        //Then
        XCTAssertEqual(url.absoluteString, "https://www.pomelofashion.com")
    }
    
}
