//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private let dataHolder = DataHolder.shared
    
    var categories: [TrackerCategory]?
    var complitedTrackers: [TrackerRecord]?
    
    private var weekday: Int?
    private var selectedDate: Date?
    private var currentDate: Date?
    private var trackers: [Tracker]? = []

    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .ypGrey
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .dateBackground
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var plusButton: UIButton = {
        guard let buttonImage = UIImage(named: "plusNavItem") else { return UIButton() }
        let buttonView = UIButton.systemButton(
            with: buttonImage,
            target: self,
            action: #selector(Self.didTapLeftNavButton)
        )
        buttonView.tintColor = .ypBlackDay
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        return buttonView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .searchGrey
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        return containerView
    }()
    
    private lazy var searchTextField: UITextField = {
        let inputView = UITextField()
        inputView.backgroundColor = .clear
        inputView.placeholder = "Поиск"
        inputView.font = .systemFont(ofSize: 17, weight: .regular)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "searchIcon")
        imageView.image = image
        return imageView
    }()
    
    private lazy var nilCenterImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "nilCenterIcon")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nilCenterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = "Что будем отслеживать?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackerCollectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(SupplementaryView.self, 
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        self.currentDate = datePicker.date.getDateWithoutTime()
        let categories = makeCategoriesForWeeday(categories: dataHolder.categories, forWeekdays: currentDate?.getWeekday())
        self.categories = categories?.filter{!$0.trackers.isEmpty}
        self.complitedTrackers = dataHolder.complitedTrackers
        setupViews()
        addNavItems()
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
        print("viewDidLoad")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillApeared")
        dataHolder.categoryForIndexPath = nil
        dataHolder.scheduleForIndexPath = nil
        dataHolder.colorForIndexPath = nil
        dataHolder.emojiForIndexPath = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappeared")
    }
    private func addNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupViews() {
        view.addSubview(lineView)
        view.addSubview(datePicker)
        view.addSubview(plusButton)
        view.addSubview(titleLabel)
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchImageView)
        view.addSubview(nilCenterImageView)
        view.addSubview(nilCenterLabel)
        view.addSubview(trackerCollectionView)

        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            plusButton.widthAnchor.constraint(equalToConstant: 19),
            plusButton.heightAnchor.constraint(equalToConstant: 18),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            
            searchContainerView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),
            searchContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            
            searchImageView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchImageView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            searchImageView.heightAnchor.constraint(equalToConstant: 15.78),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 6.37),
            searchTextField.heightAnchor.constraint(equalToConstant: 22),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            nilCenterImageView.widthAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.heightAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilCenterImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -246),
            
            nilCenterLabel.widthAnchor.constraint(equalToConstant: 343),
            nilCenterLabel.heightAnchor.constraint(equalToConstant: 18),
            nilCenterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilCenterLabel.topAnchor.constraint(equalTo: nilCenterImageView.bottomAnchor, constant: 8),
            
            trackerCollectionView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 8),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1)
        ])
    }
    
    private func makeCategoriesForWeeday(categories: [TrackerCategory]?, forWeekdays: Int? = nil) -> [TrackerCategory]? {
        var newCategories: [TrackerCategory] = []
        if forWeekdays == nil {
            guard let categories = categories else { return nil }
            newCategories = categories
        }
        else {
            guard let categories = categories else { return nil }
            for category in categories {
                var newTrackers: [Tracker] = []
                let trackers = category.trackers.filter{$0.schedule != nil}
                newTrackers = trackers.filter{$0.schedule!.contains(where: {$0?.valueForDatePicker == forWeekdays})}
                let newCategory = TrackerCategory(title: category.title, trackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        if newCategories.isEmpty {
            return nil
        }
        return newCategories
    }
    
    private func addToComplitedTrackers(id: UInt) {
        var newComplitedTrackers = dataHolder.complitedTrackers ?? []
        guard let date = Date().getDateWithoutTime() else { return }
        let trackerRecord = TrackerRecord(id: id, date: date)
        newComplitedTrackers.append(trackerRecord)
        dataHolder.complitedTrackers = newComplitedTrackers
        self.complitedTrackers = newComplitedTrackers
    }
    
    @objc
    private func didTapLeftNavButton() {
        dataHolder.deleteValuesForIndexPath()
        let createTrackerViewController = CreateTrackersViewController()
        createTrackerViewController.delegate = self
        let navigationCreateTrackerViewController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationCreateTrackerViewController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date.getDateWithoutTime()
        guard let selectedDate = selectedDate else { return }
        weekday = selectedDate.getWeekday()
        self.categories = makeCategoriesForWeeday(categories: dataHolder.categories, forWeekdays: weekday)
        trackerCollectionView.reloadData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormatter.string(from: selectedDate)
    }
}

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String                                      // 1
        switch kind {                                       // 2
        case UICollectionView.elementKindSectionHeader:     // 3
            id = "header"
        case UICollectionView.elementKindSectionFooter:     // 4
            id = "footer"
        default:
            id = ""                                         // 5
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id, for: indexPath
        ) as? SupplementaryView else { return UICollectionReusableView() }
        guard let categories = self.categories else { return view }
        view.titleLabel.text = categories[indexPath.section].title
        view.backgroundColor = .clear
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var counter = 0
        guard let categories = self.categories else { return 0 }
        for category in categories {
            if !category.trackers.isEmpty {
                counter += 1
            }
        }
        return counter
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = self.categories else { return 0 }
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier, 
            for: indexPath
        ) as? TrackersCollectionViewCell else { return UICollectionViewCell()}
        guard let categories = self.categories else { return cell }
        cell.mainView.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color
        cell.emojiView.text = categories[indexPath.section].trackers[indexPath.row].emoji
        cell.emojiView.layer.masksToBounds = true
        cell.emojiView.layer.cornerRadius = 14
        cell.titleLabel.text = categories[indexPath.section].trackers[indexPath.row].name
        
        cell.delegate = self
        let currentDate = Date().getDateWithoutTime()
        let trackerId = categories[indexPath.section].trackers[indexPath.row].id
        let complitedDates = complitedTrackers?.filter{$0.id == trackerId} ?? []
        if selectedDate == nil {
            selectedDate = currentDate
        }
        let complitedTrackerForDay = complitedDates.filter{$0.date == selectedDate}
        if complitedTrackerForDay.isEmpty {
            cell.plusButton.setImage(cell.setupPlusButtonImage(), for: .normal)
            cell.plusButton.tintColor = categories[indexPath.section].trackers[indexPath.row].color
            cell.backgroundColor = .clear
        } else {
            cell.plusButton.setImage(cell.setupDoneButtonImage(), for: .normal)
            cell.plusButton.tintColor = .ypWhiteDay
            cell.plusButton.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color.withAlphaComponent(0.3)
            cell.isDone = true
        }
        
        if categories[indexPath.section].trackers[indexPath.row].schedule == nil {
            cell.dayLabel.text = "\(complitedDates.count) дней"
        }
    
        print(categories)
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 9) / 2, height: ((collectionView.frame.width - 5) / 2) * 0.89)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: collectionView.frame.width * 0.08))
                                                             
    }
}

extension TrackersViewController: CreateTrackersDelegate {
    func reloadTrackersCollectionView() {
        weekday = nil
        let categories = makeCategoriesForWeeday(categories: dataHolder.categories, forWeekdays: currentDate?.getWeekday())
        self.categories = categories?.filter{!$0.trackers.isEmpty}
        trackerCollectionView.reloadData()
        nilCenterLabel.isHidden = true
        nilCenterImageView.isHidden = true
        print("delegate work")
    }
}

extension TrackersViewController: TrackersCollectionViewCellProtocol {
    func didTapPlusTrackerButton(_ cell: TrackersCollectionViewCell, completion: @escaping (Tracker, Int) -> Void) {
        if cell.isDone == true || currentDate != datePicker.date.getDateWithoutTime() {
            return
        }
        guard let indexPath = trackerCollectionView.indexPath(for: cell) else { return }
        guard let categories = self.categories else { return }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let trackerId = tracker.id
        self.addToComplitedTrackers(id: trackerId)
        dataHolder.complitedTrackers = self.complitedTrackers
        let complitedDates = complitedTrackers?.filter{$0.id == trackerId} ?? []
        let countComplitedDates = complitedDates.count
        completion(tracker, countComplitedDates)
    }
}
