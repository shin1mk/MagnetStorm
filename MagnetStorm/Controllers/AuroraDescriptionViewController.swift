//
//  AuroraDescriptionViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 13.10.2023.
//

import Foundation
import UIKit
import SafariServices
import SnapKit

final class AuroraDescriptionViewController: UIViewController {
    private let stormLevels: [(title: String, description: String, textColor: UIColor)] = [
        ("geomagneticTitle".localized(), "geomagneticDescription_text".localized(), .systemBlue),
        ("locationTitle".localized(), "locationDescription_text".localized(), .systemBlue),
         ("mustBeDarkTitle".localized(), "mustBeDarkDescription_text".localized(), .systemBlue),
         ("timeTitle".localized(), "timeDescription_text".localized(), .systemBlue)
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
extension AuroraDescriptionViewController: UITableViewDataSource, UITableViewDelegate {
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
