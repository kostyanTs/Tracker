//
//  ScheduleTableViewcell.swift
//  Tracker
//
//  Created by Konstantin on 22.07.2024.
//

import UIKit

final class ScheduleTableViewcell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scheduleTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableSwitch: UISwitch = {
        let tableSwitch = UISwitch()
        tableSwitch.translatesAutoresizingMaskIntoConstraints = false
        tableSwitch.onTintColor = .ypBlue
        return tableSwitch
    }()
    
    static let reuseIdentifier = "ScheduleCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(scheduleTitle)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(scheduleTitle)
        containerView.addSubview(tableSwitch)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scheduleTitle.heightAnchor.constraint(equalToConstant: 22),
            scheduleTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            scheduleTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -41),
            
            tableSwitch.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 22),
            tableSwitch.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 276),
            tableSwitch.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tableSwitch.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -22)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
