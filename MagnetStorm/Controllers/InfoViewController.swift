//
//  InfoViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 09.09.2023.
//

import Foundation
import UIKit
import SnapKit
import SafariServices

final class InfoViewController: UIViewController {
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        return view
    }()
    private let contentView = UIView()
    private let subtractImageView = UIImageView(image: UIImage(named: "subtract"))
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.6)
        return view
    }()
    // массив с данными о разных уровнях магнитных бурь
//    private let stormLevels: [(String, String, UIColor)] = [
//        ("Отсутствие бури", "Влияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь.", InfoViewController.green0),
//        ("Слабая буря", "Влияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство.", InfoViewController.green1),
//        ("Умеренная буря", "Влияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне.", InfoViewController.green2),
//        ("Сильная буря", "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения.", InfoViewController.green3),
//        ("Очень сильная буря", "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения.", InfoViewController.yellow),
//        ("Сильнейшая буря", "Влияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей.", InfoViewController.orange1),
//        ("Буря выдающегося масштаба", "На этом уровне симптомы могут стать более выраженными и распространенными. Могут возникать более серьезные головные боли, бессонница и изменения настроения.", InfoViewController.orange2),
//        ("Буря исключительного масштаба", "Буря может вызвать значительное ухудшение физического и эмоционального состояния. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени.", InfoViewController.red),
//        ("Сверхбуря", "На этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, бессонницы и серьезное изменение эмоционального состояния.", InfoViewController.deepRed),
//        ("Супербуря", "Самый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире.", InfoViewController.veryDeepRed)
//    ]
    private let stormLevels: [(String, String, UIColor)] = [
        ("noStorm_info".localized(), "noStorm_description_info".localized(), InfoViewController.green0),
        ("minorStorm_info".localized(), "minorStorm_description_info".localized(), InfoViewController.green1),
        ("weakStorm_info".localized(), "weakStorm_description_info".localized(), InfoViewController.green2),
        ("moderateStorm_info".localized(), "moderateStorm_description_info".localized(), InfoViewController.green3),
        ("strongStorm_info".localized(), "strongStorm_description_info".localized(), InfoViewController.yellow),
        ("severeStorm_info".localized(), "severeStorm_description_info".localized(), InfoViewController.orange1),
        ("extremeStorm_info".localized(), "extremeStorm_description_info".localized(), InfoViewController.orange2),
        ("outstandingStorm_info".localized(), "outstandingStorm_description_info".localized(), InfoViewController.red),
        ("exceptionalStorm_info".localized(), "exceptionalStorm_description_info".localized(), InfoViewController.deepRed),
        ("superStorm_info".localized(), "superStorm_description_info".localized(), InfoViewController.veryDeepRed)
    ]

    private let sourceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Источник данных: NOAA Space Weather Prediction Center", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 12)
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupConstraints()
        sourceTarget()
    }
    //        private func setupBackgroundView() {
    //            let backgroundView = UIView(frame: view.bounds)
    //            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    //            view.addSubview(backgroundView)
    //        }
    private func sourceTarget() {
        sourceButton.addTarget(self, action: #selector(openNOAALink), for: .touchUpInside)
    }
    //MARK: Methods
    private func setupBackgroundView() {
        let backgroundImage = UIImageView(image: UIImage(named: "infoViewBackground"))
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
    }
    // функция для создания меток и описаний
    private func createStormLevelView(title: String, description: String, textColor: UIColor) -> (UILabel, UILabel) {
        let titleLabel = UILabel()
        titleLabel.textColor = textColor
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextMedium(ofSize: 18)
        descriptionLabel.text = description
        descriptionLabel.numberOfLines = 0
        
        return (titleLabel, descriptionLabel)
    }
    // Constraints
    private func setupConstraints() {
        // gray background
        view.addSubview(backgroundView)
        backgroundView.layer.zPosition = 100
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(50)
        }
        // scroll view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        // content view
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.height.equalTo(1700)
        }
        // substract
        backgroundView.addSubview(subtractImageView)
        subtractImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).offset(-24)
        }
        // titles and descriptions
        var previousDescriptionLabel: UILabel? = nil // Изначально предыдущей метки для описания нет, устанавливаем её в nil
        for (title, description, textColor) in stormLevels {
            let (titleLabel, descriptionLabel) = createStormLevelView(title: title, description: description, textColor: textColor)
            // titleLabel
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(previousDescriptionLabel?.snp.bottom ?? contentView.snp.top).offset(10)
                make.leading.equalTo(contentView).offset(15)
                make.trailing.equalTo(contentView).offset(-15)
            }
            // descriptionLabel
            contentView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalTo(contentView).offset(15)
                make.trailing.equalTo(contentView).offset(-15)
            }
            previousDescriptionLabel = descriptionLabel
        }
        // sourceButton
        contentView.addSubview(sourceButton)
        sourceButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }
    // source button link
    @objc func openNOAALink() {
        print("Button tapped")
        if let url = URL(string: "https://www.swpc.noaa.gov/") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
} // end
//MARK: Colors
extension InfoViewController {
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
