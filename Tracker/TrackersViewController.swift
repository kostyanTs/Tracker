//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .ypGrey
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.backgroundColor = .dateBackground
        label.text = "14.12.22"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .searchGrey
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        return containerView
    }()
    
    private lazy var searchTextField: UITextField = {
        let inputView = UITextField()
        inputView.backgroundColor = .clear
        inputView.placeholder = "Поиск"
        inputView.font = .systemFont(ofSize: 17, weight: .regular)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "searchIcon")
        imageView.image = image
        return imageView
    }()
    
    private lazy var nilCenterImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "nilCenterIcon")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nilCenterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = "Что будем отслеживать?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupViews()
        addPlusButton()
    }
    
    private func setupViews() {
        view.addSubview(lineView)
        view.addSubview(dateLabel)
        view.addSubview(titleLabel)
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchImageView)
        view.addSubview(nilCenterImageView)
        view.addSubview(nilCenterLabel)
        
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            dateLabel.heightAnchor.constraint(equalToConstant: 34),
            dateLabel.widthAnchor.constraint(equalToConstant: 77),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            
            searchContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),
            searchContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            searchImageView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchImageView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            searchImageView.heightAnchor.constraint(equalToConstant: 15.78),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 6.37),
            searchTextField.heightAnchor.constraint(equalToConstant: 22),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            nilCenterImageView.widthAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.heightAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilCenterImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -246),
            
            nilCenterLabel.widthAnchor.constraint(equalToConstant: 343),
            nilCenterLabel.heightAnchor.constraint(equalToConstant: 18),
            nilCenterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilCenterLabel.topAnchor.constraint(equalTo: nilCenterImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func addPlusButton() {
        guard let buttonImage = UIImage(named: "plusNavItem") else { return }
        let buttonView = UIButton.systemButton(
            with: buttonImage,
            target: self,
            action: #selector(Self.didTapLeftNavButton)
        )
        buttonView.tintColor = .ypBlackDay
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        NSLayoutConstraint.activate([
            buttonView.widthAnchor.constraint(equalToConstant: 19),
            buttonView.heightAnchor.constraint(equalToConstant: 18),
            buttonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            buttonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18)
        ])
    }
    
    @objc
    private func didTapLeftNavButton() {}
}
