////
////  MagneticManager.swift
////  MagnetStorm
////
////  Created by SHIN MIKHAIL on 02.09.2023.
////
//
//import Foundation
//
//func fetchPlanetaryKIndexData() {
//    let apiUrl = URL(string: "https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json")!
//    let session = URLSession.shared
//
//    let task = session.dataTask(with: apiUrl) { (data, response, error) in
//        if let error = error {
//            print("Ошибка при выполнении запроса: \(error)")
//            return
//        }
//
//        guard let data = data else {
//            print("Данные не получены.")
//            return
//        }
//
//        do {
//            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String]] {
//                // Пропускаем первую строку с заголовками
//                let dataRows = Array(jsonArray.dropFirst())
//
//                var geomagneticDataArray: [GeomagneticData] = []
//
//                for dataRow in dataRows {
//                    if dataRow.count == 4 {
//                        let geomagneticData = GeomagneticData(timeTag: dataRow[0], kp: dataRow[1], aRunning: dataRow[2], stationCount: dataRow[3])
//                        geomagneticDataArray.append(geomagneticData)
//                    }
//                }
//
//                // Вы можете использовать geomagneticDataArray для дальнейшей обработки или вывода данных
//                print(geomagneticDataArray)
//            } else {
//                print("Данные не соответствуют ожидаемому формату JSON.")
//            }
//        } catch {
//            print("Ошибка при парсинге JSON: \(error)")
//        }
//    }
//
//
//    task.resume()
//}

//
//  MagneticManager.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//
import Foundation

func fetchMagneticData(completion: @escaping (String?) -> Void) {
    let apiUrl = URL(string: "https://services.swpc.noaa.gov/products/noaa-planetary-k-index.json")!
    let session = URLSession.shared
    
    let task = session.dataTask(with: apiUrl) { (data, response, error) in
        if let error = error {
            print("Ошибка при выполнении запроса: \(error)")
            return
        }
        
        guard let data = data else {
            print("Данные не получены.")
            return
        }
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String]] {
                // Пропускаем первую строку с заголовками
                let dataRows = Array(jsonArray.dropFirst())
                var geomagneticDataArray: [GeomagneticData] = []
                
                for dataRow in dataRows {
                    if dataRow.count == 4 {
                        let geomagneticData = GeomagneticData(timeTag: dataRow[0], kp: dataRow[1], aRunning: dataRow[2], stationCount: dataRow[3])
                        geomagneticDataArray.append(geomagneticData)
                    }
                }
                if let firstGeomagneticData = geomagneticDataArray.first {
                    // Предположим, что вы хотите использовать значение Kp из первой записи
                    if let kpDouble = Double(firstGeomagneticData.kp) {
                        let roundedKp = Int(round(kpDouble))
                        let currentKpValue = "\(roundedKp)"
                        // Вызываем замыкание с полученным значением Kp
                        completion(currentKpValue)
                    }
                }
                // Вы можете использовать geomagneticDataArray для дальнейшей обработки или вывода данных
                print(geomagneticDataArray)
            } else {
                print("Данные не соответствуют ожидаемому формату JSON.")
                completion(nil)
            }
        } catch {
            print("Ошибка при парсинге JSON: \(error)")
            completion(nil)
        }
    }
    task.resume()
}
