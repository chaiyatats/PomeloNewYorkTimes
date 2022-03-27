//
//  DetailViewModel.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 25/3/2565 BE.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailViewModelInput {}

protocol DetailViewModelOutput {
    func getUrl() -> URL
}

protocol DetailViewModelProtocol: DetailViewModelInput, DetailViewModelOutput {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get }
}

final class DetailViewModel: DetailViewModelProtocol {
    
    var input: DetailViewModelInput { return self }
    var output: DetailViewModelOutput { return self }
    
    private var webUrl: URL?
    
    init(webUrl: URL? = URL(string: "https://www.pomelofashion.com")) {
        self.webUrl = webUrl
    }
}

extension DetailViewModel: DetailViewModelOutput {
    func getUrl() -> URL {
        if let webUrl = self.webUrl {
            return webUrl
        }
        // Return Default URL
        return URL(string: "https://www.pomelofashion.com")!
    }
}
