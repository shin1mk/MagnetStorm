//
//  SecondViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 06.10.2023.
//
// добавим все данные как на первом экране и выводить данные в гигаватах
// поставить время обновления на обоих экранах
// добавить скролл вью
// добавить инфо вью
import UIKit
import SwiftSoup

class SecondViewController: UIViewController {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupSwipeGesture()
        setupSwipeGesture()
        
        
        
//        view.addSubview(imageView)
//
//        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
//
//        fetchHTML { result in
//            switch result {
//            case .success(let html):
//                if let imageURL = self.extractLastImageURL(from: html) {
//                    print("URL последнего изображения: \(imageURL)")
//                    self.loadImageFromURL(imageURL)
//                } else {
//                    print("URL последнего изображения не найден")
//                }
//            case .failure(let error):
//                print("Ошибка при загрузке HTML: \(error.localizedDescription)")
//            }
//        }
    }
    
    func fetchHTML(completion: @escaping (Result<String, Error>) -> Void) {
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

    func loadImageFromURL(_ imageURL: String) {
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
                        self.imageView.image = image
                    }
                }
            } catch {
                print("Ошибка при загрузке изображения: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func setupConstraint() {
        view.backgroundColor = .systemOrange
        navigationItem.hidesBackButton = true

        // Добавьте UIPageControl на представление и настройте его с использованием SnapKit
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
        }
    }
    // Добавьте UIPageControl на ваше представление
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2 // Задайте количество доступных экранов
        pageControl.currentPage = 1 // Задайте текущий экран пользователя
        pageControl.pageIndicatorTintColor = UIColor.gray // Цвет точек экранов
        pageControl.currentPageIndicatorTintColor = UIColor.white // Цвет текущей точки
        return pageControl
    }()

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)) + 1
        pageControl.currentPage = currentPage
    }
    
    private func setupSwipeGesture() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }

    @objc private func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            navigationController?.popViewController(animated: true)
        }
    }

}
