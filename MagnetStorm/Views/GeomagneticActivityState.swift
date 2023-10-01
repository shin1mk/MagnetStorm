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
    case superStorm
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
        case .superStorm: // 9
            return "G9"
        case .unknown:
            return "?"
        }
    }
    
    var descriptionText: String {
        switch self {
        case .noStorm:
            return "noStorm_description".localized()
        case .minorStorm:
            return "minorStorm_description".localized()
        case .weakStorm:
            return "weakStorm_description".localized()
        case .moderateStorm:
            return "moderateStorm_description".localized()
        case .strongStorm:
            return "strongStorm_description".localized()
        case .severeStorm:
            return "severeStorm_description".localized()
        case .extremeStorm:
            return "extremeStorm_description".localized()
        case .outstandingStorm:
            return "outstandingStorm_description".localized()
        case .exceptionalStorm:
            return "exceptionalStorm_description".localized()
        case .superStorm:
            return "superStorm_description".localized()
        case .unknown:
            return "unknown_description".localized()
        }
    }
}
