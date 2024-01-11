//
//  StormDescriptionViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 01.10.2023.
//

import Foundation
import UIKit
import SafariServices
import SnapKit

final class StormDescriptionViewController: UIViewController {
    // Массив с данными о разных уровнях магнитных бурь
    private let stormLevels: [(title: String, description: String, textColor: UIColor)] = [
        ("noStorm_info".localized(), "noStorm_description_info".localized(), StormDescriptionViewController.green0),
        ("minorStorm_info".localized(), "minorStorm_description_info".localized(), StormDescriptionViewController.green1),
        ("weakStorm_info".localized(), "weakStorm_description_info".localized(), StormDescriptionViewController.green2),
        ("moderateStorm_info".localized(), "moderateStorm_description_info".localized(), StormDescriptionViewController.green3),
        ("strongStorm_info".localized(), "strongStorm_description_info".localized(), StormDescriptionViewController.yellow),
        ("severeStorm_info".localized(), "severeStorm_description_info".localized(), StormDescriptionViewController.orange1),
        ("extremeStorm_info".localized(), "extremeStorm_description_info".localized(), StormDescriptionViewController.orange2),
        ("outstandingStorm_info".localized(), "outstandingStorm_description_info".localized(), StormDescriptionViewController.red),
        ("exceptionalStorm_info".localized(), "exceptionalStorm_description_info".localized(), StormDescriptionViewController.deepRed),
        ("superStorm_info".localized(), "superStorm_description_info".localized(), StormDescriptionViewController.veryDeepRed)
    ]
    //MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.register(StormDescriptionTableViewCell.self, forCellReuseIdentifier: "InfoCell")
        return tableView
    }()
    private let subtractImageView = UIImageView(image: UIImage(named: "subtract"))
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
        return view
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    //MARK: Methods
    private func setupConstraints() {
        tableView.backgroundColor = UIColor.black
        // gray background
        view.addSubview(backgroundView)
        backgroundView.layer.zPosition = 100 // z-index
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(50)
        }
        // substract
        backgroundView.addSubview(subtractImageView)
        subtractImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).offset(-24)
        }
        // background color cell
        view.backgroundColor = .black
        // add table view on view
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
} // end
//MARK: TableView
extension StormDescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stormLevels.count
    }
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! StormDescriptionTableViewCell
        let stormLevel = stormLevels[indexPath.row]
        cell.configure(title: stormLevel.title, description: stormLevel.description, textColor: stormLevel.textColor)
        return cell
    }
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
} // end
//MARK: UIColors
extension StormDescriptionViewController {
    static let green0 = UIColor(red: 173/255, green: 255/255, blue: 47/255, alpha: 1.0)
    static let green1 = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)
    static let green2 = UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 1.0)
    static let green3 = UIColor(red: 0/255, green: 150/255, blue: 0/255, alpha: 1.0)
    static let yellow = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
    static let orange1 = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)
    static let orange2 = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
    static let red = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    static let deepRed = UIColor(red: 139/255, green: 0/255, blue: 0/255, alpha: 1.0)
    static let veryDeepRed = UIColor(red: 80/255, green: 0/255, blue: 0/255, alpha: 1.0)
}
