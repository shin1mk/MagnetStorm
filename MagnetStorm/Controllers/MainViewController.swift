//
//  MainViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//
//Добавить процент северного сияния
//изменить описание
//достанем температуру солнца онлайн
//на два дня прогноз
// вынести в отдельную вью то что на 3 дня

import UIKit
import SnapKit
import CoreLocation
import SDWebImage
import UserNotifications

final class MainViewController: UIViewController {
    private let todayLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.text = ""
        dataLabel.font = UIFont.SFUITextRegular(ofSize: 20)
        dataLabel.textColor = .white
        return dataLabel
    }()
    private let tomorrowLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.text = ""
        dataLabel.font = UIFont.SFUITextRegular(ofSize: 20)
        dataLabel.textColor = .white
        return dataLabel
    }()
    private let dayAfterLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.text = ""
        dataLabel.font = UIFont.SFUITextRegular(ofSize: 20)
        dataLabel.textColor = .white
        return dataLabel
    }()
    private let labelsStackView: UIStackView = {
         let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.spacing = 10  // Расстояние между метками
         return stackView
     }()
    //MARK: Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private var currentGeomagneticActivityState: GeomagneticActivityState = .unknown // текущий стейт
    private var currentCharacterIndex = 0
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private var timer: Timer?
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
        let chevronImage = UIImage(systemName: "arrow.clockwise.circle")
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
        UserDefaults.standard.set(isButtonUp, forKey: "isButtonUp")
    }
    // Приложение будет восстановлено
    @objc private func appWillEnterForeground() {
        chevronButton.setImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
        updateChevronButtonImage()
        setupNotificationTimer()
    }
    
    private func updateChevronButtonImage() {
        if let savedIsButtonUp = UserDefaults.standard.value(forKey: "isButtonUp") as? Bool {
            isButtonUp = savedIsButtonUp
            let imageName = isButtonUp ? "chevron.up.circle" : "chevron.down.circle"
            let chevronImage = UIImage(systemName: imageName)
            chevronButton.setImage(chevronImage, for: .normal)
        }
    }
    // удаляем деинит
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
//        view.addSubview(todayLabel)
//        todayLabel.snp.makeConstraints { make in
//            make.top.equalTo(descriptionLabel.snp.bottom).offset(2)
//            make.leading.equalToSuperview().offset(15)
//            make.height.greaterThanOrEqualTo(40)
//        }
//        view.addSubview(tomorrowLabel)
//        tomorrowLabel.snp.makeConstraints { make in
//            make.top.equalTo(todayLabel.snp.bottom).offset(2)
//            make.leading.equalToSuperview().offset(15)
//            make.height.greaterThanOrEqualTo(40)
//        }
//        view.addSubview(dayAfterLabel)
//        dayAfterLabel.snp.makeConstraints { make in
//            make.top.equalTo(tomorrowLabel.snp.bottom).offset(2)
//            make.leading.equalToSuperview().offset(15)
//            make.height.greaterThanOrEqualTo(40)
//        }
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
        // Добавляем lable в stack
        labelsStackView.addArrangedSubview(todayLabel)
        labelsStackView.addArrangedSubview(tomorrowLabel)
        labelsStackView.addArrangedSubview(dayAfterLabel)
        
        view.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(chevronButton.snp.top).offset(-20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.greaterThanOrEqualTo(40)
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
//    //MARK: Fetch Data
//    private func fetchAndDisplayTextData() {
//        fetchStormForecast { result in
//            DispatchQueue.main.async { // Обновление интерфейса должно выполняться в основной очереди
//                switch result {
//                case .success(let text):
//                    // Парсим полученный текст
//                    let parsedData = parseStormForecastData(text: text)
//                    // Создаем массивы для значений today, tomorrow и afterday
//                    var today: [Double] = []
//                    var tomorrow: [Double] = []
//                    var afterday: [Double] = []
//                    // Определяем сегодняшнюю дату
//                    let currentDate = Date()
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "E, MMM d" // Формат дня недели и даты
//                    print("Сегодняшняя дата: \(dateFormatter.string(from: currentDate))")
//                    // Определяем календарь
//                    let calendar = Calendar.current
//                    // Вычисляем даты для завтрашнего дня и послезавтрашнего дня
//                    if let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: currentDate),
//                       let afterTomorrowDate = calendar.date(byAdding: .day, value: 2, to: currentDate) {
//                        print("Дата завтрашнего дня: \(dateFormatter.string(from: tomorrowDate))")
//                        print("Дата послезавтрашнего дня: \(dateFormatter.string(from: afterTomorrowDate))")
//
//                        // Распределяем значения по массивам
//                        for dataEntry in parsedData {
//                            if dataEntry.values.indices.contains(0) {
//                                today.append(dataEntry.values[0])
//                            }
//                            if dataEntry.values.indices.contains(1) {
//                                tomorrow.append(dataEntry.values[1])
//                            }
//                            if dataEntry.values.indices.contains(2) {
//                                afterday.append(dataEntry.values[2])
//                            }
//                        }
//
//                        print("Значения для today: \(today)")
//                        print("Значения для tomorrow: \(tomorrow)")
//                        print("Значения для afterday: \(afterday)")
//
//                        // Находим минимальное и максимальное значение для today
//                        if let todayMin = today.min(),
//                           let todayMax = today.max() {
//                            let numberFormatter = NumberFormatter()
//                            numberFormatter.maximumFractionDigits = 0
//
//                            let todayMinValue = "G" + numberFormatter.string(from: NSNumber(value: todayMin))!
//                            let todayMaxValue = "G" + numberFormatter.string(from: NSNumber(value: todayMax))!
//
//                            // Обновляем метку на интерфейсе с минимальными и максимальными значениями
//                            self.todayLabel.text = "\(dateFormatter.string(from: currentDate)): ↓\(todayMinValue) ↑\(todayMaxValue)"
//                        } else {
//                            // Обработка случая, когда today пуст или не содержит числовых значений
//                            self.todayLabel.text = "\(dateFormatter.string(from: currentDate)): -"
//                        }
//
//                        // Находим минимальное и максимальное значение для tomorrow
//                        if let tomorrowMin = tomorrow.min(),
//                           let tomorrowMax = tomorrow.max() {
//                            let numberFormatter = NumberFormatter()
//                            numberFormatter.maximumFractionDigits = 0
//
//                            let tomorrowMinValue = "G" + numberFormatter.string(from: NSNumber(value: tomorrowMin))!
//                            let tomorrowMaxValue = "G" + numberFormatter.string(from: NSNumber(value: tomorrowMax))!
//
//                            // Обновляем метку на интерфейсе с минимальными и максимальными значениями
//                            self.tomorrowLabel.text = "\(dateFormatter.string(from: tomorrowDate)): ↓\(tomorrowMinValue) ↑\(tomorrowMaxValue)"
//                        } else {
//                            // Обработка случая, когда tomorrow пуст или не содержит числовых значений
//                            self.tomorrowLabel.text = "\(dateFormatter.string(from: tomorrowDate)): -"
//                        }
//
//                        // Находим минимальное и максимальное значение для afterday
//                        if let afterdayMin = afterday.min(),
//                           let afterdayMax = afterday.max() {
//                            let numberFormatter = NumberFormatter()
//                            numberFormatter.maximumFractionDigits = 0
//
//                            let afterdayMinValue = "G" + numberFormatter.string(from: NSNumber(value: afterdayMin))!
//                            let afterdayMaxValue = "G" + numberFormatter.string(from: NSNumber(value: afterdayMax))!
//
//                            // Обновляем метку на интерфейсе с минимальными и максимальными значениями
//                            self.dayAfterLabel.text = "\(dateFormatter.string(from: afterTomorrowDate)): ↓\(afterdayMinValue) ↑\(afterdayMaxValue)"
//                        } else {
//                            // Обработка случая, когда afterday пуст или не содержит числовых значений
//                            self.dayAfterLabel.text = "\(dateFormatter.string(from: afterTomorrowDate)): -"
//                        }
//
//                    }
//
//                case .failure(let error):
//                    print("Ошибка при загрузке данных: \(error)")
//                }
//            }
//        }
//    }
    
    private func fetchAndDisplayTextData() {
        fetchStormForecast { result in
            DispatchQueue.main.async { // Обновление интерфейса должно выполняться в основной очереди
                switch result {
                case .success(let parsedData):
                    // Создаем массивы для значений today, tomorrow и afterday
                    var today: [Double] = []
                    var tomorrow: [Double] = []
                    var afterday: [Double] = []
                    
                    // Определяем сегодняшнюю дату
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E, MMM d" // Формат дня недели и даты
                    print("Сегодняшняя дата: \(dateFormatter.string(from: currentDate))")
                    
                    // Вычисляем даты для завтрашнего дня и послезавтрашнего дня
                    if let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate),
                       let afterTomorrowDate = Calendar.current.date(byAdding: .day, value: 2, to: currentDate) {
                        print("Дата завтрашнего дня: \(dateFormatter.string(from: tomorrowDate))")
                        print("Дата послезавтрашнего дня: \(dateFormatter.string(from: afterTomorrowDate))")
                        
                        // Распределяем значения по массивам
                        for dataEntry in parsedData {
                            today.append(dataEntry.values.indices.contains(0) ? dataEntry.values[0] : 0)
                            tomorrow.append(dataEntry.values.indices.contains(1) ? dataEntry.values[1] : 0)
                            afterday.append(dataEntry.values.indices.contains(2) ? dataEntry.values[2] : 0)
                        }
                        
                        print("Значения для today: \(today)")
                        print("Значения для tomorrow: \(tomorrow)")
                        print("Значения для afterday: \(afterday)")
                        
                        // Функция для форматирования значений и обновления меток
                        func updateLabel(label: UILabel, date: Date, values: [Double]) {
                            let numberFormatter = NumberFormatter()
                            numberFormatter.maximumFractionDigits = 0
                            
                            if let minValue = values.min(),
                               let maxValue = values.max() {
                                let minStringValue = "G" + numberFormatter.string(from: NSNumber(value: minValue))!
                                let maxStringValue = "G" + numberFormatter.string(from: NSNumber(value: maxValue))!
                                label.text = "\(dateFormatter.string(from: date)): ↓\(minStringValue) ↑\(maxStringValue)"
                            } else {
                                label.text = "\(dateFormatter.string(from: date)): -"
                            }
                        }
                        // Обновляем метки на интерфейсе
                        updateLabel(label: self.todayLabel, date: currentDate, values: today)
                        updateLabel(label: self.tomorrowLabel, date: tomorrowDate, values: tomorrow)
                        updateLabel(label: self.dayAfterLabel, date: afterTomorrowDate, values: afterday)
                    }
                    
                case .failure(let error):
                    print("Ошибка при загрузке данных: \(error)")
                }
            }
        }
    }

    private func fetchMagneticDataAndUpdateUI() {
        fetchStormValue { [weak self] currentKpValue in
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
                        self?.fetchAndDisplayTextData()
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100000.0 // distance 100km
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
                    feedbackGenerator.selectionChanged() // Добавьте виброотклик
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
                feedbackGenerator.selectionChanged() // Добавьте виброотклик
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
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
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
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
        
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
            feedbackGenerator.selectionChanged() // Добавьте виброотклик
        } else {
            handleSwipeDown(fakeSwipeDownGesture)
            feedbackGenerator.selectionChanged() // Добавьте виброотклик
        }
    }
    // info button action
    @objc private func infoButtonTapped() {
        print("infoButtonTapped")
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
        
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
    //MARK: Animate Description up
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
//MARK: UserNotificationCenter
extension MainViewController {
    private func setupNotificationTimer() {
        // Устанавливаем таймер на 30 секунд
        // let thirtySeconds: TimeInterval = 10.0 // 30 секунд в секундах
        let threeHours: TimeInterval = 3 * 3600 // 3 часа
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: threeHours, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "MagnetStorm"
        content.body = "notification_text".localized()
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
