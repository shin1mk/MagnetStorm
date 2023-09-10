//
//  InfoViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 09.09.2023.
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
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupConstraints()
    }

    private func setupBackgroundView() {
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.addSubview(backgroundView)
    }
    // noStorm
    private let noStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Отсутствие бури"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let noStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Влияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // minorStorm
    private let minorStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Слабая буря"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let minorStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Влияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // weakStorm
    private let weakStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Умеренная буря"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let weakStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Влияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // moderateStorm
    private let moderateStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGreen
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Сильная буря"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let moderateStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // strongStorm
    private let strongStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemYellow
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Очень сильная буря"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let strongStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // severeStorm
    private let severeStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemOrange
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Сильнейшая буря"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let severeStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Влияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // extremeStorm
    private let extremeStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemOrange
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Буря выдающегося масштаба"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let extremeStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "На этом уровне симптомы могут стать более выраженными и распространенными. Могут возникать более серьезные головные боли, бессонница и изменения настроения."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // outstandingStorm
    private let outstandingStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemRed
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Буря исключительного масштаба"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let outstandingStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Буря может вызвать значительное ухудшение физического и эмоционального состояния. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // exceptionalStorm
    private let exceptionalStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGray
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Сверхбуря"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let exceptionalStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "На этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, бессонницы и серьезное изменение эмоционального состояния."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    // superStorm
    private let superStormLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemGray3
        titleLabel.font = UIFont.SFUITextBold(ofSize: 24)
        titleLabel.text = "Супербуря"
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    private let superStormDescriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.SFUITextRegular(ofSize: 18) // Установите желаемый шрифт и размер текста
        descriptionLabel.text = "Самый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире."
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private func setupConstraints() {
        // scroll view
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        // noStorm
        contentView.addSubview(noStormLabel)
        noStormLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.horizontalEdges.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
        }
        contentView.addSubview(noStormDescriptionLabel)
        noStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(noStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // minorStorm
        contentView.addSubview(minorStormLabel)
        minorStormLabel.snp.makeConstraints { make in
            make.top.equalTo(noStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.horizontalEdges.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
        }
        contentView.addSubview(minorStormDescriptionLabel)
        minorStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(minorStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // weakStorm
        contentView.addSubview(weakStormLabel)
        weakStormLabel.snp.makeConstraints { make in
            make.top.equalTo(minorStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.horizontalEdges.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
        }
        contentView.addSubview(weakStormDescriptionLabel)
        weakStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(weakStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // moderateStorm
        contentView.addSubview(moderateStormLabel)
        moderateStormLabel.snp.makeConstraints { make in
            make.top.equalTo(weakStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.horizontalEdges.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
        }
        contentView.addSubview(moderateStormDescriptionLabel)
        moderateStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(moderateStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // strongStorm
        contentView.addSubview(strongStormLabel)
        strongStormLabel.snp.makeConstraints { make in
            make.top.equalTo(moderateStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.horizontalEdges.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
        }
        contentView.addSubview(strongStormDescriptionLabel)
        strongStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(strongStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // severeStorm
        contentView.addSubview(severeStormLabel)
        severeStormLabel.snp.makeConstraints { make in
            make.top.equalTo(strongStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.horizontalEdges.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
        }
        contentView.addSubview(severeStormDescriptionLabel)
        severeStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(severeStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // extremeStorm
        contentView.addSubview(extremeStormLabel)
        extremeStormLabel.snp.makeConstraints { make in
            make.top.equalTo(severeStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15)
        }
        contentView.addSubview(extremeStormDescriptionLabel)
        extremeStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(extremeStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // outstandingStorm
        contentView.addSubview(outstandingStormLabel)
        outstandingStormLabel.snp.makeConstraints { make in
            make.top.equalTo(extremeStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15)
        }
        contentView.addSubview(outstandingStormDescriptionLabel)
        outstandingStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(outstandingStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // exceptionalStorm
        contentView.addSubview(exceptionalStormLabel)
        exceptionalStormLabel.snp.makeConstraints { make in
            make.top.equalTo(outstandingStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15)
        }
        contentView.addSubview(exceptionalStormDescriptionLabel)
        exceptionalStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(exceptionalStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
        // superStorm
        contentView.addSubview(superStormLabel)
        superStormLabel.snp.makeConstraints { make in
            make.top.equalTo(exceptionalStormDescriptionLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15)
        }
        contentView.addSubview(superStormDescriptionLabel)
        superStormDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(superStormLabel.snp.bottom).offset(10) // Размещаем описание под заголовком с отступом
            make.leading.equalTo(contentView).offset(15) // Прижимаем к левой стороне с отступом 15
            make.trailing.equalTo(contentView).offset(-15) // Прижимаем к левой стороне с отступом 15
        }
    }
} // end
