//
//  MostPopularViewController.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 25/3/2565 BE.
//

import Foundation
import UIKit
import RxSwift

final class MostPopularViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    private let viewModel: MostPopularViewModelProtocol = MostPopularViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviation()
        registerCell()
        binding()
        viewModel.fetchFirebaseConfig()
    }
    
    private func setupNaviation() {
        let filterButton = UIBarButtonItem(image: UIImage(named: "filter_icon"), style: .plain, target: self, action: #selector(openFilter))
        navigationItem.rightBarButtonItems = [filterButton]
    }
    
    private func binding() {
        
        searchBar.rx
            .textDidBeginEditing
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.input.openSearchPage(navigation: self.navigationController)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.reloadData.drive(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.output.isLoading.drive(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            self.indicator.isHidden = !isLoading
        }).disposed(by: disposeBag)
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: MostPopularTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MostPopularTableViewCell.identifier)
    }
    
    @objc private func openFilter() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Day", style: .default, handler: { _ in
            self.viewModel.fetchMostPopular(periodTime: .day)
        }))
        actionSheet.addAction(UIAlertAction(title: "Week", style: .default, handler: { _ in
            self.viewModel.fetchMostPopular(periodTime: .week)
        }))
        actionSheet.addAction(UIAlertAction(title: "Month", style: .default, handler: { _ in
            self.viewModel.fetchMostPopular(periodTime: .month)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension MostPopularViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.output.getCellTable(on: tableView, indexPath: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension MostPopularViewController: UITableViewDelegate {
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
