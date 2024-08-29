//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Konstantin on 15.07.2024.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .createTrackersTextField
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var categoryTitleTextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.addTarget(self, action: #selector(Self.textFieldDidChanged), for: .editingChanged)
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlackDay
        textField.placeholder = "Введите название категории"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(Self.didTapReadyButton), for: .touchUpInside)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .ypWhiteDay
        button.backgroundColor = .ypGrey
        button.isEnabled = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupNavBar()
        setupViews()
        setupDelegates()
    }
    
    private func setupDelegates() {
        categoryTitleTextField.delegate = self
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(categoryTitleView)
        categoryTitleView.addSubview(categoryTitleTextField)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            categoryTitleView.heightAnchor.constraint(equalToConstant: 75),
            categoryTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            categoryTitleTextField.topAnchor.constraint(equalTo: categoryTitleView.topAnchor, constant: 27),
            categoryTitleTextField.leadingAnchor.constraint(equalTo: categoryTitleView.leadingAnchor, constant: 16),
            categoryTitleTextField.trailingAnchor.constraint(equalTo: categoryTitleView.trailingAnchor, constant: -41),
            
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func didTapReadyButton() {
        guard let category = categoryTitleTextField.text else { return }
        trackerCategoryStore.saveOnlyTitleCategory(categoryTitle: category)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChanged() {
        readyButton.isEnabled = true
        readyButton.backgroundColor  = .ypBlackDay
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
