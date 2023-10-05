//
//  StormValueManager.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//

import Foundation

func fetchStormValue(completion: @escaping (String?) -> Void) {
    // Задаем URL для запроса данных
    let apiUrl = URL(string: "https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json")!
    // Создаем сессию URLSession для выполнения запроса
    let session = URLSession.shared
    // Создаем задачу dataTask для выполнения запроса с данным URL
    let task = session.dataTask(with: apiUrl) { (data, response, error) in
        // Обработка возможных ошибок
        if let error = error {
            print("Ошибка при выполнении запроса: \(error)")
            return
        }
        // Проверяем, получены ли данные
        guard let data = data else {
            print("Данные не получены.")
            return
        }
        do {
            // Пытаемся разобрать JSON-данные
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String]] {
                // Пропускаем первую строку с заголовками
                let dataRows = Array(jsonArray.dropFirst())
                var geomagneticDataArray: [StormValueData] = []
                // Проходим по каждой строке данных
                for dataRow in dataRows {
                    if dataRow.count == 4 {
                        // Создаем объект StormValueData и добавляем его в массив
                        let geomagneticData = StormValueData(timeTag: dataRow[0], kp: dataRow[1], aRunning: dataRow[2], stationCount: dataRow[3])
                        geomagneticDataArray.append(geomagneticData)
                    }
                }
                // Если есть последние данные, извлекаем значение Kp и округляем его
                if let lastGeomagneticData = geomagneticDataArray.last {
                    if let kpDouble = Double(lastGeomagneticData.kp) {
                        let roundedKp = Int(round(kpDouble))
                        let currentKpValue = "\(roundedKp)"
                        // Вызываем переданное замыкание, передавая значение Kp
                        completion(currentKpValue)
                    }
                }
                // Выводим данные в консоль для отладки
                print(geomagneticDataArray)
            } else {
                print("Данные не соответствуют ожидаемому формату JSON.")
                // Вызываем переданное замыкание с nil, чтобы указать ошибку
                completion(nil)
            }
        } catch {
            print("Ошибка при парсинге JSON: \(error)")
            // Вызываем переданное замыкание с nil, чтобы указать ошибку
            completion(nil)
        }
    }
    task.resume()
}
