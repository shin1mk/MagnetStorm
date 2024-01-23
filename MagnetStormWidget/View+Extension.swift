//
//  View+Extension.swift
//  MagnetStormWidgetExtension
//
//  Created by SHIN MIKHAIL on 23.01.2024.
//

import SwiftUI

extension View {
    func widgetBackground(backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
