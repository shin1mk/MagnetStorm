//
//  AboutViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 11.01.2024.
//

import UIKit
import SnapKit
import SafariServices

final class AboutViewController: UIViewController {
    //MARK: Properties
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.3)
        return view
    }()
    private let textLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "что делает приложение"
        locationLabel.font = UIFont.SFUITextRegular(ofSize: 18)
        locationLabel.textColor = .white
        return locationLabel
    }()
    private let source1Label: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "kp source"
        locationLabel.font = UIFont.SFUITextRegular(ofSize: 18)
        locationLabel.textColor = .white
        return locationLabel
    }()
    private let source1Button: UIButton = {
        let button = UIButton()
        button.setTitle("NOAA Space Weather Prediction Center", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.SFUITextRegular(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()   
    private let source2Label: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "aurora source"
        locationLabel.font = UIFont.SFUITextRegular(ofSize: 18)
        locationLabel.textColor = .white
        return locationLabel
    }()
    private let source2Button: UIButton = {
        let button = UIButton()
        button.setTitle("NOAA Space Weather Prediction Center", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.SFUITextRegular(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("share", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    private let rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("rate", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("\(NSLocalizedString("support_text", comment: ""))", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    private let letterButton: UIButton = {
        let button = UIButton()
        button.setTitle("\(NSLocalizedString("letter_text", comment: ""))", for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        addTarget()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .black

        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(source1Label)
        source1Label.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(source1Button)
        source1Button.snp.makeConstraints { make in
            make.top.equalTo(source1Label.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(source2Label)
        source2Label.snp.makeConstraints { make in
            make.top.equalTo(source1Button.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(source2Button)
        source2Button.snp.makeConstraints { make in
            make.top.equalTo(source2Label.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(source2Button.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(rateButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        view.addSubview(letterButton)
        letterButton.snp.makeConstraints { make in
            make.top.equalTo(buyButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        // tab bar background
        view.addSubview(bottomMarginView)
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-0)
        }
    }

    private func addTarget() {
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
    }
    
    @objc private func openNOAALink() {
        if let url = URL(string: "https://www.swpc.noaa.gov/products/3-day-forecast") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func buyButtonTapped() {
        if let url = URL(string: "https://www.buymeacoffee.com/shininswift") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func letterButtonTapped() {
        let recipient = "shininswift@gmail.com"
        let subject = "NemaOkupantiv🇺🇦Співпраця/побажання."
        
        let urlString = "mailto:\(recipient)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: urlString ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
