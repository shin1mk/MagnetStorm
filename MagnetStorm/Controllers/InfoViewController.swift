////
////  InfoViewController.swift
////  MagnetStorm
////
////  Created by SHIN MIKHAIL on 09.09.2023.
////
//
//import Foundation
//import UIKit
//import SnapKit
//
//final class InfoViewController: UIViewController {
//    private let scrollView: UIScrollView = {
//        var view = UIScrollView()
//        view.isScrollEnabled = true
//        view.alwaysBounceVertical = true
//        return view
//    }()
//    private let contentView = UIView()
//    //MARK: Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupBackgroundView()
//        setupConstraints()
//    }
////    private func setupBackgroundView() {
////        let backgroundView = UIView(frame: view.bounds)
////        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
////        view.addSubview(backgroundView)
////    }
//    private func setupBackgroundView() {
//        let backgroundImage = UIImageView(image: UIImage(named: "infoViewBackground"))
//        backgroundImage.frame = view.bounds
//        backgroundImage.contentMode = .scaleAspectFill // Установите режим масштабирования, который вам нравится
//        view.addSubview(backgroundImage)
//    }
//    // noStorm
//    private let noStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .green0
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Отсутствие бури"
//        return titleLabel
//    }()
//    private let noStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Влияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // minorStorm
//    private let minorStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .green1
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Слабая буря"
//        return titleLabel
//    }()
//    private let minorStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Влияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // weakStorm
//    private let weakStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .green2
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Умеренная буря"
//        return titleLabel
//    }()
//    private let weakStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Влияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // moderateStorm
//    private let moderateStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .green3
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Сильная буря"
//        return titleLabel
//    }()
//    private let moderateStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // strongStorm
//    private let strongStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .systemYellow
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Очень сильная буря"
//        titleLabel.numberOfLines = 0
//        return titleLabel
//    }()
//    private let strongStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // severeStorm
//    private let severeStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .orange1
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Сильнейшая буря"
//        titleLabel.numberOfLines = 0
//        return titleLabel
//    }()
//    private let severeStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Влияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // extremeStorm
//    private let extremeStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .orange2
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Буря выдающегося масштаба"
//        titleLabel.numberOfLines = 0
//        return titleLabel
//    }()
//    private let extremeStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "На этом уровне симптомы могут стать более выраженными и распространенными. Могут возникать более серьезные головные боли, бессонница и изменения настроения."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // outstandingStorm
//    private let outstandingStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .systemRed
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Буря исключительного масштаба"
//        titleLabel.numberOfLines = 0
//        return titleLabel
//    }()
//    private let outstandingStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Буря может вызвать значительное ухудшение физического и эмоционального состояния. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // exceptionalStorm
//    private let exceptionalStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .deepRed
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Сверхбуря"
//        return titleLabel
//    }()
//    private let exceptionalStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "На этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, бессонницы и серьезное изменение эмоционального состояния."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    // superStorm
//    private let superStormLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.textColor = .veryDeepRed
//        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
//        titleLabel.text = "Супербуря"
//        return titleLabel
//    }()
//    private let superStormDescriptionLabel: UILabel = {
//        let descriptionLabel = UILabel()
//        descriptionLabel.textColor = .white
//        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18)
//        descriptionLabel.text = "Самый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире."
//        descriptionLabel.numberOfLines = 0
//        return descriptionLabel
//    }()
//    //MARK: Constraints
//    private func setupConstraints() {
//        // scroll view
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        // content view
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.centerX.equalTo(scrollView)
//            make.top.bottom.equalTo(scrollView)
//            make.width.equalTo(scrollView)
//            make.bottom.equalTo(scrollView)
//            make.height.equalTo(1700)
//        }
//        // noStorm
//        contentView.addSubview(noStormLabel)
//        noStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(contentView).offset(20)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(noStormDescriptionLabel)
//        noStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(noStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // minorStorm
//        contentView.addSubview(minorStormLabel)
//        minorStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(noStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(minorStormDescriptionLabel)
//        minorStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(minorStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // weakStorm
//        contentView.addSubview(weakStormLabel)
//        weakStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(minorStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(weakStormDescriptionLabel)
//        weakStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(weakStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // moderateStorm
//        contentView.addSubview(moderateStormLabel)
//        moderateStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(weakStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(moderateStormDescriptionLabel)
//        moderateStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(moderateStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // strongStorm
//        contentView.addSubview(strongStormLabel)
//        strongStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(moderateStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(strongStormDescriptionLabel)
//        strongStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(strongStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // severeStorm
//        contentView.addSubview(severeStormLabel)
//        severeStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(strongStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(severeStormDescriptionLabel)
//        severeStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(severeStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // extremeStorm
//        contentView.addSubview(extremeStormLabel)
//        extremeStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(severeStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(extremeStormDescriptionLabel)
//        extremeStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(extremeStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // outstandingStorm
//        contentView.addSubview(outstandingStormLabel)
//        outstandingStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(extremeStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(outstandingStormDescriptionLabel)
//        outstandingStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(outstandingStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // exceptionalStorm
//        contentView.addSubview(exceptionalStormLabel)
//        exceptionalStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(outstandingStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(exceptionalStormDescriptionLabel)
//        exceptionalStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(exceptionalStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        // superStorm
//        contentView.addSubview(superStormLabel)
//        superStormLabel.snp.makeConstraints { make in
//            make.top.equalTo(exceptionalStormDescriptionLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//        contentView.addSubview(superStormDescriptionLabel)
//        superStormDescriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(superStormLabel.snp.bottom).offset(10)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//        }
//    }
//} // end
//

import Foundation
import UIKit
import SnapKit

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
    lazy var stormLevels: [(String, String, UIColor)] = [
        ("Отсутствие бури", "Влияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь.", InfoViewController.green0),
        ("Слабая буря", "Влияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство.", InfoViewController.green1),
        ("Умеренная буря", "Влияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне.", InfoViewController.green2),
        ("Сильная буря", "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения.", InfoViewController.green3),
        ("Очень сильная буря", "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения.", InfoViewController.yellow),
        ("Сильнейшая буря", "Влияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей.", InfoViewController.orange1),
        ("Буря выдающегося масштаба", "На этом уровне симптомы могут стать более выраженными и распространенными. Могут возникать более серьезные головные боли, бессонница и изменения настроения.", InfoViewController.orange2),
        ("Буря исключительного масштаба", "Буря может вызвать значительное ухудшение физического и эмоционального состояния. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени.", InfoViewController.red),
        ("Сверхбуря", "На этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, бессонницы и серьезное изменение эмоционального состояния.", InfoViewController.deepRed),
        ("Супербуря", "Самый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире.", InfoViewController.veryDeepRed)
    ]
    private lazy var sourceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Источник данных: NOAA Space Weather Prediction Center", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 14)
        button.addTarget(self, action: #selector(openNOAALink), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupConstraints()
    }
    //    private func setupBackgroundView() {
    //        let backgroundView = UIView(frame: view.bounds)
    //        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    //        view.addSubview(backgroundView)
    //    }
    //MARK: Methods
    private func setupBackgroundView() {
        let backgroundImage = UIImageView(image: UIImage(named: "infoViewBackground"))
        backgroundImage.frame = view.bounds
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
    }
    //  функция для создания меток и описаний
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
    //MARK: Constraints
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
            make.top.equalTo(backgroundView.snp.bottom) // Положение scrollView начинается после backgroundView
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
        // titles and descriptions
        for (title, description, textColor) in stormLevels {
            let (titleLabel, descriptionLabel) = createStormLevelView(title: title, description: description, textColor: textColor)
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(descriptionLabel)
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(previousDescriptionLabel?.snp.bottom ?? contentView.snp.top).offset(10)
                make.leading.equalTo(contentView).offset(15)
                make.trailing.equalTo(contentView).offset(-15)
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.leading.equalTo(contentView).offset(15)
                make.trailing.equalTo(contentView).offset(-15)
            }
            
            previousDescriptionLabel = descriptionLabel
        }

        // sourceButton
//        contentView.addSubview(sourceButton)
//        sourceButton.snp.makeConstraints { make in
//            make.top.equalTo(previousDescriptionLabel?.snp.bottom ?? contentView.snp.top).offset(20)
//            make.leading.equalTo(contentView).offset(15)
//            make.trailing.equalTo(contentView).offset(-15)
//            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-20)
//        }
    }
    
    @objc func openNOAALink() {
        print("Button tapped")
        if let url = URL(string: "https://www.swpc.noaa.gov/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
