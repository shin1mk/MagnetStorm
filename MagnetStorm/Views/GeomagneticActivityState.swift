//
//  GeomagneticActivityState.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 09.09.2023.
//

import Foundation

enum GeomagneticActivityState {
    case noStorm
    case minorStorm
    case weakStorm
    case moderateStorm
    case strongStorm
    case severeStorm
    case extremeStorm
    case outstandingStorm
    case exceptionalStorm
    case superstorm
    case unknown
    
    var labelText: String {
        switch self {
        case .noStorm: // 0
            return "G0"
        case .minorStorm: // 1
            return "G1"
        case .weakStorm: // 2
            return "G2"
        case .moderateStorm: // 3
            return "G3"
        case .strongStorm: // 4
            return "G4"
        case .severeStorm: // 5
            return "G5"
        case .extremeStorm: // 6
            return "G6"
        case .outstandingStorm: // 7
            return "G7"
        case .exceptionalStorm: // 8
            return "G8"
        case .superstorm: // 9
            return "G9"
        case .unknown:
            return "?"
        }
    }
    
    var descriptionText: String {
        switch self {
        case .noStorm:
            return "Отсутствие бури:\nВлияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь."
        case .minorStorm:
            return "Слабая буря:\nВлияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство."
        case .weakStorm:
            return "Умеренная буря:\nВлияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне."
        case .moderateStorm:
            return "Сильная буря:\nЭтот уровень бури может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения у чувствительных людей."
        case .strongStorm:
            return "Очень сильная буря:\nЭтот уровень бури может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения особенно у чувствительных людей."
        case .severeStorm:
            return "Сильнейшая буря:\nВлияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей."
        case .extremeStorm:
            return "Буря выдающегося масштаба:\nНа этом уровне симптомы могут стать более выраженными и распространенными. У людей, более чувствительных к магнитным полям, могут возникать более серьезные головные боли, бессонница и изменения настроения."
        case .outstandingStorm:
            return "Буря исключительного масштаба:\nЭтот уровень бури может вызвать значительное ухудшение физического и эмоционального состояния у большого числа людей. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени."
        case .exceptionalStorm:
            return "Сверхбуря:\nНа этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, усиление бессонницы и серьезное изменение эмоционального состояния."
        case .superstorm:
            return "Супербуря:\nСамый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире."
        case .unknown:
            return "Неизвестно"
        }
    }
}
