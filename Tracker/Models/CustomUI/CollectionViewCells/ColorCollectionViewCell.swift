//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Konstantin on 23.07.2024.
//
import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let identifier = "ColorCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            colorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
            
        ])
    }
}
