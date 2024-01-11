//
//  StormViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//

import UIKit
import SnapKit
import CoreLocation
import SDWebImage
import UserNotifications
import Network

final class StormViewController: UIViewController {
    //MARK: Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let forecastView = ForecastView()
    private let auroraViewController = AuroraViewController()
    private var locationLabelTimer: Timer?
    private var planetaryLabelTimer: Timer?
    private var geomagneticActivityLabelTimer: Timer?
    private var currentCity: String?
    // анимация и кнопка
    private var currentGeomagneticActivityState: GeomagneticActivityState = .noInternet
    private var isAnimating = false
    private var isLabelAnimating = false
    private var isButtonUp = true
    private var isConnected: Bool = false
    // создаем элементы
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = ""
        locationLabel.font = UIFont.SFUITextHeavy(ofSize: 40 )
        locationLabel.textColor = .white
        return locationLabel
    }()
    private let planetaryLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = ""
        locationLabel.font = UIFont.SFUITextHeavy(ofSize: 20 )
        locationLabel.textColor = .white
        return locationLabel
    }()
    private let geomagneticActivityLabel: UILabel = {
        let geomagneticActivityLabel = UILabel()
        geomagneticActivityLabel.text = ""
        geomagneticActivityLabel.font = UIFont.SFUITextHeavy(ofSize: 100)
        geomagneticActivityLabel.textColor = .white
        return geomagneticActivityLabel
    }()
    private let descriptionButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "info.circle")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let bottomMarginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.3)
        return view
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        return refreshControl
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        auroraViewController.setupAuroraGIFBackground()
        setupAppLifecycleObservers()
        setupConstraints()
        setupGestures()
        setupMagnetGIFBackground()
        setupTarget()
        setupLocationManager()
//        setupRefreshControl()
        animateForecastViewAppearance()
    }
    // Notification observer
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    // Приложение свернуто
    @objc private func appDidEnterBackground() {
    }
    // удаляем наблюдатель
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Constraints
    private func setupConstraints() {
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.refreshControl = refreshControl
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(250)
        }
        // text
        scrollView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        scrollView.addSubview(planetaryLabel)
        planetaryLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(20)
        }
        scrollView.addSubview(geomagneticActivityLabel)
        geomagneticActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(planetaryLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        // buttons
        view.addSubview(descriptionButton)
        descriptionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(0) // Отступ от правого края
            make.centerY.equalTo(planetaryLabel) // Выравнивание по вертикали с planetaryLabel
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        // forecast view
        view.addSubview(forecastView)
        forecastView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.greaterThanOrEqualTo(100)
        }
        // tab bar background
        view.addSubview(bottomMarginView)
        bottomMarginView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-0)
        }
    }
    //MARK: GIF Background
    private func setupMagnetGIFBackground() {
        let gifImageView = SDAnimatedImageView(frame: view.bounds)
        if let gifURL = Bundle.main.url(forResource: "StormBackground2", withExtension: "gif") {
            gifImageView.sd_setImage(with: gifURL)
        }
        view.addSubview(gifImageView) // Добавляем imageView на экран
        view.sendSubviewToBack(gifImageView) // Отправляем на задний план
    }
    // определяем стейт текущий
    private func fetchStormValueUI() {
        fetchStormValue { [weak self] currentKpValue in
            DispatchQueue.main.async {
                var state: GeomagneticActivityState = .noInternet
                
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
                        state = .superStorm
                    default:
                        state = .noInternet
                    }
                }
                self?.currentGeomagneticActivityState = state // Обновляем текущее состояние
                self?.geomagneticActivityLabel.text = state.labelText
                self?.animateGeomagneticActivityLabelAppearance(withText: state.labelText)
            }
        }
    }
    //MARK: Network monitor
    private func startNetworkMonitoring() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [self] in
                self.isConnected = path.status == .satisfied
                if self.isConnected {
                    print("Internet connection is available.")
                    self.fetchStormValueUI()
                } else {
                    print("No internet connection.")
                    self.locationLabel.text = "no internet"
                    self.geomagneticActivityLabel.text = "--"
                }
            }
        }
        monitor.start(queue: queue)
    }
} // end
//MARK: - Location Manager Delegate
extension StormViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        self?.currentCity = city // Set the currentCity property
                        self?.animateLocationLabelAppearance(withText: city)
                        self?.animatePlanetaryLabelAppearance(withText: "planeraty_title".localized())
                        self?.fetchStormValueUI()
                        self!.forecastView.fetchStormForecastUI()
                        self?.startNetworkMonitoring()
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
            locationLabel.text = "location.error"
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100000.0 // distance 100km
    }
}
//MARK: Swipe
extension StormViewController {
    // targets
    private func setupTarget() {
        descriptionButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc private func refreshData() {
        print("refresh")
        guard !isLabelAnimating else { return }
        feedbackGenerator.selectionChanged() // Добавьте виброотклик

        if let city = currentCity { // Use the captured city value
            self.animatePlanetaryLabelAppearance(withText: "planeraty_title".localized())
            self.animateLocationLabelAppearance(withText: city)
            self.startNetworkMonitoring()
            self.fetchStormValueUI()
            self.animateForecastViewAppearance()
            self.forecastView.fetchStormForecastUI()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Завершение обновления данных
            self?.refreshControl.endRefreshing()
        }
    }
    // Swipe gestures and buttons
    private func setupGestures() {
        // тап по прогнозу
        let forecastViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(forecastViewTapped))
        forecastView.addGestureRecognizer(forecastViewTapGesture)
        forecastView.isUserInteractionEnabled = true
    }
    // вызываем функцию для экрана прогноза
    @objc private func forecastViewTapped() {
        print("forecastView")
        feedbackGenerator.selectionChanged() // виброотклик
        
        let forecastViewController = ForecastViewController()
        forecastViewController.modalPresentationStyle = .popover
        present(forecastViewController, animated: true, completion: nil)
    }
    // refresh button action
    @objc private func refreshButtonTapped() {
        print("refresh")
        guard !isLabelAnimating else { return }
        feedbackGenerator.selectionChanged() // Добавьте виброотклик

        if let city = currentCity { // Use the captured city value
            self.animatePlanetaryLabelAppearance(withText: "planeraty_title".localized())
            self.animateLocationLabelAppearance(withText: city)
            self.startNetworkMonitoring()
            self.fetchStormValueUI()
            self.animateForecastViewAppearance()
            self.forecastView.fetchStormForecastUI()
        }
    }
    // description button action
    @objc private func descriptionButtonTapped() {
        print("descriptionButtonTapped")
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
        
        let descriptionViewController = StormDescriptionViewController()
        descriptionViewController.modalPresentationStyle = .popover
        present(descriptionViewController, animated: true, completion: nil)
    }
}
//MARK: Animations
extension StormViewController {
    // Animate Location
    private func animateLocationLabelAppearance(withText text: String) {
        locationLabel.alpha = 0.0 // Начнем с нулевой прозрачности
        locationLabel.text = text // Устанавливаем текст

        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.locationLabel.alpha = 1.0 // Увеличиваем прозрачность до 1 (полностью видимый)
        }) { [weak self] (_) in
            self?.locationLabelTimer?.invalidate() // По завершении анимации останавливаем таймер
        }
    }
    // animate planetary label
    private func animatePlanetaryLabelAppearance(withText text: String) {
        planetaryLabel.alpha = 0.0 // Начнем с нулевой прозрачности
        planetaryLabel.text = text // Устанавливаем текст

        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.planetaryLabel.alpha = 1.0 // Увеличиваем прозрачность до 1 (полностью видимый)
        }) { [weak self] (_) in
            self?.planetaryLabelTimer?.invalidate() // По завершении анимации останавливаем таймер
        }
    }
    // Animate GeomagneticActivityLabel
    private func animateGeomagneticActivityLabelAppearance(withText text: String) {
        geomagneticActivityLabel.alpha = 0.0 // Начнем с нулевой прозрачности
        geomagneticActivityLabel.text = text // Устанавливаем текст
        
        UIView.animate(withDuration: 1.2, animations: { [weak self] in
            self?.geomagneticActivityLabel.alpha = 1.0 // Увеличиваем прозрачность до 1 (полностью видимый)
        }) { [weak self] (_) in
            self?.geomagneticActivityLabelTimer?.invalidate() // По завершении анимации останавливаем таймер
        }
    }
    // Аnimate forecast view
    private func animateForecastViewAppearance() {
        forecastView.alpha = 0.0
        view.addSubview(forecastView)
    
        UIView.animate(withDuration: 1.8) {
            self.forecastView.alpha = 1.0
        }
    }
}
