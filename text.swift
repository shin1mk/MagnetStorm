
/*
 
 48,518923
 35,02471
 
 задачи
 Добавить процент северного сияния
 достанем температуру солнца онлайн
 
 
 на forecastview controller добавить источник? 
 добавить локализацию
 Сделать кликабельным прогноз в контроллер
 Добавить погоду тоже кликабельную
 Добавить температуру состояние ветер
 Добавить темперутуру
 
 // добавим все данные как на первом экране и выводить данные в гигаватах
 // поставить время обновления на обоих экранах
 // добавить скролл вью
 // добавить инфо вью
 
 
 
 
 
 
 
 
 
 
 
 
 let progressBar = UIProgressView(progressViewStyle: .default)

// Настраиваем прозрачный фон для прогресс-бара
progressBar.backgroundColor = .clear

// Создаем градиентный слой
let gradientLayer = InfoViewController.createGradientLayer()

// Настраиваем прогресс-бар
progressBar.transform = CGAffineTransform(rotationAngle: -.pi / 2) // Поворачиваем на 90 градусов против часовой стрелки
progressBar.progress = 0.5 // Устанавливаем начальное значение (0.0 - 1.0)
progressBar.frame = CGRect(x: 50, y: 100, width: 1000, height: 20) // Установите нужные координаты и размеры

// Создаем изображение с градиентом
if let gradientImage = createGradientImage(withLayer: gradientLayer, size: progressBar.bounds.size) {
    // Устанавливаем градиентное изображение как progressTintColor
    progressBar.progressTintColor = UIColor(patternImage: gradientImage)
} else {
    // Если не удалось создать изображение, установите цвет по умолчанию или выполните другие действия по вашему выбору
    progressBar.progressTintColor = .green // Пример цвета по умолчанию
}

// Устанавливаем прогресс-бар на экран и настраиваем ограничения с использованием SnapKit
view.addSubview(progressBar)
progressBar.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.equalTo(20)
    make.height.equalTo(200)
}

}

 private func fetchMagneticDataAndUpdateUI() {
     fetchMagneticData { [weak self] currentKpValue in
         DispatchQueue.main.async {
             var state: GeomagneticActivityState = .unknown
             var intValue = 0 // Объявляем intValue за пределами блока if и инициализируем его значением по умолчанию
             
             if let kpValue = currentKpValue, let convertedValue = Int(kpValue) {
                 intValue = convertedValue // Присваиваем значение переменной intValue
                 switch convertedValue {
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
             
             // Определите диапазон значений состояний
             let minValue = 0
             let maxValue = 9
             
             // Определите текущее состояние (например, текущее значение kpValue)
             let currentValue = intValue // Используем значение intValue
             
             // Вычислите процентное значение на основе текущего состояния
             let percentage = Float(currentValue - minValue) / Float(maxValue - minValue)
             
             // Установите прогресс в UIProgressView
             self?.progressBar.progress = percentage
         }
     }
 }
 
 
 extension InfoViewController {
     static let gradientColors: [UIColor] = [
         UIColor(red: 173/255, green: 255/255, blue: 47/255, alpha: 1.0),
         UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 0/255, green: 200/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 0/255, green: 150/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 139/255, green: 0/255, blue: 0/255, alpha: 1.0),
         UIColor(red: 80/255, green: 0/255, blue: 0/255, alpha: 1.0)
     ]

     static func createGradientLayer() -> CAGradientLayer {
         let gradientLayer = CAGradientLayer()
         gradientLayer.colors = gradientColors.map { $0.cgColor }
         gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
         gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
         return gradientLayer
     }
 }
 
 
 
 
 таблица
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // Количество строк в таблице - количество временных интервалов
     return geomagneticDataForDays[section].timeIntervals.count
 }

 func numberOfSections(in tableView: UITableView) -> Int {
     // Количество секций в таблице - количество дней
     return geomagneticDataForDays.count
 }

 
 func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     // Заголовок секции - дата
     return geomagneticDataForDays[section].date
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "GeomagneticCell", for: indexPath)
     
     let data = geomagneticDataForDays[indexPath.section]
     let timeIntervals = Array(data.timeIntervals.keys)
     let interval = timeIntervals[indexPath.row]
     let value = data.timeIntervals[interval] ?? 0.0
     
     // Отобразите данные в ячейке
     cell.textLabel?.text = "\(interval): \(value)"
     
     return cell
 }
 // Создаем модель данных для одного дня
 struct GeomagneticActivityData {
     let date: String
     let timeIntervals: [String: Double]
 }
 
 // Создаем массив данных для каждого дня
 var geomagneticDataForDays: [GeomagneticActivityData] = [
     GeomagneticActivityData(date: "Oct 02", timeIntervals: ["00-03UT": 1.33, "03-06UT": 2.00, /* Другие временные интервалы */]),
     GeomagneticActivityData(date: "Oct 03", timeIntervals: ["00-03UT": 3.33, "03-06UT": 4.00, /* Другие временные интервалы */]),
     GeomagneticActivityData(date: "Oct 04", timeIntervals: ["00-03UT": 2.33, "03-06UT": 2.67, /* Другие временные интервалы */])
 ]
 private lazy var tableView: UITableView = {
     let tableView = UITableView()
     tableView.delegate = self
     tableView.dataSource = self
     // Убедитесь, что вы используете self.view.frame.width и self.view.frame.height
     tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
     self.view.addSubview(tableView)
     tableView.register(UITableViewCell.self, forCellReuseIdentifier: "GeomagneticCell")
     return tableView
 }()


 
 

*/
