//
//  Fetch3DayGeomagneticForecast.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.10.2023.
//

import Foundation

func fetch3DayGeomagneticForecast(completion: @escaping (Result<String, Error>) -> Void) {
    // URL для запроса текстовых данных
    let url = URL(string: "https://services.swpc.noaa.gov/text/3-day-geomag-forecast.txt")!

    // Создаем сессию URLSession
    let session = URLSession.shared

    // Создаем задачу для выполнения HTTP-запроса
    let task = session.dataTask(with: url) { (data, response, error) in
        // Проверяем наличие ошибок
        if let error = error {
            completion(.failure(error))
            return
        }

        // Проверяем, что мы получили данные
        guard let data = data else {
            completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Данные не получены"])))
            return
        }

        // Преобразуем данные в строку
        if let text = String(data: data, encoding: .utf8) {
            completion(.success(text))
        } else {
            completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать данные в текст"])))
        }
    }

    // Запускаем задачу
    task.resume()
}


//func parseGeomagneticForecastData(text: String) -> [(date: String, values: [Double])] {
//    // Split the text by lines
//    let lines = text.components(separatedBy: .newlines)
//
//    // Initialize an array to store the parsed data
//    var parsedData: [(date: String, values: [Double])] = []
//
//    // Loop through each line
//    for line in lines {
//        // Split the line by spaces
//        let components = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
//
//        // Check if there are at least two components (date and value)
//        if components.count >= 2, let date = components.first, let value = Double(components[1]) {
//            // Extract the date (the first component)
//            let date = date
//
//            // Extract the values (remaining components)
//            let values = Array(components[1..<components.count]).compactMap { Double($0) }
//
//            // Append the date and values to the parsed data array
//            parsedData.append((date: date, values: values))
//        }
//    }
//
//    return parsedData
//}

func parseGeomagneticForecastData(text: String) -> [(date: String, values: [Double])] {
    // Split the text by lines
    let lines = text.components(separatedBy: .newlines)
    
    // Initialize an array to store the parsed data
    var parsedData: [(date: String, values: [Double])] = []
    
    // Initialize variables to keep track of the current month and time interval
    var currentMonth: String?
    var currentTimeInterval: String?
    
    // Loop through each line
    for line in lines {
        // Split the line by spaces
        let components = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        
        // Check if there are at least two components (date and value)
        if components.count >= 2 {
            // Try to convert the second component to a Double (value)
            if Double(components[1]) != nil {
                // Check if the first component is a month (e.g., "Jan", "Feb")
                if components[0].count == 3 {
                    currentMonth = components[0]
                } else {
                    // If it's not a month, it's a time interval
                    currentTimeInterval = components[0]
                    
                    // Append the date in the format "Month Time" (e.g., "Oct 00-03UT")
                    if let month = currentMonth, let time = currentTimeInterval {
                        let date = "\(month) \(time)"
                        
                        // Extract the values (remaining components)
                        let values = Array(components[1..<components.count]).compactMap { Double($0) }
                        
                        // Append the date and values to the parsed data array
                        parsedData.append((date: date, values: values))
                    }
                }
            }
        }
    }
    
    return parsedData
}
