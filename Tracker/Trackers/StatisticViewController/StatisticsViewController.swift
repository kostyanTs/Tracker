//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Konstantin on 03.07.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    let lineView = UIView()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addViews()
    }
    
    func addViews() {
        addLineView(lineView: lineView)
    }
    
    private func addLineView(lineView: UIView) {
        lineView.backgroundColor = .ypGrey
        lineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
