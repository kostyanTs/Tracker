//
//  CustomButton.swift
//  Tracker
//
//  Created by Konstantin on 15.07.2024.
//

import UIKit

final class CustomButton: UIView {
    
    var buttonTapHandler: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGrey
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ButtonIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, categoryTitle: String?) {
        titleLabel.text = title
        if categoryTitle != nil {
            addSubview(titleLabel)
            addSubview(categoryLabel)
            categoryLabel.text = categoryTitle
            categoryLabel.isHidden = false
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
                titleLabel.heightAnchor.constraint(equalToConstant: 22),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56),
                
                categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
                categoryLabel.heightAnchor.constraint(equalToConstant: 22),
                categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56)
            ])
        } else {
            addSubview(titleLabel)
            categoryLabel.isHidden = true
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
                titleLabel.heightAnchor.constraint(equalToConstant: 22),
            ])
        }
    }
    
    private func setupViews() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func buttonTapped() {
        buttonTapHandler?()
    }
}
