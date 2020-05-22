//
//  BreedListController.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class BreedListController: UITableViewController {
    
    var viewModel: BreedListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BreedListViewModel()
        updateTableView()
        setupUI()
    }
    
    private func setupUI() {
        title = "Breeds"
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: BreedTableViewCell.reuseId)
        tableView.rowHeight = 80
    }
    
    func updateTableView() {
        viewModel.updateViewData = { [weak self] (stage) in
            guard let self = self else { return }
            switch stage {
            case .initial:
                print("init")
            case .loading:
                print("loading2")
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }

        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.reuseId, for: indexPath) as! BreedTableViewCell
        let cellViewModel = viewModel.cellViewModel(at: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = BreedReviewViewController(imageHeight: 150) //MARK: - To Do
        navigationController?.pushViewController(dvc, animated: true)
    }
}
