//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Konstantin on 22.07.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    private let dataHolder = DataHolder.shared
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()
        tableView.register(ScheduleTableViewcell.self, forCellReuseIdentifier: ScheduleTableViewcell.reuseIdentifier)
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
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(Self.didTapReadyButton), for: .touchUpInside)
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.backgroundColor = .ypBlackDay
        button.isEnabled = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupNavBar()
        setupViews()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataHolder.scheduleForIndexPath = nil
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
        [tableView, underlineView,
         upperlineView, readyButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 75),
            tableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -47),
            
            underlineView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 0.5),
            underlineView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            underlineView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -0.5),
            
            upperlineView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            upperlineView.heightAnchor.constraint(equalToConstant: 0.5),
            upperlineView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            upperlineView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.5),
            
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    private func checkTableSwitches() {
        for i in 0..<7 {
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? ScheduleTableViewcell else { return }
            let day = WeekDay(rawValue: i)
            if cell.tableSwitch.isOn {
                if dataHolder.scheduleForIndexPath == nil {
                    dataHolder.scheduleForIndexPath = [day]
                } else {
                    dataHolder.scheduleForIndexPath?.append(day)
                }
            } else {
                let array = dataHolder.scheduleForIndexPath?.filter { $0 != day}
                dataHolder.scheduleForIndexPath = array
                if dataHolder.scheduleForIndexPath?.isEmpty == true {
                    dataHolder.scheduleForIndexPath = nil
                }
            }
        }
    }
    
    @objc
    private func didTapReadyButton() {
        checkTableSwitches()
        navigationController?.popViewController(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewcell.reuseIdentifier, for: indexPath) as? ScheduleTableViewcell else { return UITableViewCell()}
        cell.backgroundColor = .createTrackersTextField
        let day = WeekDay(rawValue: indexPath.row)
        cell.scheduleTitle.text = day?.dayValue
        return cell
    }
  
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
}
