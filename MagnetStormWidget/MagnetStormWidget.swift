//
//  MagnetStormWidget.swift
//  MagnetStormWidget
//
//  Created by SHIN MIKHAIL on 22.01.2024.
//

import WidgetKit
import SwiftUI
import Foundation
// MARK: - Timeline Entry
struct MagnetStormWidgetEntry: TimelineEntry {
    var date: Date
    var kpValue: String // Значение Kp
}

struct MagnetStormWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MagnetStormWidget", provider: Provider()) { entry in
            MagnetStormWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Magnet Storm Widget")
        .description("Widget to display current Kp value.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled() // Применяем исправление для дополнительного отступа
    }
}

// MARK: - Widget Preview
struct MagnetStormWidget_Previews: PreviewProvider {
    static var previews: some View {
        MagnetStormWidgetEntryView(entry: MagnetStormWidgetEntry(date: Date(), kpValue: "5"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
// MARK: - Widget Entry View


struct MagnetStormWidgetEntryView: View {
    var entry: MagnetStormWidgetEntry
    
    var body: some View {
        VStack {
            Text("")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Text(entry.kpValue)
                .font(.custom("SFUITextBold", size: 150))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .widgetBackground(backgroundView: Color.clear) // Применяем исправление
        }
        .padding()
    }
}

// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MagnetStormWidgetEntry {
        let placeholderEntry = MagnetStormWidgetEntry(date: Date(), kpValue: "Placeholder")
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MagnetStormWidgetEntry) -> Void) {
        let snapshotEntry = MagnetStormWidgetEntry(date: Date(), kpValue: "Snapshot")
        completion(snapshotEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MagnetStormWidgetEntry>) -> Void) {
        fetchStormValue { currentKpValue in
            let entry = MagnetStormWidgetEntry(date: Date(), kpValue: currentKpValue ?? "N/A")

            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}


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
