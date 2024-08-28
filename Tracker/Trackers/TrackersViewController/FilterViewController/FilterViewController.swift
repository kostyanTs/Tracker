//
//  FilterViewController.swift
//  Tracker
//
//  Created by Konstantin on 28.08.2024.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func reloadTrackersForFilters()
}

final class FilterViewController: UIViewController {
    
    private let filters = Filters.filters
    private let dataHolder = DataHolder.shared
    
    weak var delegate: FilterDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteDay
        return view
    }()
    
    private let upperlineView: UIView = {
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.reloadTrackersForFilters()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViews() {
        [tableView,
        underlineView,
         upperlineView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 75),
            
            underlineView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 0.5),
            underlineView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            underlineView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -0.5),
            
            upperlineView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            upperlineView.heightAnchor.constraint(equalToConstant: 0.5),
            upperlineView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            upperlineView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.5),
        ])
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryTableViewCell else { return UITableViewCell()}
        cell.backgroundColor = .createTrackersTextField
        cell.categoryTitle.text = filters[indexPath.row]
        return cell
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.editingAccessoryType = .checkmark
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        tableView.cellForRow(at: indexPath)?.setEditing(true, animated: true)
        dataHolder.filter = filters[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell
        if cell?.isSelected == true {
            tableView.deselectRow(at: indexPath, animated: true)
            cell?.editingAccessoryType = .none
            dataHolder.filter = nil
            return nil
        } else {
            return indexPath
        }

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.editingAccessoryType = .none
    }
}
