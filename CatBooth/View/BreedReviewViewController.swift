//
//  BreedReviewViewController.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class BreedReviewViewController: UIViewController {

    private var tableView = UITableView(frame: .zero, style: .grouped)
    private var imageView = UIImageView()
    
    private var imageHeight: CGFloat!
    
    init(imageHeight: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.imageHeight = imageHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyViewCode()
    }
    
    private func applyViewCode() {
      buildHierarchy()
      setupConstraints()
      configureViews()
    }
    
    private func buildHierarchy() {
        view.addSubview(imageView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])
    }

    private func configureViews() {
        view.backgroundColor = .white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "pet")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BreedReviewTableViewCell.self, forCellReuseIdentifier: BreedReviewTableViewCell.reuseId)
        tableView.backgroundColor = .white

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BreedReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BreedReviewTableViewCell.reuseId, for: indexPath) as!
            BreedReviewTableViewCell
        cell.textLabel?.text = "Index \(indexPath.row)"
        cell.detailTextLabel?.text = "Desct"
        return cell
    }
    
}

class BreedReviewTableViewCell: UITableViewCell {
    
    static let reuseId = "BreedTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
