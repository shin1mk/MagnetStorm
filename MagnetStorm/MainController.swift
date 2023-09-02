//
//  MainController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//

import UIKit
import SnapKit
import CoreLocation

final class MainController: UIViewController {
    //MARK: let
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    private let geomagneticActivityLabel: UILabel = {
        let conditionLabel = UILabel()
        conditionLabel.text = "?"
        conditionLabel.font = UIFont.systemFont(ofSize: 200)
        conditionLabel.textColor = .white
        conditionLabel.textAlignment = .center
        return conditionLabel
    }()
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: 20)
        locationLabel.textColor = .white
        locationLabel.textAlignment = .center
        return locationLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraints()
        fetchMagneticDataAndUpdateUI()
        setupLocationManager()
    }
    //MARK: fetchMagneticDataAndUpdateUI
    private func fetchMagneticDataAndUpdateUI() {
        fetchMagneticData { [weak self] currentKpValue in
            DispatchQueue.main.async {
                var state: GeomagneticActivityState = .unknown

                if let kpValue = currentKpValue, let intValue = Int(kpValue) {
                    switch intValue {
                    case 0...4:
                        state = .minor(intValue) // Указываем точное значение
                    case 5:
                        state = .weak
                    case 6:
                        state = .moderate
                    case 7:
                        state = .severe
                    case 8:
                        state = .storm
                    case 9:
                        state = .extreme
                    default:
                        state = .unknown
                    }
                }
                
                self?.geomagneticActivityLabel.text = state.labelText
                self?.geomagneticActivityLabel.textColor = state.labelColor
            }
        }
    }

    

    //MARK: Constraints
    private func setupConstraints() {
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        view.addSubview(geomagneticActivityLabel)
        geomagneticActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
        }

    }
    //MARK: Location Manager
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
} // end
extension MainController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality, let country = placemark.country {
                        // Обновите ваш locationLabel с названием города и страны
                        self?.locationLabel.text = "\(city), \(country)"
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка местоположения: \(error.localizedDescription)")
    }
}

extension MainController {
    enum GeomagneticActivityState {
        case minor(Int) // Используем ассоциированное значение Int
        case weak
        case moderate
        case severe
        case storm
        case extreme
        case unknown
        
        var labelText: String {
            switch self {
            case .minor(let value):
                return "\(value)" // Выводим точное значение
            case .weak:
                return "5"
            case .moderate:
                return "6"
            case .severe:
                return "7"
            case .storm:
                return "8"
            case .extreme:
                return "9"
            case .unknown:
                return "?"
            }
        }
        
        var labelColor: UIColor {
            switch self {
            case .minor:
                return UIColor.gray
            case .weak:
                return UIColor.yellow
            case .moderate:
                return UIColor.orange
            case .severe:
                return UIColor.red
            case .storm:
                return UIColor.red
            case .extreme:
                return UIColor.systemGray6
            default:
                return UIColor.white
            }
        }
    }
}
