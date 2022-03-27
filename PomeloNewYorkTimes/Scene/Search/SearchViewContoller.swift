//
//  SearchViewContoller.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 26/3/2565 BE.
//

import UIKit
import RxSwift

final class SearchViewContoller: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: SearchViewModelProtocol = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerCell()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
        searchBar.becomeFirstResponder()
        searchBar.showsCancelButton = true
    }
    
    private func binding() {
        
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(2000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] searchText in
                guard let self = self else { return }
                self.viewModel.input.fetchArticleSearch(keyWord: searchText,
                                                        isSeeMore: false)
            })
        
        searchBar.rx
            .cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.reloadData.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
}

//MARK: - UITableViewDataSource
extension SearchViewContoller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getCellTable(on: tableView, indexPath: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension SearchViewContoller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRow()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.input.selectedItem(navigation: self.navigationController, index: indexPath.row)
    }
}

//MARK: - UIScrollViewDelegate
extension SearchViewContoller: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > (contentHeight * 0.45) {
            viewModel.input.fetchArticleSearchSeeMore()
        }
    }
}
