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
                .background(Color.black) // Установка черного цвета как фона для виджета
        }
        .configurationDisplayName("Magnet Storm Widget")
        .description("Widget to display current Kp value.")
        .supportedFamilies([.systemSmall])
    }
}



// MARK: - Widget Preview
struct MagnetStormWidget_Previews: PreviewProvider {
    static var previews: some View {
        MagnetStormWidgetEntryView(entry: MagnetStormWidgetEntry(date: Date(), kpValue: "5"))
            .previewContext(WidgetPreviewContext(family: .systemSmall)) // Предварительный просмотр для виджета малого размера
    }
}
// MARK: - Timeline Entry
struct MagnetStormWidgetEntry: TimelineEntry {
    var date: Date
    var kpValue: String // Значение Kp для отображения в виджете
}
// MARK: - Widget Entry View
struct MagnetStormWidgetEntryView: View {
    var entry: MagnetStormWidgetEntry
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(entry.kpValue)
                    .font(.custom("SFUITextMedium", size: 90))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
        }
    }
}
// MARK: - Timeline Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MagnetStormWidgetEntry {
        let placeholderEntry = MagnetStormWidgetEntry(date: Date(), kpValue: "Placeholder") // Значение Kp для заполнителя
        return placeholderEntry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MagnetStormWidgetEntry) -> Void) {
        let snapshotEntry = MagnetStormWidgetEntry(date: Date(), kpValue: "Snapshot") // Значение Kp для снимка (во время разработки)
        completion(snapshotEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MagnetStormWidgetEntry>) -> Void) {
        // Вызываем функцию fetchStormValue(completion:) для получения реальных данных
        fetchStormValue { currentKpValue in
            // Используем полученное значение Kp для создания entry
            let entry = MagnetStormWidgetEntry(date: Date(), kpValue: currentKpValue ?? "N/A")
            // Создаем Timeline с полученным entry
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}
