//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private let statistic = Statistic.statistic
    private var trackerRecords = TrackerRecordStore().loadTrackerRecords()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.textColor = .ypBlackDay
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()
        tableView.register(StatisticTableViewcell.self, forCellReuseIdentifier: StatisticTableViewcell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var nilStatisticImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "nilStatistic")
        imageView.image = image
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var nilStatisticLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.text = "Анализировать пока нечего"
        label.isHidden = true
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLineGrey
        return view
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        setupViews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let trackerRecords = trackerRecords else {
            tableView.isHidden = true
            nilStatisticImage.isHidden = false
            nilStatisticLabel.isHidden = false
            return
        }
        if trackerRecords.isEmpty {
            tableView.isHidden = true
            nilStatisticImage.isHidden = false
            nilStatisticLabel.isHidden = false
        } else {
            tableView.isHidden = false
            nilStatisticImage.isHidden = true
            nilStatisticLabel.isHidden = true
        }
    }
    
    
    func setupViews() {
        [lineView,
         tableView,
         titleLabel,
         nilStatisticImage,
         nilStatisticLabel].forEach({ [weak self] in
            guard let self = self else { return }
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })
        
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 71),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            nilStatisticImage.widthAnchor.constraint(equalToConstant: 80),
            nilStatisticImage.heightAnchor.constraint(equalToConstant: 80),
            nilStatisticImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilStatisticImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -273),
            
            nilStatisticLabel.widthAnchor.constraint(equalToConstant: 343),
            nilStatisticLabel.heightAnchor.constraint(equalToConstant: 18),
            nilStatisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nilStatisticLabel.topAnchor.constraint(equalTo: nilStatisticImage.bottomAnchor, constant: 8),
        ])
    }
    
    private func makeAvarageValue() -> Int {
        guard let trackerRecords = trackerRecords else { return 0 }
        if trackerRecords.isEmpty {
            return 0
        }
        let sortTrackerRecords = trackerRecords.sorted{ obj1, obj2 in
            obj1.date < obj2.date
        }
        var lastDate = sortTrackerRecords[0].date
        var counterTrackers = 0
        var counterDates = 1
        for trackerRecord in sortTrackerRecords {
            if lastDate == trackerRecord.date {
                counterTrackers += 1
            } else {
                lastDate = trackerRecord.date
                counterDates += 1
                counterTrackers += 1
            }
        }
        return Int(counterTrackers/counterDates)
    }
    
    private func makeBestPeriod() -> Int {
        guard let trackerRecords = trackerRecords else { return 0 }
        let sortTrackerRecords = trackerRecords.sorted{ obj1, obj2 in
            obj1.id == obj2.id
        }
        if trackerRecords.isEmpty {
            return 0
        }
        print(sortTrackerRecords)
        var lastDate = sortTrackerRecords[0].date
        var counterTrackers = 0
        var counterDates = 1
        for trackerRecord in sortTrackerRecords {
            if lastDate == trackerRecord.date {
                counterTrackers += 1
            } else {
                lastDate = trackerRecord.date
                counterDates += 1
                counterTrackers += 1
            }
        }
        return Int(counterTrackers/counterDates)
    }
}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statistic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticTableViewcell.reuseIdentifier, for: indexPath) as? StatisticTableViewcell else { return UITableViewCell()}
        cell.statisticTitle.text = statistic[indexPath.row]
        let trackerRecords = trackerRecords ?? []
        if indexPath.row == 0 {
            // TODO: do filter
            cell.statisticCounter.text = "\(Int(trackerRecords.count/3))"
        }
        if indexPath.row  == 1 {
            // TODO: do filter
            cell.statisticCounter.text = "\(Int(trackerRecords.count/2))"
        }
        if indexPath.row  == 2 {
            cell.statisticCounter.text = "\(trackerRecords.count)"
        }
        if indexPath.row  == 3 {
            let avarageValue = makeAvarageValue()
            cell.statisticCounter.text = "\(avarageValue)"
        }
        return cell
    }
}

extension StatisticsViewController: TrackersViewDelegate {
    func uploadStatistic() {
        self.trackerRecords = TrackerRecordStore().loadTrackerRecords()
        tableView.reloadData()
    }
}


