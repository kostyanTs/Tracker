//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit
import YandexMobileMetrica

final class TrackersViewController: UIViewController {

    private let trackerCategoryStore = TrackerCategoryStore()
    private var viewModel: TrackersViewModel = TrackersViewModel()
    
    private var selectedDate: Date?
    private var currentDate: Date?

    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .ypLineGrey
        return lineView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .dateBackground
        datePicker.tintColor = .ypBlack
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
        label.text = NSLocalizedString("titleTracker", comment: "Yes")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var searchContainerView: UIStackView = {
        let containerView = UIStackView()
        containerView.backgroundColor = .searchGrey
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.axis = .horizontal
        containerView.distribution = .equalSpacing
        containerView.alignment = .center
        containerView.spacing = 10
        containerView.addArrangedSubview(searchImageView)
        containerView.addArrangedSubview(searchTextField)
        return containerView
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .searchGrey
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 8
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        stackView.addArrangedSubview(searchContainerView)
        stackView.addArrangedSubview(cancelButton)
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(Self.didTapCancelButton), for: .touchDown)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let inputView = UITextField()
        inputView.backgroundColor = .clear
        inputView.textColor = .ypBlackDay
        inputView.placeholder = NSLocalizedString("search", comment: "")
        inputView.tintColor = .ypSearchGreyText
        inputView.addTarget(self, action: #selector(Self.textFieldDidChanged), for: .editingChanged)
        inputView.font = .systemFont(ofSize: 17, weight: .regular)
        return inputView
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .ypSearchGreyText
        let image = UIImage(named: "searchIcon")
        imageView.image = image
        return imageView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("titleButtonFilters", comment: "Filters"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(Self.didTapFilterButton), for: .touchDown)
        return button
    }()
    
    private lazy var nilCenterImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "nilCenterIcon")
        imageView.image = image
        imageView.tintColor = .ypBlackDay
        return imageView
    }()
    
    private lazy var nilCenterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = NSLocalizedString("emptyState.title", comment: "")
        return label
    }()
    
    private lazy var nilFilteredTrackersImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "nillFilteredTrackers")
        imageView.image = image
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var nilFilteredTrackersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = NSLocalizedString("notFind", comment: "")
        label.isHidden = true
        return label
    }()
    
    private lazy var containerCollecrtionView: UIView = {
        let view = UIView()
        return view
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
        collectionView.alwaysBounceVertical = true
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.clipsToBounds = true
        collectionView.contentInset.bottom = 50
        return collectionView
    }()
    
    private lazy var extraCollecrtionView: UIView = {
        let view = UIView()
        return view
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
        viewModel.categoriesBinding = { [weak self] _ in
            guard let self = self else { return }
            self.trackerCollectionView.reloadData()
        }
        self.trackerCollectionView.reloadData()
        viewModel.deleteValuesForIndexPath()
        let params : [AnyHashable : Any] = ["key1": "TrackersViewController"]
        YMMYandexMetrica.reportEvent("EVENT: open", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    private func checkCategories() {
        guard let categories = viewModel.categories else { return }
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
        viewModel.setupCategories(currentDate: currentDate)
        viewModel.setupComplitedTrackers()
    }
    
    private func setupDelegates() {
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
        trackerCategoryStore.delegate = self
        searchTextField.delegate = self
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
         nilCenterImageView,
         nilCenterLabel, 
         nilFilteredTrackersImage,
         nilFilteredTrackersLabel,
         searchStackView,
         trackerCollectionView,
         filterButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [searchTextField, 
         searchImageView].forEach({
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
            
            searchStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchStackView.heightAnchor.constraint(equalToConstant: 36),
            searchStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
                        
            searchImageView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchImageView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            searchImageView.heightAnchor.constraint(equalToConstant: 16),
            searchImageView.widthAnchor.constraint(equalToConstant: 16),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 6.37),
            searchTextField.heightAnchor.constraint(equalToConstant: 22),
            searchTextField.widthAnchor.constraint(equalToConstant: 225),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor),
            
            nilCenterImageView.widthAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.heightAnchor.constraint(equalToConstant: 80),
            nilCenterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilCenterImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -246),
            
            nilCenterLabel.widthAnchor.constraint(equalToConstant: 343),
            nilCenterLabel.heightAnchor.constraint(equalToConstant: 18),
            nilCenterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilCenterLabel.topAnchor.constraint(equalTo: nilCenterImageView.bottomAnchor, constant: 8),
            
            nilFilteredTrackersImage.widthAnchor.constraint(equalToConstant: 80),
            nilFilteredTrackersImage.heightAnchor.constraint(equalToConstant: 80),
            nilFilteredTrackersImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilFilteredTrackersImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -246),
            
            nilFilteredTrackersLabel.widthAnchor.constraint(equalToConstant: 343),
            nilFilteredTrackersLabel.heightAnchor.constraint(equalToConstant: 18),
            nilFilteredTrackersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilFilteredTrackersLabel.topAnchor.constraint(equalTo: nilFilteredTrackersImage.bottomAnchor, constant: 8),
            
            trackerCollectionView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 8),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -66),
        ])
    }
  
    private func configCell(cell: TrackersCollectionViewCell, with indexPath: IndexPath) {
        guard let categories = viewModel.visibleCategories else { return }
        cell.mainView.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color
        cell.emojiView.text = categories[indexPath.section].trackers[indexPath.row].emoji
        cell.titleLabel.text = categories[indexPath.section].trackers[indexPath.row].name
        let currentDate = datePicker.date.getDateWithoutTime()
        let trackerId = categories[indexPath.section].trackers[indexPath.row].id
        let complitedDates = viewModel.filterComplitedTrackers(trackerId: trackerId)
        if categories[indexPath.section].title == NSLocalizedString("fixCategory", comment: "") {
            cell.fixImage.isHidden = false
        } else {
            cell.fixImage.isHidden = true
        }
        if selectedDate == nil {
            selectedDate = currentDate
        }
        if categories[indexPath.section].trackers[indexPath.row].schedule != nil {
            cell.dayLabel.text = "\(complitedDates.count) \(NSLocalizedString("cellDayTitle", comment: ""))"
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
        guard let categories = viewModel.visibleCategories else { return }
        view.titleLabel.text = categories[indexPath.section].title
        view.backgroundColor = .clear
    }
    
    private func filteredTrackersAreHidden(bool: Bool) {
        nilFilteredTrackersImage.isHidden = bool
        nilFilteredTrackersLabel.isHidden = bool
    }
    
    private func showAlert(tracker: Tracker) {
        let alert = UIAlertController(title: "Уверены что хотите удалить трекер?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { action in
            self.switchActions(style: action.style, tracker: tracker)
        }))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: {action in
            self.switchActions(style: action.style, tracker: tracker)
        }))
        self.present(alert, animated: true)
    }
    
    private func switchActions(style: UIAlertAction.Style, tracker: Tracker) {
        switch style {
        case .default:
            return
        case .cancel:
            return
        case .destructive:
            viewModel.deleteTracker(tracker: tracker)
            self.reloadTrackersForFilters()
            return
        @unknown default:
            return
        }
    }

    @objc
    private func didTapLeftNavButton() {
        let params : [AnyHashable : Any] = ["key1": "TrackersViewController", "key2": "PlusLeftNavButton"]
        YMMYandexMetrica.reportEvent("EVENT: click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        viewModel.didTapLeftNavButton()
        let createTrackerViewController = CreateTrackersViewController()
        createTrackerViewController.delegate = self
        let navigationCreateTrackerViewController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationCreateTrackerViewController, animated: true)
    }
    
    @objc
    private func didTapCancelButton() {
        searchTextField.text = nil
        textFieldDidChanged(searchTextField)
    }
    
    @objc
    private func didTapFilterButton() {
        let params : [AnyHashable : Any] = ["key1": "TrackersViewController", "key2": "FiltersButton"]
        YMMYandexMetrica.reportEvent("EVENT: click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        let filterViewController = FilterViewController()
        filterViewController.delegate = self
        let navigationFilterViewController = UINavigationController(rootViewController: filterViewController)
        present(navigationFilterViewController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date.getDateWithoutTime()
        guard let selectedDate = selectedDate else { return }
        viewModel.setupCategories(currentDate: selectedDate)
        trackerCollectionView.reloadData()
    }
    
    @objc func textFieldDidChanged(_ searchField: UITextField) {
        if let searchText = searchField.text, !searchText.isEmpty {
            viewModel.updateVisibleCategories(searchText: searchText)
            cancelButton.isHidden = false
            filteredTrackersAreHidden(bool: true)
            if viewModel.visibleCategories == nil {
                filteredTrackersAreHidden(bool: false)
            }
        } else {
            filteredTrackersAreHidden(bool: true)
            viewModel.deleteFilterForVisibleCategories()
            cancelButton.isHidden = true
        }
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
        guard let categories = viewModel.visibleCategories else { return 0 }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = viewModel.visibleCategories else { return 0 }
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else { return nil }
        let preview = cell.mainView
        return UITargetedPreview(view: preview)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let categories = viewModel.visibleCategories else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            let fixed: UIAction?
            let tracker: Tracker = categories[indexPaths[0].section].trackers[indexPaths[0].row]
            let category: TrackerCategory = categories[indexPaths[0].section]
            guard let cell = collectionView.cellForItem(at: indexPaths[0]) as? TrackersCollectionViewCell else { return nil }
            let dayText = cell.dayLabel.text
            if categories[indexPaths[0].section].title == "Fixed" {
                fixed = UIAction(title: "Открепить") { [weak self] _ in
                    self?.viewModel.unpinTracker(tracker: tracker)
                    self?.reloadTrackersForFilters()
                }
            } else {
                fixed = UIAction(title: "Закрепить") { [weak self] _ in
                    self?.viewModel.fixTracker(tracker: tracker)
                    self?.reloadTrackersForFilters()
                }
            }
            guard let fixed = fixed else { return nil }
            let edit = UIAction(title: "Редактировать") { [weak self] _ in
                let editTrackerViewController = EditTrackerViewController()
                editTrackerViewController.tracker = tracker
                editTrackerViewController.category = category
                editTrackerViewController.dayText = dayText
                editTrackerViewController.delegate = self
                let navigationController = UINavigationController(rootViewController: editTrackerViewController)
                self?.present(navigationController, animated: true)
                let params : [AnyHashable : Any] = ["key1": "TrackersViewController", "key2": "EditTrackers in contextMenu"]
                YMMYandexMetrica.reportEvent("EVENT: click", parameters: params, onFailure: { error in
                    print("REPORT ERROR: %@", error.localizedDescription)
                })
            }
            let delete = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.showAlert(tracker: tracker)
                let params : [AnyHashable : Any] = ["key1": "TrackersViewController", "key2": "delete trackers in contextMenu"]
                YMMYandexMetrica.reportEvent("EVENT: click", parameters: params, onFailure: { error in
                    print("REPORT ERROR: %@", error.localizedDescription)
                })
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
        viewModel.setupCategories(currentDate: currentDate)
        trackerCollectionView.reloadData()
        nilCenterLabel.isHidden = true
        nilCenterImageView.isHidden = true
        print("delegate work")
    }
}

extension TrackersViewController: FilterDelegate {
    func reloadTrackersForFilters() {
        let filter = viewModel.filterCategories(currentDate: self.selectedDate)
        if filter == "Трекеры на сегодня" {
            datePicker.date = Date()
        }
        trackerCollectionView.reloadData()
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
        guard let categories = viewModel.visibleCategories else { return }
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        let id = tracker.id
        var date = selectedDate
        if date == nil {
            date = datePicker.date.getDateWithoutTime()
        }
        guard let date else { return }
        let trackerRecord = TrackerRecord(id: id, date: date)
        if cell.isDone {
            viewModel.trackerIsDone(trackerRecord: trackerRecord)
        } else {
            viewModel.trackerIsNotDone(trackerRecord: trackerRecord)
        }
        viewModel.setupComplitedTrackers()
        let complitedDates = viewModel.filterComplitedTrackers(trackerId: id)
        let countComplitedDates = complitedDates.count
        completion(tracker, countComplitedDates, cell.isDone)
        if tracker.schedule == nil {
            cell.dayLabel.text = ""
        }
        
        let params : [AnyHashable : Any] = ["key1": "TrackersViewController", "key2": "trackerReadyButton"]
        YMMYandexMetrica.reportEvent("EVENT: click ", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func updateTrackers(indexPath: IndexPath) {
        trackerCollectionView.reloadData()
    }
}

extension TrackersViewController: EditTrackerDeledate {
    func reloadTrackersEditCollectionView() {
        reloadTrackersForFilters()
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
