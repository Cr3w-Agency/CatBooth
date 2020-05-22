//
//  ImageReviewViewController.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class ImageReviewViewController: UIViewController {
    
    private var image: UIImage!
    
    private var imageScrollView: ImageScrollView!
    
    private var saveButton: UIButton!
    private var addToFavoriteButton: UIButton!
    private var dismissButton: UIButton!
    
    private var buttomSize: CGFloat = 40
    private var imageId: String!
    private var addImage: Bool!
    
    init(image: UIImage, id: String, addImage: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        self.imageId = id
        self.addImage = addImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc private func saveButtonTapped() {
        
    }
    
    @objc private func addToFavoriteButtonTapped(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "heart") {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            workWithImage(add: addImage)
        } else {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            workWithImage(add: addImage)
        }
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    private func workWithImage(add: Bool) {
        if add {
            addToFavorite()
        } else {
            deleteImage()
            dismissButtonTapped()
        }
    }
    
    private func addToFavorite() {
        NetworkManager.shared.addToFavorite(id: imageId)
    }
    
    private func deleteImage() {
        NetworkManager.shared.deleteImage(imageId: imageId)
    }
    
    private func setupUI() {
        saveButton = UIButton()
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.tintColor = UIColor.mainBlue()
        saveButton.contentHorizontalAlignment = .fill
        saveButton.contentVerticalAlignment = .fill
        saveButton.imageView?.contentMode = .scaleAspectFit
        
        addToFavoriteButton = UIButton()
        let buttonImage = addImage ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        addToFavoriteButton.setImage(buttonImage, for: .normal)
        addToFavoriteButton.addTarget(self, action: #selector(addToFavoriteButtonTapped),
                                      for: .touchUpInside)
        addToFavoriteButton.tintColor = UIColor.mainBlue()
        addToFavoriteButton.contentHorizontalAlignment = .fill
        addToFavoriteButton.contentVerticalAlignment = .fill
        addToFavoriteButton.imageView?.contentMode = .scaleAspectFit
        addToFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton = UIButton()
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        dismissButton.tintColor = UIColor.mainBlue()
        dismissButton.contentHorizontalAlignment = .fill
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.imageView?.contentMode = .scaleAspectFit
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        imageScrollView.set(image: image)

        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(imageScrollView)
        view.addSubview(addToFavoriteButton)
        view.addSubview(saveButton)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            addToFavoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addToFavoriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addToFavoriteButton.heightAnchor.constraint(equalToConstant: buttomSize),
            addToFavoriteButton.widthAnchor.constraint(equalToConstant: buttomSize),
            
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: addToFavoriteButton.leadingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: buttomSize),
            saveButton.widthAnchor.constraint(equalToConstant: buttomSize),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dismissButton.heightAnchor.constraint(equalToConstant: buttomSize),
            dismissButton.widthAnchor.constraint(equalToConstant: buttomSize),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
