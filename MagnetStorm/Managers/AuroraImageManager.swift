//
//  AuroraImageManager.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 10.10.2023.
//

import Foundation
import SwiftSoup

func fetchHTMLData(completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "https://services.swpc.noaa.gov/images/animations/ovation/north/") else {
        completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
        if let error = error {
            completion(.failure(error))
        } else if let data = data, let htmlString = String(data: data, encoding: .utf8) {
            completion(.success(htmlString))
        } else {
            completion(.failure(NSError(domain: "Invalid HTML", code: 0, userInfo: nil)))
        }
    }
    task.resume()
}

func extractLastImageURL(from html: String) -> String? {
    do {
        let doc = try SwiftSoup.parse(html)
        let links = try doc.select("a[href]")
        // Получите последнюю ссылку
        if let lastImageLink = links.last,
           let imageName = try? lastImageLink.attr("href") {
            return imageName
        } else {
            return nil
        }
    } catch {
        print("Ошибка при анализе HTML: \(error.localizedDescription)")
        return nil
    }
}

func loadImage(_ imageURL: String, into imageView: UIImageView) {
    let fullImageURL = "https://services.swpc.noaa.gov/images/animations/ovation/north/\(imageURL)"
    
    guard let url = URL(string: fullImageURL) else {
        print("URL изображения недействителен.")
        return
    }
    DispatchQueue.global().async {
        do {
            let imageData = try Data(contentsOf: url)
            
            if let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        } catch {
            print("Ошибка при загрузке изображения: \(error.localizedDescription)")
        }
    }
}

