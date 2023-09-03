//
//  MainController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//

import UIKit
import SnapKit
import CoreLocation
import AVKit

final class MainController: UIViewController {
    //MARK: Properties
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var descriptionText = ""
    private var currentCharacterIndex = 0

    
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: 30)
        locationLabel.textColor = .white
        locationLabel.textAlignment = .left
        return locationLabel
    }()
    private let geomagneticActivityLabel: UILabel = {
        let geomagneticActivityLabel = UILabel()
        geomagneticActivityLabel.text = "-"
        geomagneticActivityLabel.font = UIFont.systemFont(ofSize: 30)
        geomagneticActivityLabel.textColor = .white
        geomagneticActivityLabel.textAlignment = .left
        return geomagneticActivityLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "description"
        descriptionLabel.font = UIFont.systemFont(ofSize: 30)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraints()
        setupLocationManager()
        fetchMagneticDataAndUpdateUI()

    }
    //MARK: Constraints
    private func setupConstraints() {
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(geomagneticActivityLabel)
        geomagneticActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(geomagneticActivityLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.lessThanOrEqualTo(320)
        }
    }
    //MARK: Location Manager
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    //MARK: fetchMagneticDataAndUpdateUI
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
                self?.geomagneticActivityLabel.text = state.labelText
                self?.geomagneticActivityLabel.textColor = state.labelColor
//                self?.descriptionLabel.text = state.descriptionText
                self?.animateDescriptionLabelAppearance(withText: state.descriptionText)

            }
        }
    }
    
    private func animateDescriptionLabelAppearance(withText text: String) {
        descriptionText = text
        currentCharacterIndex = 0
        descriptionLabel.text = ""

        // Запускаем таймер, чтобы добавлять буквы каждые 0.1 секунды
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            if self.currentCharacterIndex < self.descriptionText.count {
                let index = self.descriptionText.index(self.descriptionText.startIndex, offsetBy: self.currentCharacterIndex)
                let character = self.descriptionText[index]
                self.descriptionLabel.text?.append(character)
                self.currentCharacterIndex += 1
            } else {
                // Весь текст добавлен, останавливаем таймер
                timer.invalidate()
            }
        }
    }

} // end
//MARK: - LocationManagerDelegate
extension MainController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality, let country = placemark.country {
                        // Обновите ваш locationLabel
                        self?.locationLabel.text = "\(city), \(country)"
                    }
                }
            }
        }
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
            case .noStorm:
                return "G0"
            case .minorStorm:
                return "G1"
            case .weakStorm:
                return "G2"
            case .moderateStorm:
                return "G3"
            case .strongStorm:
                return "G4"
            case .severeStorm:
                return "G5"
            case .extremeStorm:
                return "G6"
            case .outstandingStorm:
                return "G7"
            case .exceptionalStorm:
                return "G8"
            case .superstorm:
                return "G9"
            case .unknown:
                return "?"
            }
        }
        
        var descriptionText: String {
            switch self {
            case .noStorm:
                return "Отсутствие бури:\nНет активности магнитных бурь, магнитное поле Земли стабильно."
            case .minorStorm:
                return "Слабая буря:\nНебольшое возмущение магнитного поля. Возможны слабые влияния на системы связи и навигации."
            case .weakStorm:
                return "Умеренная буря:\nУмеренное возмущение магнитного поля. Может вызывать более серьезные сбои в работе систем связи и навигации, особенно на высоких широтах."
            case .moderateStorm:
                return "Сильная буря:\nСильное возмущение магнитного поля. Может вызывать проблемы с работой спутников и систем связи, а также создавать опасность для космических аппаратов."
            case .strongStorm:
                return "Очень сильная буря:\nОчень сильное возмущение магнитного поля. Этот уровень может вызвать серьезные проблемы для спутниковых систем и сетей электропередачи."
            case .severeStorm:
                return "Сильнейшая буря:\nСамый высокий уровень активности. Может вызывать критические сбои в работе спутников и технических систем, а также повышенные риски для космических аппаратов."
            case .extremeStorm:
                return "Буря выдающегося масштаба:\nЭто экстремально сильная магнитная буря, которая может вызвать массовые отключения электроэнергии, повреждение спутников и серьезные технические проблемы."
            case .outstandingStorm:
                return "Буря исключительного масштаба:\nНаивысший уровень активности магнитных бурь. Может создавать катастрофические последствия для систем связи, навигации и электропередачи."
            case .exceptionalStorm:
                return "Сверхбуря:\nЭтот уровень обозначает сверхбурю масштаба апокалипсиса, которая имеет потенциал разрушить множество технических систем и причинить значительный ущерб."
            case .superstorm:
                return "Супербуря:\nСамый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего технического оборудования и систем связи."
            case .unknown:
                return "Неизвестно"
            }
        }
        
        var labelColor: UIColor {
            switch self {
            case .noStorm:
                return UIColor.systemGreen
            case .minorStorm:
                return UIColor.systemGreen
            case .weakStorm:
                return UIColor.systemGreen
            case .moderateStorm:
                return UIColor.systemYellow
            case .strongStorm:
                return UIColor.systemRed
            case .severeStorm:
                return UIColor.systemRed
            case .extremeStorm:
                return UIColor.systemBlue
            case .outstandingStorm:
                return UIColor.systemRed
            case .exceptionalStorm:
                return UIColor.systemRed
            case .superstorm:
                return UIColor.systemRed
            case .unknown:
                return UIColor.white
            }
        }
    }

}
//MARK: Video
//    private func setupVideoBackground() {
//        guard let videoURL = Bundle.main.url(forResource: "video_background", withExtension: "mp4") else {
//            print("Failed to locate video file.")
//            return
//        }
//
//        let videoPlayer = AVPlayer(url: videoURL)
//        let videoLayer = AVPlayerLayer(player: videoPlayer)
//
//        videoLayer.videoGravity = .resizeAspectFill
//        videoLayer.frame = view.bounds
//        // Добавляем видеослой как нижний слой
//        view.layer.insertSublayer(videoLayer, at: 0)
//
//        videoPlayer.play()
//    }
// Теперь добавляем слой для видеофона прям в констрейнты вниз
//        setupVideoBackground()

//анимация плавного появления
// это во вью дид лоад
//descriptionLabel.alpha = 0.0 // Начально скрываем label
//
//private func animateDescriptionLabelAppearance(withText text: String) {
//    descriptionLabel.text = "" // Очищаем текст перед анимацией
//    descriptionLabel.alpha = 0.0 // Начинаем с нулевой прозрачности
//
//    // Создаем анимацию появления текста по буквам
//    UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveLinear], animations: { [weak self] in
//        text.forEach { char in
//            self?.descriptionLabel.text?.append(char)
//            self?.descriptionLabel.alpha = 1.0
//        }
//    }, completion: nil)
//}
//self?.animateDescriptionLabelAppearance(withText: state.descriptionText)

