//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Konstantin on 29.08.2024.
//

import UIKit

protocol EditTrackerDeledate: AnyObject {
    func reloadTrackersEditCollectionView()
}

final class EditTrackerViewController: UIViewController {
    
    var tracker: Tracker?
    var category: TrackerCategory?
    var dayText: String?
    
    private var indexPathForColor: IndexPath?
    private var indexPathForEmoji: IndexPath?
    
    private let dataHolder = DataHolder.shared
    private let colorItems = CollectionsItems.colors
    private let emojiItems = CollectionsItems.emojies
    private let trackerCategoryStore = TrackerCategoryStore()
    
    weak var delegate: EditTrackerDeledate?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhiteDay
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактирование привычки"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = dayText
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .ypBlackDay
        label.textAlignment = .center
        return label
    }()
    
    private lazy var trackerTitleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var trackerTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .createTrackersTextField
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var trackerTitleTextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlackDay
        textField.text = self.tracker?.name
        textField.placeholder = "Введите название трекера"
        textField.addTarget(self, action: #selector(Self.textFieldDidChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypRed
        return label
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
        button.isEnabled = false
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
        return button
    }()
    
    private let colorCollectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let emojiCollectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private var emojiTitle: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private var colorTitle: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrey
        return view
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        dataHolder.scheduleForIndexPath = tracker?.schedule
        dataHolder.categoryForIndexPath = category?.title
        setupDelegates()
        setupNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view apeared")
        setEnabledForCreateButton()
        configButtons()
    }

    private func setupNavBar() {
        navigationItem.titleView = titleLabel
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setupDelegates() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        trackerTitleTextField.delegate = self
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(trackerTitleContainerView)
        trackerTitleContainerView.addSubview(trackerTitleView)
        trackerTitleContainerView.addSubview(limitLabel)
        trackerTitleView.addSubview(trackerTitleTextField)
        [categoryButton, scheduleButton,
         createButton, cancelButton,
         lineView, colorCollectionView,
         emojiCollectionView, emojiTitle,
         colorTitle, dayLabel].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [scrollView, contentView,
         trackerTitleContainerView, limitLabel,
         trackerTitleView, trackerTitleTextField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
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
            
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            trackerTitleContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 75),
            trackerTitleContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerTitleContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trackerTitleContainerView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 40),
            
            trackerTitleView.topAnchor.constraint(equalTo: trackerTitleContainerView.topAnchor, constant: 0),
            trackerTitleView.heightAnchor.constraint(equalToConstant: 75),
            trackerTitleView.leadingAnchor.constraint(equalTo: trackerTitleContainerView.leadingAnchor, constant: 0),
            trackerTitleView.trailingAnchor.constraint(equalTo: trackerTitleContainerView.trailingAnchor, constant: 0),
            
            trackerTitleTextField.topAnchor.constraint(equalTo: trackerTitleView.topAnchor, constant: 27),
            trackerTitleTextField.leadingAnchor.constraint(equalTo: trackerTitleView.leadingAnchor, constant: 16),
            trackerTitleTextField.trailingAnchor.constraint(equalTo: trackerTitleView.trailingAnchor, constant: -41),
            
            categoryButton.topAnchor.constraint(equalTo: trackerTitleContainerView.bottomAnchor, constant: 24),
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
    
    private func addLimitLabel() {
        limitLabel.text = "Ограничение 38 символов"
        NSLayoutConstraint.activate([
            limitLabel.topAnchor.constraint(equalTo: trackerTitleView.bottomAnchor, constant: 8),
            limitLabel.bottomAnchor.constraint(equalTo: trackerTitleContainerView.bottomAnchor, constant: -8),
            limitLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            limitLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            limitLabel.leadingAnchor.constraint(equalTo: trackerTitleContainerView.leadingAnchor, constant: 28),
        ])
    }
    
    private func dismissLimitLabel() {
        limitLabel.text = nil
        NSLayoutConstraint.activate([
            limitLabel.topAnchor.constraint(equalTo: trackerTitleView.bottomAnchor, constant: 0),
            limitLabel.bottomAnchor.constraint(equalTo: trackerTitleContainerView.bottomAnchor, constant: 0),
            limitLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            limitLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            limitLabel.leadingAnchor.constraint(equalTo: trackerTitleContainerView.leadingAnchor, constant: 28),
        ])
    }
    
    private func addScheduleTitle(schedule: [WeekDay?]?) -> String? {
        var scheduleTitle: String = ""
        var counter = 0
        if schedule != nil {
            schedule?.forEach{scheduleTitle.append("\($0!.keyValue), "); counter += 1}
        }
        if scheduleTitle.isEmpty {
            return nil
        }
        if counter == 7 {
            return "Каждый день"
        } else {
            scheduleTitle.removeLast()
            scheduleTitle.removeLast()
        }
        return scheduleTitle
    }
    
    private func setEnabledForCreateButton() {
        if isButtonEnabled() {
            createButton.isEnabled = true
        }
    }
    
    private func configButtons() {
        let scheduleTitle = addScheduleTitle(schedule: dataHolder.scheduleForIndexPath)
        categoryButton.configure(title: "Категория", categoryTitle: dataHolder.categoryForIndexPath)
        scheduleButton.configure(title: "Расписание", categoryTitle: scheduleTitle)
    }
    
    private func isButtonEnabled() -> Bool {
        if (trackerTitleTextField.text == nil) ||
            dataHolder.categoryForIndexPath == nil ||
            dataHolder.colorForIndexPath == nil ||
            dataHolder.emojiForIndexPath == nil
        { return false }
        createButton.backgroundColor = .ypBlackDay
        return true
    }
    
    private func makeSchedule(schedule: [WeekDay?]?) -> [String]? {
        var scheduleString: [String] = []
        let schedule = schedule ?? []
        for weekday in schedule {
            guard let weekday = weekday else { return nil }
            scheduleString.append(weekday.dayValue)
        }
        return scheduleString
    }
    
    private func updateTracker() {
        guard let nameTracker = trackerTitleTextField.text,
              let color = dataHolder.colorForIndexPath,
              let emoji = dataHolder.emojiForIndexPath,
              let schedule = dataHolder.scheduleForIndexPath
        else { return }
        guard let id  = tracker?.id else { return }
        let tracker = Tracker(id: id,
                              name: nameTracker,
                              color: color,
                              emoji: emoji,
                              schedule: schedule)
        guard let categoryTitle = dataHolder.categoryForIndexPath else { return }
        guard let oldTracker = self.tracker else { return }
        trackerCategoryStore.updateTracker(tracker: oldTracker,
                                           updateTracker: tracker,
                                           newCategoryTitle: categoryTitle)
        dataHolder.deleteValuesForIndexPath()
    }
    
    @objc func textFieldDidChanged() {
        if trackerTitleTextField.text != nil {
            if isButtonEnabled() {
                createButton.isEnabled = true
            }
            if trackerTitleTextField.text?.count ?? 0 > 38 {
                addLimitLabel()
                createButton.isEnabled = false
            } else {
                dismissLimitLabel()
            }
        } else {
            createButton.isEnabled = false
        }
    }
    
    @objc
    private func didTapCancelButton() {
        dataHolder.deleteValuesForIndexPath()
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        guard let text = trackerTitleTextField.text else {
            createButton.isEnabled = false
            return
        }
        if  text.isEmpty ||
            dataHolder.categoryForIndexPath == nil ||
            dataHolder.scheduleForIndexPath == nil ||
            dataHolder.colorForIndexPath == nil ||
            dataHolder.emojiForIndexPath == nil
        { createButton.isEnabled = false }
        else {
            createButton.isEnabled = true
        }
        updateTracker()
        delegate?.reloadTrackersEditCollectionView()
        dismiss(animated: true)
//        print(trackerTitleTextField.text ?? "")
//        print(dataHolder.scheduleForIndexPath)
//        print(dataHolder.categoryForIndexPath ?? "")
//        print(dataHolder.colorForIndexPath ?? .red)
//        print(dataHolder.emojiForIndexPath ?? "")
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

extension EditTrackerViewController: UICollectionViewDelegate {
    
    private func selectColorCell(cell: ColorCollectionViewCell, indexPath: IndexPath) {
        cell.containerView.layer.borderWidth = 3
        cell.containerView.layer.borderColor = colorItems[indexPath.row].withAlphaComponent(0.3).cgColor
        cell.containerView.layer.masksToBounds = true
        cell.containerView.layer.cornerRadius = 8
        dataHolder.colorForIndexPath = colorItems[indexPath.row]
        if isButtonEnabled() {
            createButton.isEnabled = true
        }
    }
    
    private func selectEmojiCell(cell: EmojiCollectionViewCell, indexPath: IndexPath) {
        cell.containerView.backgroundColor = .ypLightGrey
        cell.containerView.layer.masksToBounds = true
        cell.containerView.layer.cornerRadius = 16
        dataHolder.emojiForIndexPath = emojiItems[indexPath.row]
        if isButtonEnabled() {
            createButton.isEnabled = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.colorCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
            selectColorCell(cell: cell, indexPath: indexPath)
            dataHolder.colorForIndexPath = colorItems[indexPath.row]
            guard let indexPathForColor = indexPathForColor else { return }
            guard let cellForSelectedColor = collectionView.cellForItem(at: indexPathForColor) as? ColorCollectionViewCell else { return }
            if !cellForSelectedColor.isSelected {
                cellForSelectedColor.containerView.layer.borderColor = UIColor.ypWhiteDay.cgColor
                cellForSelectedColor.isSelected = false
            }
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            selectEmojiCell(cell: cell, indexPath: indexPath)
            dataHolder.emojiForIndexPath = emojiItems[indexPath.row]
            guard let indexPathForEmoji = indexPathForEmoji else { return }
            guard let cellForSelectedEmoji = collectionView.cellForItem(at: indexPathForEmoji) as? EmojiCollectionViewCell else { return }
            if !cellForSelectedEmoji.isSelected {
                cellForSelectedEmoji.containerView.backgroundColor = .clear
                cellForSelectedEmoji.isSelected = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.colorCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
            cell.containerView.layer.borderColor = UIColor.ypWhiteDay.cgColor
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell else { return }
            cell.containerView.backgroundColor = .clear
        }
    }
}

extension EditTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colorCollectionView {
            return colorItems.count
        } else {
            return emojiItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCollectionViewCell.identifier,
                for: indexPath
            ) as? ColorCollectionViewCell else { return UICollectionViewCell()}
            cell.colorView.backgroundColor = colorItems[indexPath.row]
            if colorItems[indexPath.row].hexString() == self.tracker?.color.hexString() {
                selectColorCell(cell: cell, indexPath: indexPath)
                cell.isSelected = true
                self.indexPathForColor = indexPath
                dataHolder.colorForIndexPath = colorItems[indexPath.row]
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCollectionViewCell.identifier,
                for: indexPath
            ) as? EmojiCollectionViewCell else { return UICollectionViewCell()}
            cell.emojiView.text = emojiItems[indexPath.row]
            if emojiItems[indexPath.row] == self.tracker?.emoji {
                selectEmojiCell(cell: cell, indexPath: indexPath)
                cell.isSelected = true
                self.indexPathForEmoji = indexPath
                dataHolder.emojiForIndexPath = emojiItems[indexPath.row]
            }
            return cell
        }
    }
}

extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension EditTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
