//
//  AuroraNowcastManager.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 11.10.2023.
//

import Foundation

func auroraNowcastValue(completion: @escaping (Result<String, Error>) -> Void) {
    if let url = URL(string: "https://services.swpc.noaa.gov/text/aurora-nowcast-hemi-power.txt") {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка при выполнении запроса: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let data = data, let text = String(data: data, encoding: .utf8) {
                // Выводим содержимое текста ответа
                print(text)
                // Ищем значение North-Hemispheric-Power-Index с помощью функции extractNorthPowerIndex
                if let northPowerIndex = extractNorthPowerIndex(from: text) {
                    // Выводим найденное значение
                    print("Последнее значение North-Hemispheric-Power-Index: \(northPowerIndex)")
                    // Передаем результат успешного выполнения через обработчик
                    completion(.success(northPowerIndex))
                } else {
                    print("Не удалось извлечь значение North-Hemispheric-Power-Index.")
                }
            } else {
                print("Не удалось прочитать данные.")
            }
        }
        task.resume()
    } else {
        print("Неверный URL.")
    }
}

func extractNorthPowerIndex(from text: String) -> String? {
    if let regex = try? NSRegularExpression(pattern: "\\d+", options: []) {
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        if let lastMatch = matches.last {
            return (text as NSString).substring(with: lastMatch.range)
        }
    }
    return nil
}
