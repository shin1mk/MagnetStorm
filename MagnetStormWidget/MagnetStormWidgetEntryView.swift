//
//  MagnetStormWidgetEntryView.swift
//  MagnetStormWidgetExtension
//
//  Created by SHIN MIKHAIL on 23.01.2024.
//

import SwiftUI

struct MagnetStormWidgetEntryView: View {
    var entry: MagnetStormWidgetEntry
    
    var body: some View {
        VStack {
            Text(currentDayOfWeek())
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.orange)
                .padding(.top, 15)

            Text("K-index")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.gray)

            Text(entry.kpValue)
                .font(.system(size: 110, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .widgetBackground(backgroundView: Color(.sRGB, red: 28/255, green: 28/255, blue: 30/255).opacity(0.9))
                .padding(.top, -30) // Уменьшаем отступ снизу
        }
        .padding()
    }
    
    func currentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Формат для полного дня недели
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: Date())
    }
}
