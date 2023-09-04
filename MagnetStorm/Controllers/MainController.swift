//
//  MainController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//
/*
 Dnepr
 48,4647
 35,0462
 разобраться с жестами
 добавить кнопку i
 придумать автоперевод на 3 языка
 */
import UIKit
import SnapKit
import CoreLocation
import AVKit

final class MainController: UIViewController {
    //MARK: Properties
    private var currentGeomagneticActivityState: GeomagneticActivityState = .unknown
    private var isAnimating = false
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = ""
        locationLabel.font = UIFont.SFUITextHeavy(ofSize: 30 )
        locationLabel.textColor = .white
        return locationLabel
    }()
    private let geomagneticActivityLabel: UILabel = {
        let geomagneticActivityLabel = UILabel()
        geomagneticActivityLabel.text = ""
        geomagneticActivityLabel.font = UIFont.SFUITextHeavy(ofSize: 30)
        geomagneticActivityLabel.textColor = .white
        return geomagneticActivityLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = ""
        descriptionLabel.font = UIFont.SFUITextHeavy(ofSize: 30)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    private let chevronButton: UIButton = {
        let button = UIButton()
        let customImage = UIImage(named: "arrowUp.png")
        button.setBackgroundImage(customImage, for: .normal)
        return button
    }()
    private let swipeUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Проведи вверх"
        label.font = UIFont.SFUITextHeavy(ofSize: 14)
        label.textColor = .white
        return label
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraints()
        setupLocationManager()
        setupSwipeGesture()
        setupVideoBackground()
        setupTarget()
    }
    //MARK: Target
    private func setupTarget() {
        chevronButton.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
    }
    //MARK: Constraints
    private func setupConstraints() {
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
//            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(geomagneticActivityLabel)
        geomagneticActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(2)
//            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(geomagneticActivityLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(15)
            make.trailing.lessThanOrEqualToSuperview().offset(-40)
        }
        buttonStackView.addArrangedSubview(chevronButton)
        buttonStackView.addArrangedSubview(swipeUpLabel)
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalTo(150)
            make.height.equalTo(65)
        }
    }
    //    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
    //          if gesture.state == .ended {
    //              print("swipe up")
    //              chevronButtonTapped()
    //              animateDescriptionLabelAppearance(withText: currentGeomagneticActivityState.descriptionText)
    //          }
    //      }
    @objc private func chevronButtonTapped() {
        print("chevronButtonTapped")
    }
    private func setupSwipeGesture() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUpGesture.direction = .up
        view.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
        // Устанавливаем зависимость между жестами
        swipeUpGesture.require(toFail: swipeDownGesture)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            print("swipe up")
            if isAnimating {
                // Выполнить анимацию сворачивания текста
                animateDescriptionLabelDisappearance()
            } else {
                // Выполнить анимацию раскрытия текста
                animateDescriptionLabelAppearance(withText: currentGeomagneticActivityState.descriptionText)
            }
            isAnimating.toggle()
        }
    }
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            print("swipe down")
            if isAnimating {
                // Выполнить анимацию сворачивания текста
                animateDescriptionLabelDisappearance()
            }
        }
    }
    
    func animateDescriptionLabelDisappearance() {
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.alpha = 0 // Установка альфа-канала на 0 для скрытия метки
        } completion: { _ in
            self.isAnimating = false // Снимаем флаг анимации после завершения анимации
        }
    }
    
    //MARK: Video Background
    private func setupVideoBackground() {
        guard let videoURL = Bundle.main.url(forResource: "video_background2", withExtension: "mp4") else {
            print("Failed to locate video file.")
            return
        }
        
        let videoPlayer = AVPlayer(url: videoURL)
        let videoLayer = AVPlayerLayer(player: videoPlayer)
        
        videoLayer.videoGravity = .resizeAspectFill
        videoLayer.frame = view.bounds
        // Добавляем видеослой как нижний слой
        view.layer.insertSublayer(videoLayer, at: 0)
        // Зацикливаем видео
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: nil) { _ in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
        videoPlayer.play()
    }
    //MARK: Fetch Data
    private func fetchMagneticDataAndUpdateUI() {
        fetchMagneticData { [weak self] currentKpValue in
            DispatchQueue.main.async {
                var state: GeomagneticActivityState = .unknown
                
                if let kpValue = currentKpValue, let intValue = Int(kpValue) {
                    switch intValue {
                    case 0:
                        state = .noStorm
                    case 1:
                        state = .minorStorm
                    case 2:
                        state = .weakStorm
                    case 3:
                        state = .moderateStorm
                    case 4:
                        state = .strongStorm
                    case 5:
                        state = .severeStorm
                    case 6:
                        state = .extremeStorm
                    case 7:
                        state = .outstandingStorm
                    case 8:
                        state = .exceptionalStorm
                    case 9:
                        state = .superstorm
                    default:
                        state = .unknown
                    }
                }
                //                self?.geomagneticActivityLabel.text = state.labelText
                //                self?.geomagneticActivityLabel.textColor = state.labelColor
                //                self?.descriptionLabel.text = state.descriptionText
                //                self?.animateDescriptionLabelAppearance(withText: state.descriptionText)
                self?.currentGeomagneticActivityState = state // Обновляем текущее состояние
                self?.geomagneticActivityLabel.text = state.labelText
                self?.geomagneticActivityLabel.textColor = state.labelColor
                // Вызываем анимацию текста в geomagneticActivityLabel
                self?.animateGeomagneticActivityLabelAppearance(withText: state.labelText)
                
            }
        }
    }
    //MARK: Animate Description
    private func animateDescriptionLabelAppearance(withText text: String) {
        descriptionLabel.text = ""
        var currentCharacterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if currentCharacterIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentCharacterIndex)
                let character = text[index]
                self.descriptionLabel.text?.append(character)
                currentCharacterIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    //MARK: Animate Location
    private func animateLocationLabelAppearance(withText text: String) {
        locationLabel.text = ""
        var currentCharacterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if currentCharacterIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentCharacterIndex)
                let character = text[index]
                self.locationLabel.text?.append(character)
                currentCharacterIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    //MARK: Animate Geomagnitic
    private func animateGeomagneticActivityLabelAppearance(withText text: String) {
        geomagneticActivityLabel.text = ""
        var currentCharacterIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            if currentCharacterIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentCharacterIndex)
                let character = text[index]
                self.geomagneticActivityLabel.text?.append(character)
                currentCharacterIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
} // end
//MARK: - Location Manager Delegate
extension MainController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        //                        if let city = placemark.locality, let country = placemark.country
                        //                        self?.locationLabel.text = "\(city), \(country)" // Обновите ваш locationLabel
                        //                        self?.locationLabel.text = "\(city)" // Обновите ваш locationLabel
                        self?.animateLocationLabelAppearance(withText: city)
                        self?.fetchMagneticDataAndUpdateUI() // запустится только после разрешения геолокации
                    }
                }
            }
        }
    }
    // didChangeAuthorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Доступ к геопозиции разрешен при использовании приложения.")
        case .denied:
            print("Доступ к геопозиции запрещен.")
        case .restricted:
            print("Доступ к геопозиции ограничен.")
        case .notDetermined:
            print("Статус разрешения на доступ к геопозиции еще не определен.")
        default:
            break
        }
    }
    //MARK: Location Manager
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
//MARK: State
extension MainController {
    enum GeomagneticActivityState {
        case noStorm
        case minorStorm
        case weakStorm
        case moderateStorm
        case strongStorm
        case severeStorm
        case extremeStorm
        case outstandingStorm
        case exceptionalStorm
        case superstorm
        case unknown
        
        var labelText: String {
            switch self {
            case .noStorm: // 0
                return "G0"
            case .minorStorm: // 1
                return "G1"
            case .weakStorm: // 2
                return "G2"
            case .moderateStorm: // 3
                return "G3"
            case .strongStorm: // 4
                return "G4"
            case .severeStorm: // 5
                return "G5"
            case .extremeStorm: // 6
                return "G6"
            case .outstandingStorm: // 7
                return "G7"
            case .exceptionalStorm: // 8
                return "G8"
            case .superstorm: // 9
                return "G9"
            case .unknown:
                return "?"
            }
        }
        
        var descriptionText: String {
            switch self {
            case .noStorm:
                return "Отсутствие бури:\nВлияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь."
            case .minorStorm:
                return "Слабая буря:\nВлияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство."
            case .weakStorm:
                return "Умеренная буря:\nВлияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне."
            case .moderateStorm:
                return "Сильная буря:\nЭтот уровень бури может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения у чувствительных людей."
            case .strongStorm:
                return "Очень сильная буря:\nЭтот уровень бури может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения особенно у чувствительных людей."
            case .severeStorm:
                return "Сильнейшая буря:\nВлияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей."
            case .extremeStorm:
                return "Буря выдающегося масштаба:\nНа этом уровне симптомы могут стать более выраженными и распространенными. У людей, более чувствительных к магнитным полям, могут возникать более серьезные головные боли, бессонница и изменения настроения."
            case .outstandingStorm:
                return "Буря исключительного масштаба:\nЭтот уровень бури может вызвать значительное ухудшение физического и эмоционального состояния у большого числа людей. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени."
            case .exceptionalStorm:
                return "Сверхбуря:\nНа этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, усиление бессонницы и серьезное изменение эмоционального состояния."
            case .superstorm:
                return "Супербуря:\nСамый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире."
            case .unknown:
                return "Неизвестно"
            }
        }
        
        var labelColor: UIColor {
            switch self {
            case .noStorm:
                return UIColor.white // 0
            case .minorStorm:
                return UIColor.white // 1
            case .weakStorm:
                return UIColor.white // 2
            case .moderateStorm:
                return UIColor.white // 3
            case .strongStorm:
                return UIColor.white // 4
            case .severeStorm:
                return UIColor.white // 5
            case .extremeStorm:
                return UIColor.white // 6
            case .outstandingStorm:
                return UIColor.white // 7
            case .exceptionalStorm:
                return UIColor.white // 8
            case .superstorm:
                return UIColor.white // 9
            case .unknown:
                return UIColor.white // 0
            }
        }
    }
}
