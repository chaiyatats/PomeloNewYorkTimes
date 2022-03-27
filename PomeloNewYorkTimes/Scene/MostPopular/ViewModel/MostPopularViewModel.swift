//
//  MostPopularViewModel.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 25/3/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa

protocol MostPopularViewModelInput {
    func fetchFirebaseConfig()
    func fetchMostPopular(periodTime: PeriodTime)
    func selectedItem(navigation: UINavigationController?, index: Int)
    func openSearchPage(navigation: UINavigationController?)
}

protocol MostPopularViewModelOutput {
    var isLoading: Driver<Bool> { get }
    var reloadData: Driver<Void> { get }
    
    func getNumberOfRow() -> Int
    func getCellTable(on tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

protocol MostPopularViewModelProtocol: MostPopularViewModelInput, MostPopularViewModelOutput {
    var input: MostPopularViewModelInput { get }
    var output: MostPopularViewModelOutput { get }
}

final class MostPopularViewModel: MostPopularViewModelProtocol {
    
    var input: MostPopularViewModelInput { return self }
    var output: MostPopularViewModelOutput { return self }
    
    var isLoading: Driver<Bool> = .empty()
    var reloadData: Driver<Void> = .empty()
    
    private let _isLoading: PublishRelay<Bool> = .init()
    private let _reloadData: PublishRelay<Void> = .init()
    
    private var mostPopularItems: [MostPopularItem] = []
    private var mostPopularUsecase: MostPopularUsecase
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(mostPopularUsecase: MostPopularUsecase = MostPopularUsecaseImpl()) {
        self.mostPopularUsecase = mostPopularUsecase
        
        isLoading = _isLoading.asDriver(onErrorJustReturn: false)
        reloadData = _reloadData.asDriver(onErrorDriveWith: .empty())
    }
    
    func fetchFirebaseConfig() {
        FirestoreManager.shared.getConfig {
            self.fetchMostPopular(periodTime: .day)
        }
    }
    
    func fetchMostPopular(periodTime: PeriodTime) {
        _isLoading.accept(true)
        mostPopularUsecase
            .execute(periodTime: periodTime)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.mostPopularItems = response
                self._reloadData.accept(())
                self._isLoading.accept(false)
            }).disposed(by: disposeBag)
    }
    
}

extension MostPopularViewModel: MostPopularViewModelInput {
    
    func selectedItem(navigation: UINavigationController?, index: Int) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        let item = self.mostPopularItems[index]
        let detailViewModel = DetailViewModel(webUrl: item.url)
        detailViewController.configure(viewModel: detailViewModel)
        navigation?.pushViewController(detailViewController, animated: true)
    }
    
    func openSearchPage(navigation: UINavigationController?) {
        guard let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewContoller") as? SearchViewContoller else { return }
        let navigationBar = UINavigationController(rootViewController: searchViewController)
        navigationBar.modalTransitionStyle = .crossDissolve
        navigationBar.modalPresentationStyle = .overFullScreen
        navigation?.present(navigationBar, animated: false, completion: nil)
    }
}

extension MostPopularViewModel: MostPopularViewModelOutput {
    func getNumberOfRow() -> Int {
        return self.mostPopularItems.count
    }
    
    func getCellTable(on tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let item = self.mostPopularItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MostPopularTableViewCell.identifier, for: indexPath) as? MostPopularTableViewCell
        cell?.selectionStyle = .none
        cell?.configure(item: item)
        
        return cell ?? UITableViewCell()
    }
}
