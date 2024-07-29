//
//  CreateRegularViewController.swift
//  Tracker
//
//  Created by Konstantin on 11.07.2024.
//

import UIKit

protocol CreateHabitDelegate: AnyObject {
    func reloadTrackersHabitCollectionView()
}

final class CreateHabitViewController: UIViewController {
    
    private let dataHolder = DataHolder.shared
    private let colorItems = CollectionsItems().colors
    private let emojiItems = CollectionsItems().emojies
    
    weak var delegate: CreateHabitDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhiteDay
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackerTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .createTrackersTextField
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trackerTitleTextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlackDay
        textField.placeholder = "Введите название трекера"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(Self.didTapCancelButton), for: .touchUpInside)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor.ypRed
        button.tintColor = UIColor.ypRed
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(Self.didTapCreateButton), for: .touchUpInside)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor( .ypWhiteDay, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .ypGrey
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var categoryButton: CustomButton = {
        var button = CustomButton()
        button.buttonTapHandler = { [weak self] in
            self?.didTapCategoryButton()
        }
        button.backgroundColor = .createTrackersTextField
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scheduleButton: CustomButton = {
        var button = CustomButton()
        button.buttonTapHandler = { [weak self] in
            self?.didTapSceduleButton()
        }
        button.backgroundColor = .createTrackersTextField
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let colorCollectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let emojiCollectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private var emojiTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private var colorTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цвет"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        setupNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let scheduleTitle = addScheduleTitle()
        categoryButton.configure(title: "Категория", categoryTitle: dataHolder.categoryForIndexPath)
        scheduleButton.configure(title: "Расписание", categoryTitle: scheduleTitle)
    }

    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(trackerTitleView)
        trackerTitleView.addSubview(trackerTitleTextField)
        contentView.addSubview(categoryButton)
        contentView.addSubview(scheduleButton)
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)
        contentView.addSubview(lineView)
        contentView.addSubview(colorCollectionView)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(emojiTitle)
        contentView.addSubview((colorTitle))
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor ),
            
            trackerTitleView.heightAnchor.constraint(equalToConstant: 75),
            trackerTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerTitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            trackerTitleTextField.topAnchor.constraint(equalTo: trackerTitleView.topAnchor, constant: 27),
            trackerTitleTextField.leadingAnchor.constraint(equalTo: trackerTitleView.leadingAnchor, constant: 16),
            trackerTitleTextField.trailingAnchor.constraint(equalTo: trackerTitleView.trailingAnchor, constant: -41),
            
            categoryButton.topAnchor.constraint(equalTo: trackerTitleView.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 0),
            scheduleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalTo: categoryButton.heightAnchor, multiplier: 1),
            
            lineView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 0),
            lineView.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 15.95),
            lineView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -15.95),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
            
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            emojiCollectionView.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 74),
            emojiCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),
            
            emojiTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emojiTitle.bottomAnchor.constraint(equalTo: emojiCollectionView.topAnchor, constant: -24),
            
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 82),
            colorCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),
            
            colorTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorTitle.bottomAnchor.constraint(equalTo: colorCollectionView.topAnchor, constant: -24),
        ])
    }
    
    private func addScheduleTitle() -> String? {
        var scheduleTitle: String?
        var counter = 0
        if dataHolder.scheduleForIndexPath != nil {
            guard let scheduleForIndexPath = dataHolder.scheduleForIndexPath else { return nil }
            for i in scheduleForIndexPath {
                guard let i = i else { return nil }
                if scheduleTitle == nil {
                    scheduleTitle = i.keyValue
                    counter += 1
                } else {
                    scheduleTitle?.append(contentsOf: ", \(i.keyValue)")
                    counter += 1
                }
            }
        }
        if counter == 7 {
            return "Каждый день"
        }
        return scheduleTitle
    }
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        if (trackerTitleTextField.text == nil) || dataHolder.categoryForIndexPath == nil || dataHolder.scheduleForIndexPath == nil || dataHolder.colorForIndexPath == nil || dataHolder.emojiForIndexPath == nil {
            return
        }
        guard let nameTracker = trackerTitleTextField.text,
              let color = dataHolder.colorForIndexPath,
              let emoji = dataHolder.emojiForIndexPath,
              let schedule = dataHolder.scheduleForIndexPath
        else { return }
        guard let dateWithouTime = Date().getDateWithoutTime() else { return }
        let tracker = Tracker(id: dataHolder.counterForId,
                              name: nameTracker,
                              color: color,
                              emoji: emoji,
                              schedule: schedule,
                              createdDate: dateWithouTime)
        dataHolder.counterForId += 1
        guard let categories = dataHolder.categories else { return }
        for i in 0..<categories.count {
            if dataHolder.categories?[i].title == dataHolder.categoryForIndexPath {
                if dataHolder.categories?[i].trackers == nil {
                    dataHolder.categories?[i].changeTrackers(newValue: [tracker])
                } else {
                    var trackers = dataHolder.categories?[i].trackers
                    trackers?.append(tracker)
                    guard let trackers = trackers else { return }
                    dataHolder.categories?[i].changeTrackers(newValue: trackers)
                }
            }
        }
        print(dataHolder.categories as Any)
        dataHolder.categoryForIndexPath = nil
        dataHolder.colorForIndexPath = nil
        dataHolder.emojiForIndexPath = nil
        dataHolder.scheduleForIndexPath = nil
        delegate?.reloadTrackersHabitCollectionView()
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCategoryButton() {
        let categoryViewController = CategoryViewController()
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    @objc
    private func didTapSceduleButton() {
        let scheduleViewController = ScheduleViewController()
        navigationController?.pushViewController(scheduleViewController, animated: true)
    }
}

extension CreateHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.colorCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
            cell.containerView.layer.borderWidth = 3
            cell.containerView.layer.borderColor = colorItems[indexPath.row].withAlphaComponent(0.3).cgColor
            cell.containerView.layer.masksToBounds = true
            cell.containerView.layer.cornerRadius = 8
            dataHolder.colorForIndexPath = colorItems[indexPath.row]
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            cell.containerView.backgroundColor = .ypGrey
            cell.containerView.layer.masksToBounds = true
            cell.containerView.layer.cornerRadius = 16
            dataHolder.emojiForIndexPath = emojiItems[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.colorCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
            cell.containerView.layer.borderColor = UIColor.ypWhiteDay.cgColor
            print(cell.isSelected)
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            cell.containerView.backgroundColor = .clear
        }
    }
}

extension CreateHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colorCollectionView {
            return colorItems.count
        } else {
            return emojiItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell()}
            cell.colorView.backgroundColor = colorItems[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell else { return UICollectionViewCell()}
            cell.emojiView.text = emojiItems[indexPath.row]
            return cell
        }
    }
}

extension CreateHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

 
