//
//  StatisticTableViewCell.swift
//  Tracker
//
//  Created by Konstantin on 29.08.2024.
//

import UIKit

final class StatisticTableViewcell: UITableViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var statisticTitle: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    lazy var statisticCounter: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.backgroundColor = .clear
        label.text = "0"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    static let reuseIdentifier = "StatisticCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .clear
        self.containerView.layer.addSublayer(makeGradientBorder())
    }
    
    private func setupViews() {
        [containerView].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [statisticTitle, statisticCounter].forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            
            statisticTitle.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            statisticTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            statisticCounter.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            statisticCounter.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12)
        ])
    }
    
    func makeGradientBorder() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.ypGradientRed.cgColor,
                           UIColor.ypGradientGreen.cgColor,
                           UIColor.ypGradientBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = CGRect(origin: CGPointZero, size: self.containerView.frame.size)
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: containerView.bounds,
                                  cornerRadius: containerView.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        return gradient
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
