//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Konstantin on 25.07.2024.
//

import UIKit

protocol TrackersCollectionViewCellProtocol: AnyObject {
    func didTapPlusTrackerButton(_ cell: TrackersCollectionViewCell, completion: @escaping (Tracker, Int, Bool) -> Void)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: TrackersCollectionViewCellProtocol?
    
    var isDone: Bool = false
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        return view
    }()
    
    lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .ypWhiteDay
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    lazy var emojiViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var emojiView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var plusButton: UIButton = {
        guard let buttonImage = UIImage(named: "plusTrackerCollection") else { return UIButton() }
        let buttonView = UIButton.systemButton(
            with: buttonImage,
            target: self,
            action: #selector(Self.didTapTrackerCollectionButton)
        )
        return buttonView
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .ypBlackDay
        label.textAlignment = .left
        label.text = "0 дней"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    lazy var fixImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "fixIcon")
        imageView.image = image
        imageView.tintColor = .white
        imageView.isHidden = true
        return imageView
    }()
    
    static let identifier = "TrackerCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        emojiViewContainer.layer.cornerRadius = emojiViewContainer.frame.size.width / 2
        plusButton.layer.cornerRadius = plusButton.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        [containerView].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [mainView, buttonView].forEach{
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [titleLabel,emojiViewContainer, fixImage].forEach{
            mainView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [emojiView].forEach{
            emojiViewContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [plusButton, dayLabel].forEach{
            buttonView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            mainView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            mainView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            mainView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            mainView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6),
            
            buttonView.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            buttonView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            buttonView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            buttonView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4),
            
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: emojiView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -12),
            
            emojiViewContainer.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            emojiViewContainer.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            emojiViewContainer.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.3),
            emojiViewContainer.widthAnchor.constraint(equalTo: emojiViewContainer.heightAnchor, multiplier: 1),
            
            emojiView.topAnchor.constraint(equalTo: emojiViewContainer.topAnchor, constant: 1),
            emojiView.leadingAnchor.constraint(equalTo: emojiViewContainer.leadingAnchor, constant: 1),
            emojiView.trailingAnchor.constraint(equalTo: emojiViewContainer.trailingAnchor, constant: -1),
            emojiView.bottomAnchor.constraint(equalTo: emojiViewContainer.bottomAnchor, constant: -1),
            
            fixImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            fixImage.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -4),
            fixImage.widthAnchor.constraint(equalTo: fixImage.heightAnchor),
            fixImage.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -54),
            
            plusButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalTo: buttonView.widthAnchor, multiplier: 0.2),
            plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 16),
            dayLabel.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 12),
            dayLabel.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -54),
            dayLabel.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupDoneButton(color: UIColor) {
        guard let buttonImage = UIImage(named: "DoneIcon") else { return }
        self.plusButton.setImage(buttonImage, for: .normal)
        plusButton.backgroundColor = color.withAlphaComponent(0.3)
        plusButton.tintColor = .ypWhiteDay
    }
    
    func setupPlusButtonImage() -> UIImage {
        guard let buttonImage = UIImage(named: "plusTrackerCollection") else { return UIImage() }
        return buttonImage
    }
    
    func setupDoneButtonImage() -> UIImage {
        guard let buttonImage = UIImage(named: "DoneIcon") else { return UIImage() }
        return buttonImage
    }

    @objc
    private func didTapTrackerCollectionButton() {
        delegate?.didTapPlusTrackerButton(self) { [weak self] tracker, countComplitedDates, isDone in
            guard let self = self else {
                print("[TrackersCollectionViewCell]: didTapTrackerCollectionButton error in delegate?.didTapPlusTrackerButton")
                return
            }
            if isDone {
                plusButton.setImage(setupPlusButtonImage(), for: .normal)
                plusButton.tintColor = tracker.color
                backgroundColor = .clear
                dayLabel.text = "\(countComplitedDates) дней"
                self.isDone = false
            } else {
                plusButton.setImage(setupDoneButtonImage(), for: .normal)
                plusButton.tintColor = .ypWhiteDay
                plusButton.backgroundColor = tracker.color.withAlphaComponent(0.3)
                dayLabel.text = "\(countComplitedDates) дней"
                self.isDone = true
            }
        }
    }
}
