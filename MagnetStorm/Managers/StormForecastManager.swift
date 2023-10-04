//
//  StormForecastManager.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.10.2023.
//

//import Foundation
//
//func fetchStormForecast(completion: @escaping (Result<String, Error>) -> Void) {
//    // URL для запроса текстовых данных
//    let url = URL(string: "https://services.swpc.noaa.gov/text/3-day-geomag-forecast.txt")!
//    // Создаем сессию URLSession
//    let session = URLSession.shared
//    // Создаем задачу для выполнения HTTP-запроса
//    let task = session.dataTask(with: url) { (data, response, error) in
//        // Проверяем наличие ошибок
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//        // Проверяем, что мы получили данные
//        guard let data = data else {
//            completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Данные не получены"])))
//            return
//        }
//        // Преобразуем данные в строку
//        if let text = String(data: data, encoding: .utf8) {
//            completion(.success(text))
//        } else {
//            completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать данные в текст"])))
//        }
//    }
//    task.resume()
//}
//
//func parseStormForecastData(text: String) -> [(date: String, values: [Double])] {
//    // Разбиение текста на строки
//    let lines = text.components(separatedBy: .newlines)
//    // Инициализация массива для хранения разобранных данных
//    var parsedData: [(date: String, values: [Double])] = []
//    // Инициализация переменных для отслеживания текущего месяца и временного интервала
//    var currentMonth: String?
//    var currentTimeInterval: String?
//    // Перебор каждой строки
//    for line in lines {
//        // Разбиение строки по пробелам
//        let components = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
//        // Проверка на наличие как минимум двух компонентов (даты и значения)
//        if components.count >= 2 {
//            // Попытка преобразовать второй компонент в Double (значение)
//            if Double(components[1]) != nil {
//                // Проверка, является ли первый компонент месяцем (например, "Янв", "Фев")
//                if components[0].count == 3 {
//                    currentMonth = components[0]
//                } else {
//                    // Если это не месяц, то это временной интервал
//                    currentTimeInterval = components[0]
//                    // Добавление даты в формате "Месяц ВременнойИнтервал" (например, "Окт 00-03UT")
//                    if let month = currentMonth, let time = currentTimeInterval {
//                        let date = "\(month) \(time)"
//                        // Извлечение значений (оставшиеся компоненты)
//                        let values = Array(components[1..<components.count]).compactMap { Double($0) }
//                        // Добавление даты и значений в массив разобранных данных
//                        parsedData.append((date: date, values: values))
//                    }
//                }
//            }
//        }
//    }
//    return parsedData
//}

import Foundation

func fetchStormForecast(completion: @escaping (Result<[StormForecast], Error>) -> Void) {
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
            // Вызываем функцию parseStormForecastData для разбора данных и передаем результат в completion
            let stormForecastData = parseStormForecastData(text: text)
            completion(.success(stormForecastData))
        } else {
            completion(.failure(NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать данные в текст"])))
        }
    }
    task.resume()
}

func parseStormForecastData(text: String) -> [StormForecast] {
    // Разбиение текста на строки
    let lines = text.components(separatedBy: .newlines)
    // Инициализация массива для хранения разобранных данных
    var parsedData: [StormForecast] = []
    // Инициализация переменных для отслеживания текущего месяца и временного интервала
    var currentMonth: String?
    var currentTimeInterval: String?
    // Перебор каждой строки
    for line in lines {
        // Разбиение строки по пробелам
        let components = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        // Проверка на наличие как минимум двух компонентов (даты и значения)
        if components.count >= 2 {
            // Попытка преобразовать второй компонент в Double (значение)
            if Double(components[1]) != nil {
                // Проверка, является ли первый компонент месяцем (например, "Янв", "Фев")
                if components[0].count == 3 {
                    currentMonth = components[0]
                } else {
                    // Если это не месяц, то это временной интервал
                    currentTimeInterval = components[0]
                    // Добавление даты в формате "Месяц ВременнойИнтервал" (например, "Окт 00-03UT")
                    if let month = currentMonth, let time = currentTimeInterval {
                        let date = "\(month) \(time)"
                        // Извлечение значений (оставшиеся компоненты)
                        let values = Array(components[1..<components.count]).compactMap { Double($0) }
                        // Создание экземпляра структуры StormForecast и добавление его в массив разобранных данных
                        let stormForecast = StormForecast(date: date, values: values)
                        parsedData.append(stormForecast)
                    }
                }
            }
        }
    }
    return parsedData
}
