//
//  Provider.swift
//  MagnetStormWidgetExtension
//
//  Created by SHIN MIKHAIL on 23.01.2024.
//

import WidgetKit

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
