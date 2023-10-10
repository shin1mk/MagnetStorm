//
//  SecondViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 06.10.2023.
//
// картинка должна быть кликабельна
// рефрешь обновляет данные гигавата и картинку с индикатором загрузки
// информация вставить 4 картинки
// придумать объяснение
// локализовать текст
import UIKit
import SnapKit

final class SecondViewController: UIViewController {
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    //MARK: Properties
    private let backgroundImage: UIImageView = {
        let backgroundView = UIImageView()
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.image = UIImage(named: "aurora_background.png")
        return backgroundView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let northLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "Aurora"
        locationLabel.font = UIFont.SFUITextHeavy(ofSize: 40 )
        locationLabel.textColor = .white
        return locationLabel
    }()
    private let northActivityLabel: UILabel = {
        let geomagneticActivityLabel = UILabel()
        geomagneticActivityLabel.text = ""
        geomagneticActivityLabel.font = UIFont.SFUITextHeavy(ofSize: 100)
        geomagneticActivityLabel.textColor = .white
        return geomagneticActivityLabel
    }()
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.text = "GigaWatts"
        valueLabel.font = UIFont.SFUITextMedium(ofSize: 18)
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 0
        return valueLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "NORTHERN HEMISPHERE"
        descriptionLabel.font = UIFont.SFUITextMedium(ofSize: 25)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    private let refreshButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "arrow.clockwise.circle.fill")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let descriptionButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "info.circle.fill")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2 // количество экранов
        pageControl.currentPage = 1 // текущий экран
        pageControl.pageIndicatorTintColor = UIColor.gray // Цвет точек
        pageControl.currentPageIndicatorTintColor = UIColor.white // Цвет текущей
        return pageControl
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTarget()
        setupConstraint()
        setupSwipeGesture()
        fetchDataAndDisplayAuroraImage()
        fetchAuroraNowcastValue()
    }
    //MARK: Methods
    private func setupConstraint() {
        navigationItem.hidesBackButton = true
        // background image
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(northLabel)
        northLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        view.addSubview(northActivityLabel)
        northActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(northLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        view.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(northActivityLabel.snp.bottom).offset(-15)
            make.centerX.equalToSuperview()
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        // image north aurora
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        // buttons
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        view.addSubview(descriptionButton)
        descriptionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        // page control
        view.addSubview(pageControl)
        pageControl.layer.zPosition = 100
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    
    private func fetchAuroraNowcastValue() {
        auroraNowcastValue { result in
            switch result {
            case .success(let value):
                print("Получено значение: \(value)")
                DispatchQueue.main.async { // Если вы обновляете пользовательский интерфейс, выполните это на главной очереди.
                    self.northActivityLabel.text = value
                }            case .failure(let error):
                print("Произошла ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchDataAndDisplayAuroraImage() {
         fetchHTMLData { result in
             DispatchQueue.main.async {
                 switch result {
                 case .success(let html):
                     if let imageURL = extractLastImageURL(from: html) {
                         self.loadAndDisplayImageFromURL(imageURL)
                     }
                 case .failure(let error):
                     print("Error fetching HTML: \(error.localizedDescription)")
                 }
             }
         }
     }
    
    private func loadAndDisplayImageFromURL(_ imageURL: String) {
        loadImage(imageURL, into: self.imageView)
    }
    
} // end
//MARK: Gestures
extension SecondViewController {
    // swipe back
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
extension SecondViewController {
    // targets
    private func setupTarget() {
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
    }
    // refresh button action
    @objc private func refreshButtonTapped() {
        print("refreshAurora")
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
    }
    // description button action
    @objc private func descriptionButtonTapped() {
        print("descriptionButtonTappedAurora")
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
    }
}
