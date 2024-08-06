//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Konstantin on 17.07.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var categoryTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    static let reuseIdentifier = "CategoryCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(categoryTitle)
        setupViews()
    }
    
    private func setupViews() {
        [containerView].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [categoryTitle].forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: 75),
            
            categoryTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            categoryTitle.heightAnchor.constraint(equalToConstant: 22),
            categoryTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            categoryTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -41)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
