//
//  MainController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//

import UIKit
import SnapKit

final class MainController: UIViewController {
    private let conditionLabel: UILabel = {
        let conditionLabel = UILabel()
        conditionLabel.text = "-"
        conditionLabel.font = UIFont.systemFont(ofSize: 200)
        conditionLabel.textColor = .systemGreen
        conditionLabel.textAlignment = .center
        return conditionLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        fetchMagneticData { [weak self] currentKpValue in
            // Обновите UI на главном потоке с полученным значением Kp
            DispatchQueue.main.async {
                self?.conditionLabel.text = currentKpValue ?? "N/A"
            }
        }
    }

    private func setupConstraints() {
        view.addSubview(conditionLabel)
        conditionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

