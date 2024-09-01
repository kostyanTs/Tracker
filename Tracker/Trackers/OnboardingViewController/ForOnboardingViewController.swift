//
//  ForOnboardingViewController.swift
//  Tracker
//
//  Created by Konstantin on 14.08.2024.
//

import UIKit

final class ForOnboardingViewControlller: UIViewController {
    
    var backgroundImage: UIImage?
    var textForLabel: String?
    
    private lazy var contentView: UIImageView = {
        let view = UIImageView()
        view.image = backgroundImage
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLabel()
    }
    
    func setupViews() {
        [contentView,
         textLabel
        ].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 388),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupLabel() {
        if backgroundImage == UIImage(named: "blueBackground") {
            textLabel.text = "Отслеживайте только \n то, что хотите"
        }
        if backgroundImage == UIImage(named: "redBackground") {
            textLabel.text = "Даже если это \n не литры воды и йога"
        }
    }
}

