//
//  MainViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//
//Добавить процент северного сияния
//достанем температуру солнца онлайн
import UIKit
import SnapKit
import CoreLocation
import SDWebImage
import UserNotifications
import Network

final class MainViewController: UIViewController {
    //MARK: Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let forecastView = ForecastView()
    //MARK: Properties
    private var locationLabelTimer: Timer?
    private var geomagneticActivityLabelTimer: Timer?
    private var currentCity: String?
    // анимация и кнопка
    private var currentGeomagneticActivityState: GeomagneticActivityState = .noInternet // текущий стейт
    private var isAnimating = false
    private var isLabelAnimating = false
    private var isButtonUp = true // следим за кнопкой
    private var isConnected: Bool = false
    // создаем элементы
    private let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.text = ""
        locationLabel.font = UIFont.SFUITextHeavy(ofSize: 40 )
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
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = ""
        descriptionLabel.font = UIFont.SFUITextLight(ofSize: 22)
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
    private let chevronButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "chevron.up.chevron.down")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let descriptionButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "info.circle.fill")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppLifecycleObservers()
        setupConstraints()
        setupGestures()
        setupAnimatedGIFBackground()
        setupTarget()
//        startNetworkMonitoring()
        setupLocationManager()
    }
    // Notification observer
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    // Приложение свернуто
    @objc private func appDidEnterBackground() {
        animateDescriptionLabelDisappearance()
    }
    // Приложение будет восстановлено
    @objc private func appWillEnterForeground() {
        setupNotificationTimer()
    }
    // удаляем наблюдатель
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Constraints
    private func setupConstraints() {
        // text
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        view.addSubview(geomagneticActivityLabel)
        geomagneticActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(geomagneticActivityLabel.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(15)
            make.trailing.lessThanOrEqualToSuperview().offset(-25)
        }
        // buttons
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        view.addSubview(chevronButton)
        chevronButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
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
        // forecast view
        animateForecastViewAppearance()
        forecastView.snp.makeConstraints { make in
            make.bottom.equalTo(chevronButton.snp.top).offset(0)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.greaterThanOrEqualTo(100)
        }
        // UIPageControl
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
        }
    }
    //MARK: GIF Background
    private func setupAnimatedGIFBackground() {
        let gifImageView = SDAnimatedImageView(frame: view.bounds)
        if let gifURL = Bundle.main.url(forResource: "stormBackground_gif", withExtension: "gif") {
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
    //MARK: UIPageControl
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2 // количество доступных экранов
        pageControl.currentPage = 0 // текущий экран
        pageControl.pageIndicatorTintColor = UIColor.gray // Цвет точек экранов
        pageControl.currentPageIndicatorTintColor = UIColor.white // Цвет точки
        return pageControl
    }()
    // scroll func
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)) + 1
        pageControl.currentPage = currentPage
    }
} // end
//MARK: - Location Manager Delegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        self?.currentCity = city // Set the currentCity property
                        self?.animateLocationLabelAppearance(withText: city)
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
extension MainViewController {
    // targets
    private func setupTarget() {
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        chevronButton.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
        descriptionButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
    }
    // Swipe gestures and buttons
    private func setupGestures() {
        // свайп по экрану вправо
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        // свайп вверх для вызова описания
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUpGesture.direction = .up
        swipeUpGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeUpGesture)
        // свайп вниз для вызова описания
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDownGesture.direction = .down
        swipeDownGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeDownGesture)
        swipeUpGesture.require(toFail: swipeDownGesture) // Устанавливаем зависимость между жестами
        // тап по описанию
        let descriptionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionViewTapped))
        descriptionLabel.addGestureRecognizer(descriptionLabelTapGesture)
        descriptionLabel.isUserInteractionEnabled = true
        // тап по прогнозу
        let forecastViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(forecastViewTapped))
        forecastView.addGestureRecognizer(forecastViewTapGesture)
        forecastView.isUserInteractionEnabled = true
    }
    // свайп вправо
    @objc private func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            // Создайте экземпляр второго вью контроллера
            let secondViewController = SecondViewController()
            // Вызовите метод pushViewController для UINavigationController, чтобы выполнить переход на второй экран
            navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    // swipe up
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard !isAnimating else {
            return // Если текст полностью отображен вверх не свайпаем
        }
        if gesture.state == .ended {
            switch (isAnimating, isLabelAnimating) {
            case (false, _):
                descriptionLabel.alpha = 1
                if !isLabelAnimating {
                    animateDescriptionLabelAppearance(withText: currentGeomagneticActivityState.descriptionText)
                    feedbackGenerator.selectionChanged() // виброотклик
                }
            default:
                break
            }
            isAnimating.toggle()
        }
    }
    // swipe down
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            switch (isAnimating, isLabelAnimating) {
            case (true, false):
                animateDescriptionLabelDisappearance()
                feedbackGenerator.selectionChanged() // виброотклик
            default:
                break
            }
        }
    }
    // вызываем функцию описания
    @objc private func descriptionViewTapped() {
        descriptionButtonTapped()
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
    }
    // вызываем функцию для экрана прогноза
    @objc private func forecastViewTapped() {
        print("forecastView")
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
    }
    // refresh button action
    @objc private func refreshButtonTapped() {
        print("refresh")
        guard !isLabelAnimating else { return }
        feedbackGenerator.selectionChanged() // Добавьте виброотклик

        if let city = currentCity { // Use the captured city value
            self.animateDescriptionLabelDisappearance()
            self.animateLocationLabelAppearance(withText: city)
            self.startNetworkMonitoring()
            self.fetchStormValueUI()
            self.animateForecastViewAppearance()
            self.forecastView.fetchStormForecastUI()
        }
    }
    // chevron button action
    @objc private func chevronButtonTapped() {
        // Создаем фиктивные жесты
        let fakeSwipeUpGesture = UISwipeGestureRecognizer()
        fakeSwipeUpGesture.direction = .up
        fakeSwipeUpGesture.state = .ended
        
        let fakeSwipeDownGesture = UISwipeGestureRecognizer()
        fakeSwipeDownGesture.direction = .down
        fakeSwipeDownGesture.state = .ended
        
        if isButtonUp {
            handleSwipe(fakeSwipeUpGesture)
            feedbackGenerator.selectionChanged() // виброотклик
        } else {
            handleSwipeDown(fakeSwipeDownGesture)
            feedbackGenerator.selectionChanged() // виброотклик
        }
    }
    // info button action
    @objc private func descriptionButtonTapped() {
        print("descriptionButtonTapped")
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
        
        let infoViewController = DescriptionViewController()
        infoViewController.modalPresentationStyle = .popover
        present(infoViewController, animated: true, completion: nil)
    }
    // toggle chevron button
    private func toggleChevronButtonImage() {
        isButtonUp.toggle()
        let imageName = isButtonUp ? "chevron.up.chevron.down" : "chevron.up.chevron.down"
        let chevronImage = UIImage(systemName: imageName)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = UIColor.white
        feedbackGenerator.selectionChanged() // виброотклик
    }
}
//MARK: Animations
extension MainViewController {
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
    // Animate Description swipe up
    private func animateDescriptionLabelAppearance(withText text: String) {
        descriptionLabel.text = ""
        var currentCharacterIndex = 0
        isLabelAnimating = true // Устанавливаем флаг в true при начале анимации
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
                self.isLabelAnimating = false
                self.toggleChevronButtonImage()
            }
        }
    }
    // Animate Description swipe down
    private func animateDescriptionLabelDisappearance() {
        isLabelAnimating = true
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.alpha = 0
        } completion: { _ in
            self.isLabelAnimating = false
            self.isAnimating = false
            self.toggleChevronButtonImage()
        }
    }
    // Аnimate forecast view
    private func animateForecastViewAppearance() {
        forecastView.alpha = 0.0
        view.addSubview(forecastView)
    
        UIView.animate(withDuration: 2.5) {
            self.forecastView.alpha = 1.0
        }
    }
}
//MARK: UserNotificationCenter
extension MainViewController {
    private func setupNotificationTimer() {
        let threeHours: TimeInterval = 3 * 3600 // 3 часа
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: threeHours, repeats: false)
        let content = UNMutableNotificationContent()
        
        content.title = "MagnetStorm"
        content.body = "notification_text".localized()
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: "UpdateData", content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Ошибка при установке таймера: \(error)")
            } else {
                print("Таймер на уведомление установлен успешно.")
            }
        }
    }
}

