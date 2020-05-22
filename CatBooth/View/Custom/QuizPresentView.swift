//
//  QuizPresentView.swift
//  CatBooth
//
//  Created by cr3w on 22.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

protocol StartQuizDelegate {
    func startQuiz()
}

class QuizPresentView: UIView {
    
    private let presentLabel = UILabel()
    private let quizImageView = UIImageView()
    private let yourRecordLabel = UILabel()
    private let startButton = UIButton()
    
    var delegate: StartQuizDelegate?
    
    var record: Int! {
        didSet {
            yourRecordLabel.text = "Your current record: \(record!)"
        }
    }
    
    init(frame: CGRect, record: Int) {
        super.init(frame: frame)
        self.record = record
        applyViewCode()
    }
    
//    override init(frame: CGRect, record: Int) {
//        super.init(frame: frame)
//        backgroundColor = .white
//    }
    
    @objc private func startQuiz() {
        print(#function)
        delegate?.startQuiz()
    }
    
    private func applyViewCode() {
        buildHierarchy()
        setupConstraints()
        configureViews()
    }
    
    private func buildHierarchy() {
        addSubview(presentLabel)
        addSubview(quizImageView)
        addSubview(yourRecordLabel)
        addSubview(startButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            presentLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            presentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            quizImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quizImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            quizImageView.topAnchor.constraint(equalTo: presentLabel.bottomAnchor, constant: 20),
            quizImageView.heightAnchor.constraint(equalToConstant: 200),
            
            yourRecordLabel.topAnchor.constraint(equalTo: quizImageView.bottomAnchor, constant: 20),
            yourRecordLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            startButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                constant: -10),
        ])
        
    }
    
    private func configureViews() {
        backgroundColor = .white
        
        presentLabel.translatesAutoresizingMaskIntoConstraints = false
        presentLabel.font = UIFont.chewyRegular(size: 50)
        presentLabel.textColor = UIColor.mainBlue()
        presentLabel.text = "GUESS THE BREED"
        presentLabel.textAlignment = .center
        
        quizImageView.translatesAutoresizingMaskIntoConstraints = false
        quizImageView.contentMode = .scaleAspectFit
        quizImageView.backgroundColor = .white
        quizImageView.image = #imageLiteral(resourceName: "pet")
        
        yourRecordLabel.translatesAutoresizingMaskIntoConstraints = false
        yourRecordLabel.text = "Your current record: \(record!)"
        yourRecordLabel.font = UIFont.latoRegular(size: 20)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("START QUIZ", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.backgroundColor = UIColor.mainBlue()
        startButton.layer.cornerRadius = 5
        startButton.titleLabel?.font = UIFont.latoRegular(size: 20)
        startButton.addTarget(self, action: #selector(startQuiz), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
