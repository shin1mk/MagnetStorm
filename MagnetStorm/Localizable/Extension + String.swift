//
//  Extension + String.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 14.09.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
