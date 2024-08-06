//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Konstantin on 24.07.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var emojiView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    static let identifier = "EmojiCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        [containerView].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [emojiView].forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            emojiView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7),
            emojiView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 7),
            emojiView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -7),
            emojiView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7)
        ])
    }
}
