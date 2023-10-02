//
//  Fetch3DayModels.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.10.2023.
//

import Foundation

struct GeomagneticForecast {
    let date: String
    let timeRange: String
    let value: Double
}

struct GeomagneticActivityData {
    let date: Date // Дата
    let timeIntervals: [String: Double] // Временные интервалы и их значения
}
