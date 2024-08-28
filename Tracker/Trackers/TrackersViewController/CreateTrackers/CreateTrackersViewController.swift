//
//  CreateTrackersViewController.swift
//  Tracker
//
//  Created by Konstantin on 11.07.2024.
//

import UIKit

protocol CreateTrackersDelegate: AnyObject {
    func reloadTrackersCollectionView()
}

final class CreateTrackersViewController: UIViewController {
 
    weak var delegate: CreateTrackersDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(Self.didTapHabitButton), for: .touchUpInside)
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.backgroundColor = .ypBlackDay
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var unregularButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(Self.didTapUnregularButton), for: .touchUpInside)
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.backgroundColor = .ypBlackDay
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupView()
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
    }
    
    private func setupView() {
        [unregularButton, habitButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            unregularButton.heightAnchor.constraint(equalToConstant: 60),
            unregularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            unregularButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            unregularButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -281),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.bottomAnchor.constraint(equalTo: unregularButton.topAnchor, constant: -16),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    @objc
    private func didTapUnregularButton() {
        let createUnregularViewController = CreateUnregularEventViewController()
        createUnregularViewController.delegate = self
        navigationController?.pushViewController(createUnregularViewController, animated: true)
    }
    
    @objc
    private func didTapHabitButton() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.delegate = self
        navigationController?.pushViewController(createHabitViewController, animated: true)
    }
}

extension CreateTrackersViewController: CreateHabitDelegate {
    func reloadTrackersHabitCollectionView() {
        delegate?.reloadTrackersCollectionView()
    }
}

extension CreateTrackersViewController: CreateUnregularEventDelegate {
    func reloadTrackersUnregularCollectionView() {
        delegate?.reloadTrackersCollectionView()
    }
}
