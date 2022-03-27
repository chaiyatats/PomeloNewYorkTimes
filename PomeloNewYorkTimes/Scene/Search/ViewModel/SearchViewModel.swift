//
//  SearchViewModel.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 26/3/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchViewModelInput {
    func fetchArticleSearch(keyWord: String, isSeeMore: Bool)
    func fetchArticleSearchSeeMore()
    func selectedItem(navigation: UINavigationController?, index: Int)
}

protocol SearchViewModelOutput {
    var reloadData: Driver<Void> { get }
    
    func getNumberOfRow() -> Int
    func getCellTable(on tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

protocol SearchViewModelProtocol: SearchViewModelInput, SearchViewModelOutput {
    var input: SearchViewModelInput { get }
    var output: SearchViewModelOutput { get }
}

final class SearchViewModel: SearchViewModelProtocol {
    
    var input: SearchViewModelInput { return self }
    var output: SearchViewModelOutput { return self }
    
    var reloadData: Driver<Void> = .empty()
    
    private let _reloadData: PublishRelay<Void> = .init()
    
    var page = 1
    private var keyWord = ""
    private var articleSearchItems: [ArticleSearchItem] = []
    private var articleSearchUsecase: ArticleSearchUsecase
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(articleSearchUsecase: ArticleSearchUsecase = ArticleSearchUsecaseImpl()) {
        self.articleSearchUsecase = articleSearchUsecase
        
        reloadData = _reloadData.asDriver(onErrorDriveWith: .empty())
    }
    
}

extension SearchViewModel: SearchViewModelInput {
    
    func fetchArticleSearch(keyWord: String, isSeeMore: Bool) {
        self.keyWord = keyWord
        let trimKeyWord = self.keyWord.trimmingCharacters(in: .whitespaces)
        if trimKeyWord.isEmpty { return }
        if isSeeMore {
            page += 1
        } else {
            page = 1
        }
        articleSearchUsecase
            .execute(keyWord: trimKeyWord, page: page)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                
                if !isSeeMore {
                    self.articleSearchItems = response
                } else {
                    self.articleSearchItems.append(contentsOf: response)
                }
                
                self._reloadData.accept(())
            }).disposed(by: disposeBag)
    }
    
    func fetchArticleSearchSeeMore() {
        if articleSearchItems.isEmpty { return }
        fetchArticleSearch(keyWord: self.keyWord, isSeeMore: true)
    }
    
    func selectedItem(navigation: UINavigationController?, index: Int) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        let item = self.articleSearchItems[index]
        let detailViewModel = DetailViewModel(webUrl: item.webUrl)
        detailViewController.configure(viewModel: detailViewModel)
        navigation?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchViewModel: SearchViewModelOutput {
    func getNumberOfRow() -> Int {
        return self.articleSearchItems.count
    }
    
    func getCellTable(on tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = self.articleSearchItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
        cell?.selectionStyle = .none
        cell?.configure(item: item)
        
        return cell ?? UITableViewCell()
    }
}
