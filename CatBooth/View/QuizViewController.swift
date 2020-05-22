//
//  QuizViewController.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, StartQuizDelegate {
    
    private var presentView: QuizPresentView!
    var viewModel: QuizViewModelProtocol!
    
    // UI
    private let lifesLeftLabel = UILabel()
    private let answerCounterLabel = UILabel()
    private let catImageView = UIImageView()
    private let questionLabel = UILabel()
    private let answersStackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let firstButton = UIButton()
    private let secondButton = UIButton()
    private let thirdButton = UIButton()
    private let fourthButton = UIButton()
    
    // Data
    lazy private var buttons = [firstButton, secondButton, thirdButton, fourthButton]
    
    private var currentRecord: Int!
    
    private var catOnImage: Cat!
    private var rightAnswers = 0 {
        didSet {
            answerCounterLabel.text = "Right answers: \(rightAnswers)"
        }
    }
    private var lifes = 5 {
        didSet {
            lifesLeftLabel.text = "Lifes left: \(lifes)"
        }
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = QuizViewModel()
        applyViewCode()
        updateView()
        currentRecord = viewModel.playerRecord()
    }
    
    @objc private func answerButtonTapped(_ sender: UIButton) {
        let answer = sender.titleLabel?.text
        if answer == catOnImage.breed?.name {
            viewModel.fetchAsnwers()
            rightAnswers += 1
        } else {
            lifes -= 1
        }
        if lifes == 0 {
            gameLost()
        }
    }
    //MARK: Logic
    func startQuiz() {
        presentView.isHidden = true
    }
    
    private func gameLost() {
        if rightAnswers > currentRecord {
            UserDefaults.standard.set(rightAnswers, forKey: "record")
            presentView.record = rightAnswers
        }
        rightAnswers = 0
        lifes = viewModel.numberOfLifes()
        presentView.isHidden = false
    }
    
    private func updateView() {
        viewModel.updateViewData = { [weak self] stage in
            guard let self = self else { return }
            switch stage {
            case .initial:
                print("initial")
            case .loading:
                self.waitingForDownload(state: true)
            case .success:
                self.waitingForDownload(state: false)
                self.setupAnswers()
            case .failure(let error):
                print(error)
                self.viewModel.fetchAsnwers()
            }
        }
    }
    
    private func setupAnswers() {
        let cats = viewModel.getCats()
        catOnImage = cats[0]
        guard let image = cats[0].image else { return }
        DispatchQueue.main.async { [weak self] in
            self?.catImageView.image = image
        }
        buttons.shuffle()
        for (i, button) in buttons.enumerated() {
            DispatchQueue.main.async {
                button.setTitle(cats[i].breed?.name, for: .normal)
            }
        }
    }
    
    private func waitingForDownload(state: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if state {
                self.activityIndicator.startAnimating()
                self.buttons.forEach({ $0.isEnabled = false })
            } else {
                self.activityIndicator.stopAnimating()
                self.buttons.forEach({ $0.isEnabled = true })
            }
        }
    }
    
    
    //MARK: Setup UI
    private func applyViewCode() {
        setupPresentView()
        buildHierarchy()
        setupConstraints()
        configureViews()
    }
    //MARK: Setup presentVIew
    func setupPresentView() {
        presentView = QuizPresentView(frame: view.bounds, record: viewModel.playerRecord())
        presentView.delegate = self
    }
    //MARK: Build hierarchy
    private func buildHierarchy() {
        view.addSubview(answerCounterLabel)
        view.addSubview(lifesLeftLabel)
        view.addSubview(catImageView)
        view.addSubview(questionLabel)
        view.addSubview(answersStackView)
        view.addSubview(activityIndicator)
        view.addSubview(presentView)
    }
    //MARK: Setup constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            answerCounterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                    constant: 20),
            answerCounterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                         constant: -10),
            
            lifesLeftLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                constant: 20),
            lifesLeftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 10),
            
            catImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            catImageView.topAnchor.constraint(equalTo: answerCounterLabel.bottomAnchor, constant: 10),
            catImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            catImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            
            questionLabel.topAnchor.constraint(equalTo: catImageView.bottomAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            questionLabel.heightAnchor.constraint(equalToConstant: 80),
            
            answersStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor),
            answersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            answersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            answersStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -10),
        ])
    }
    //MARK: Configure Views
    private func configureViews() {
        view.backgroundColor = .white
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        answerCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        answerCounterLabel.text = "Right answers: \(rightAnswers)"
        answerCounterLabel.textAlignment = .right
        answerCounterLabel.font = UIFont.latoRegular(size: 20)
        
        lifesLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        lifesLeftLabel.textAlignment = .left
        lifesLeftLabel.font = UIFont.latoRegular(size: 20)
        lifesLeftLabel.text = "Lifes left: \(lifes)"
        
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        catImageView.contentMode = .scaleAspectFit
        catImageView.backgroundColor = .white
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = UIFont.chewyRegular(size: 30)
        questionLabel.textColor = UIColor.mainBlue()
        questionLabel.text = "Guess the breed by the photo?"
        questionLabel.textAlignment = .center
        
        answersStackView.translatesAutoresizingMaskIntoConstraints = false
        answersStackView.spacing = 10
        answersStackView.distribution = .fillEqually
        answersStackView.axis = .vertical
        setupStackView()
    }
    //MARK: Setup answers buttons
    private func setupStackView() {
        var index = 0
        
        for _ in 1...2 {
            let stackView = UIStackView()
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            answersStackView.addArrangedSubview(stackView)
            
            for _ in 1...2 {
                let answerButton = buttons[index]
                stackView.addArrangedSubview(answerButton)
                answerButton.layer.cornerRadius = 5
                answerButton.titleLabel?.font = UIFont.latoRegular(size: 20)
                answerButton.titleLabel?.numberOfLines = 0
                answerButton.backgroundColor = .white
                answerButton.layer.borderWidth = 2
                answerButton.layer.borderColor = UIColor.mainBlue().cgColor
                answerButton.setTitleColor(.black, for: .normal)
                answerButton.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
                index += 1
            }
        }
    }
}


