//
//  MainViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//

import UIKit
import SnapKit
import CoreLocation
import SDWebImage

final class MainViewController: UIViewController {
    //MARK: Properties
    private var currentGeomagneticActivityState: GeomagneticActivityState = .unknown // текущий стейт
    private var currentCharacterIndex = 0
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var locationLabelTimer: Timer?
    private var geomagneticActivityLabelTimer: Timer?
    private var currentCity: String?
    // анимация и кнопка
    private var isAnimating = false
    private var isLabelAnimating = false
    private var isButtonUp = true
    // создаем элементы
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
    private let refreshButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "arrow.clockwise")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let chevronButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "chevron.up.circle")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    private let infoButton: UIButton = {
        let button = UIButton()
        let chevronImage = UIImage(systemName: "info.circle")
        button.setImage(chevronImage, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppLifecycleObservers()
        setupConstraints()
        setupLocationManager()
        setupSwipeGesture()
        setupAnimatedGIFBackground()
        setupTarget()
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
        chevronButton.setImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: Constraints
    private func setupConstraints() {
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(15)
            make.height.greaterThanOrEqualTo(40)
        }
        view.addSubview(geomagneticActivityLabel)
        geomagneticActivityLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(15)
            make.height.greaterThanOrEqualTo(40)
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(geomagneticActivityLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(15)
            make.trailing.lessThanOrEqualToSuperview().offset(-25)
        }
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        view.addSubview(chevronButton)
        chevronButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
    }
    //MARK: GIF Background
    private func setupAnimatedGIFBackground() {
        // Создаем SDAnimatedImageView
        let gifImageView = SDAnimatedImageView(frame: view.bounds)
        if let gifURL = Bundle.main.url(forResource: "background_gif", withExtension: "gif") {
            gifImageView.sd_setImage(with: gifURL)
        }
        view.addSubview(gifImageView) // Добавляем imageView на экран
        view.sendSubviewToBack(gifImageView) // Отправляем на задний план
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
                        state = .superStorm
                    default:
                        state = .unknown
                    }
                }
                self?.currentGeomagneticActivityState = state // Обновляем текущее состояние
                self?.geomagneticActivityLabel.text = state.labelText
                self?.animateGeomagneticActivityLabelAppearance(withText: state.labelText)
            }
        }
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
                        self?.fetchMagneticDataAndUpdateUI()
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
//MARK: Swipe
extension MainViewController {
    // Swipe gestures and buttons
    private func setupSwipeGesture() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUpGesture.direction = .up
        swipeUpGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDownGesture.direction = .down
        swipeDownGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeDownGesture)
        swipeUpGesture.require(toFail: swipeDownGesture) // Устанавливаем зависимость между жестами
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
            default:
                break
            }
        }
    }
    // toggle chevron button
    private func toggleChevronButtonImage() {
        isButtonUp.toggle()
        let imageName = isButtonUp ? "chevron.up.circle" : "chevron.down.circle"
        let chevronImage = UIImage(systemName: imageName)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = UIColor.white
        
        animateChevronButtonImageChange(withImage: chevronImage)
    }
    // Targets
    private func setupTarget() {
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        chevronButton.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    // refresh button action
    @objc private func refreshButtonTapped() {
        print("refresh")
        guard !isLabelAnimating else { return }
        
        if isAnimating {
            if let city = currentCity { // Use the captured city value
                animateDescriptionLabelDisappearance()
                // Delay the restart of locationLabel animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animateLocationLabelAppearance(withText: city)
                    self.fetchMagneticDataAndUpdateUI()
                }
            }
        } else {
            if let city = currentCity { // Use the captured city value
                // Restart the locationLabel animation immediately
                animateLocationLabelAppearance(withText: city)
                fetchMagneticDataAndUpdateUI()
            }
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
        } else {
            handleSwipeDown(fakeSwipeDownGesture)
        }
    }
    // info button action
    @objc private func infoButtonTapped() {
        print("infoButtonTapped")
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .popover
        present(infoViewController, animated: true, completion: nil)
    }
}
//MARK: Animations
extension MainViewController {
    //MARK: Animate Location
    private func animateLocationLabelAppearance(withText text: String) {
        locationLabel.text = ""
        var currentCharacterIndex = 0
        locationLabelTimer?.invalidate() // Остановить предыдущий таймер
        locationLabelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
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
    //MARK: Animate GeomagneticActivityLabel
    private func animateGeomagneticActivityLabelAppearance(withText text: String) {
        geomagneticActivityLabel.text = ""
        var currentCharacterIndex = 0
        geomagneticActivityLabelTimer?.invalidate() // Остановить предыдущий таймер
        geomagneticActivityLabelTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer in
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
    //MARK: Animate Description
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
    //MARK: Animate Description Label swipe down
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
    //MARK: Animate chevron button
    private func animateChevronButtonImageChange(withImage image: UIImage?) {
        UIView.transition(with: chevronButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.chevronButton.setImage(image, for: .normal)
        }, completion: nil)
    }
}
