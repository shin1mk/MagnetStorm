//
//  MagnetStormWidget.swift
//  MagnetStormWidget
//
//  Created by SHIN MIKHAIL on 22.01.2024.
//

import WidgetKit
import SwiftUI
import Foundation

struct MagnetStormWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MagnetStormWidget", provider: Provider()) { entry in
            MagnetStormWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Magnet Storm Widget")
        .description("Widget to display current Kp value.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}
// MARK: - Widget Preview
struct MagnetStormWidget_Previews: PreviewProvider {
    static var previews: some View {
        MagnetStormWidgetEntryView(entry: MagnetStormWidgetEntry(date: Date(), kpValue: "5"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
