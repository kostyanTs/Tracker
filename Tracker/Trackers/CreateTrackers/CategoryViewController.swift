//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Konstantin on 15.07.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private let dataHolder = DataHolder.shared
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nilCenterImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "nilCenterIcon")
        imageView.image = image
        return imageView
    }()
    
    private lazy var nilCenterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Привычки и события можно\n объединить по смыслу"
        return label
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.separatorInset = .init(top: 0, left: 15, bottom: 10, right: 15)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(Self.didTapAddCategoryButton), for: .touchUpInside)
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .ypWhiteDay
        button.backgroundColor = .ypBlackDay
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteDay
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupNavBar()
        setupViews()
        setupDelegates()
        checkCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        checkCategories()
        dataHolder.deleteCategoryForIndexPath()
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupViews() {
        [nilCenterImageView, nilCenterLabel,
         tableView, addCategoryButton,
         lineView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nilCenterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilCenterImageView.widthAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.heightAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 235),
            
            nilCenterLabel.topAnchor.constraint(equalTo: nilCenterImageView.bottomAnchor, constant: 8),
            nilCenterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nilCenterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nilCenterLabel.heightAnchor.constraint(equalToConstant: 36),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 75),
            
            lineView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            lineView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -0.5)
        ])
    }
    
    private func checkCategories() {
        let isHidden = dataHolder.categories != nil
        nilCenterLabel.isHidden = isHidden
        nilCenterImageView.isHidden = isHidden
    }
    
    @objc
    func didTapAddCategoryButton() {
        let createCategoryViewController = CreateCategoryViewController()
        if dataHolder.categoryForIndexPath == nil {
            navigationController?.pushViewController(createCategoryViewController, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = dataHolder.categories else { return 0 }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell else { return UITableViewCell()}
        cell.backgroundColor = .createTrackersTextField
        guard let categories = dataHolder.categories else { return UITableViewCell() }
        cell.categoryTitle.text = categories[indexPath.row].title
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categories = dataHolder.categories else { return }
        tableView.cellForRow(at: indexPath)?.editingAccessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        tableView.cellForRow(at: indexPath)?.setEditing(true, animated: true)
        dataHolder.categoryForIndexPath = categories[indexPath.row].title
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell
        if cell?.isSelected == true {
            tableView.deselectRow(at: indexPath, animated: true)
            cell?.editingAccessoryType = .none
            dataHolder.categoryForIndexPath = nil
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.editingAccessoryType = .none
    }
}
