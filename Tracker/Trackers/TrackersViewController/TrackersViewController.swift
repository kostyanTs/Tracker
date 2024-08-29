//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    private let dataHolder = DataHolder.shared
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    var categories: [TrackerCategory]?
    var complitedTrackers: [TrackerRecord]?
    
    private var weekday: Int?
    private var selectedDate: Date?
    private var currentDate: Date?

    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .ypGrey
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
        return buttonView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var searchContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .searchGrey
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        return containerView
    }()
    
    private lazy var searchTextField: UITextField = {
        let inputView = UITextField()
        inputView.backgroundColor = .clear
        inputView.placeholder = "Поиск"
        inputView.font = .systemFont(ofSize: 17, weight: .regular)
        return inputView
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "searchIcon")
        imageView.image = image
        return imageView
    }()
    
    private lazy var nilCenterImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "nilCenterIcon")
        imageView.image = image
        return imageView
    }()
    
    private lazy var nilCenterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = "Что будем отслеживать?"
        return label
    }()
    
    private lazy var trackerCollectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, 
                                                      collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackersCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(SupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupSelfValues()
        setupViews()
        addNavItems()
        setupDelegates()
        checkCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataHolder.deleteValuesForIndexPath()
    }
    
    private func checkCategories() {
        guard let categories = self.categories else { return }
        categories.forEach({ category in
            if !category.trackers.isEmpty {
                [nilCenterLabel, nilCenterImageView].forEach{
                    $0.isHidden = true
                }
            }
        })
    }
    
    private func setupSelfValues() {
        self.currentDate = datePicker.date.getDateWithoutTime()
        let categories = makeCategoriesForWeeday(
            categories: trackerCategoryStore.loadCategories(),
            forWeekdays: currentDate?.getWeekday()
        )
        self.categories = categories?.filter{!$0.trackers.isEmpty}
        self.complitedTrackers = trackerRecordStore.loadTrackerRecords()
    }
    
    private func setupDelegates() {
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
        trackerCategoryStore.delegate = self
    }
    
    private func addNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupViews() {
        [lineView, 
         datePicker,
         plusButton, 
         titleLabel,
         searchContainerView, 
         nilCenterImageView,
         nilCenterLabel, 
         trackerCollectionView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [searchTextField, 
         searchImageView].forEach({
            searchContainerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })

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
                for i in 0..<category.trackers.count {
                    let tracker = category.trackers[i]
                    guard let weekdays = tracker.schedule else {
                        newTrackers.append(tracker)
                        continue
                    }
                    for i in 0..<weekdays.count {
                        let weekday = weekdays[i]
                        guard let weekday = weekday else { return nil }
                        if weekday.valueForDatePicker == forWeekdays {
                            newTrackers.append(tracker)
                        }
                    }
                }
                let newCategory = TrackerCategory(title: category.title, trackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        if newCategories.isEmpty {
            return nil
        }
        return newCategories
    }
    
    private func configCell(cell: TrackersCollectionViewCell, with indexPath: IndexPath) {
        guard let categories = self.categories else { return }
        cell.mainView.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color
        cell.emojiView.text = categories[indexPath.section].trackers[indexPath.row].emoji
        cell.titleLabel.text = categories[indexPath.section].trackers[indexPath.row].name
        let currentDate = datePicker.date.getDateWithoutTime()
        let trackerId = categories[indexPath.section].trackers[indexPath.row].id
        let complitedDates = complitedTrackers?.filter{$0.id.hashValue == trackerId.hashValue} ?? []
        if selectedDate == nil {
            selectedDate = currentDate
        }
        if categories[indexPath.section].trackers[indexPath.row].schedule != nil {
            cell.dayLabel.text = "\(complitedDates.count) дней"
        } else {
            cell.dayLabel.text = ""
            if !complitedDates.isEmpty {
                cell.plusButton.setImage(cell.setupDoneButtonImage(), for: .normal)
                cell.plusButton.tintColor = .ypWhiteDay
                cell.plusButton.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color.withAlphaComponent(0.3)
                cell.isDone = true
            }
        }
        let complitedTrackerForDay = complitedDates.filter{$0.date == selectedDate}
        print(complitedTrackerForDay)
        if complitedTrackerForDay.isEmpty {
            cell.plusButton.setImage(cell.setupPlusButtonImage(), for: .normal)
            cell.plusButton.tintColor = categories[indexPath.section].trackers[indexPath.row].color
            cell.backgroundColor = .clear
            cell.isDone = false
        } else {
            cell.plusButton.setImage(cell.setupDoneButtonImage(), for: .normal)
            cell.plusButton.tintColor = .ypWhiteDay
            cell.plusButton.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color.withAlphaComponent(0.3)
            cell.isDone = true
        }
    }
    
    private func configHeader(view: SupplementaryView, with indexPath: IndexPath) {
        guard let categories = self.categories else { return }
        view.titleLabel.text = categories[indexPath.section].title
        view.backgroundColor = .clear
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
        let categories = makeCategoriesForWeeday(
            categories: trackerCategoryStore.loadCategories(),
            forWeekdays: weekday
        )
        self.categories = categories?.filter{!$0.trackers.isEmpty}
        trackerCollectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
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
        configHeader(view: view, with: indexPath)
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let categories = self.categories else { return 0 }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = self.categories else { return 0 }
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackersCollectionViewCell.identifier,
            for: indexPath
        ) as? TrackersCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        configCell(cell: cell, with: indexPath)
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            let fixed = UIAction(title: "Закрепить") { [weak self] _ in
                // TODO: make fixed category
            }
            let edit = UIAction(title: "Редактировать") { [weak self] _ in
                // TODO: Make EditViewController
            }
            let delete = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                // TODO: add delete func to TrackerCategoryStore
            }
            return UIMenu(title: "", children: [fixed, edit, delete])
        }
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
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: collectionView.frame.width * 0.08
            )
        )
    }
}

extension TrackersViewController: CreateTrackersDelegate {
    func reloadTrackersCollectionView() {
        weekday = nil
        let categories = makeCategoriesForWeeday(
            categories: trackerCategoryStore.loadCategories(),
            forWeekdays: currentDate?.getWeekday()
        )
        self.categories = categories?.filter{!$0.trackers.isEmpty}
        trackerCollectionView.reloadData()
        nilCenterLabel.isHidden = true
        nilCenterImageView.isHidden = true
        print("delegate work")
    }
}

extension TrackersViewController: TrackersCollectionViewCellProtocol {
    func didTapPlusTrackerButton(_ cell: TrackersCollectionViewCell, completion: @escaping (Tracker, Int, Bool) -> Void) {
        guard let currentDate = currentDate else { return }
        guard let datePickerDate = datePicker.date.getDateWithoutTime() else { return }
        if !datePickerDate.isBeforeOrEqual(date: currentDate){
            return
        }
        guard let indexPath = trackerCollectionView.indexPath(for: cell) else { return }
        guard let categories = self.categories else { return }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let id = tracker.id
        var date = selectedDate
        if date == nil {
            date = datePicker.date.getDateWithoutTime()
        }
        guard let date else { return }
        let trackerRecord = TrackerRecord(id: id, date: date)
        if cell.isDone {
            trackerRecordStore.deleteTrackerRecord(trackerRecord: trackerRecord)
        } else {
            trackerRecordStore.addNewTrackerRecord(trackerRecord: trackerRecord)
        }
        self.complitedTrackers = trackerRecordStore.loadTrackerRecords()
        let complitedDates = complitedTrackers?.filter{$0.id.hashValue == id.hashValue} ?? []
        let countComplitedDates = complitedDates.count
        completion(tracker, countComplitedDates, cell.isDone)
        if tracker.schedule == nil {
            cell.dayLabel.text = ""
        }
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func updateTrackers(indexPath: IndexPath) {
        trackerCollectionView.reloadData()
    }
}
