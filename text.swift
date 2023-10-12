
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
 
 
 
 
 
 
 
 
 
 
 достаем из прогноза текущее значение
 public func fetchStormForecastUI() {
     fetchStormForecast { result in
         DispatchQueue.main.async { [self] in
             switch result {
             case .success(let parsedData):
                 // Создаем массивы для значений today, tomorrow и afterday
                 var today: [Double] = []
                 var tomorrow: [Double] = []
                 var afterday: [Double] = []

                 // Распределяем значения по массивам
                 for dataEntry in parsedData {
                     today.append(dataEntry.values.indices.contains(0) ? dataEntry.values[0] : 0)
                     tomorrow.append(dataEntry.values.indices.contains(1) ? dataEntry.values[1] : 0)
                     afterday.append(dataEntry.values.indices.contains(2) ? dataEntry.values[2] : 0)
                 }

                 // Определяем текущее время
                 let currentDate = Date()
                 let calendar = Calendar.current
                 let hour = calendar.component(.hour, from: currentDate)

                 // Определяем соответствующее значение
                 var valueForCurrentTime: Double = 0
                 if hour < today.count {
                     valueForCurrentTime = today[hour]
                 } else if hour < today.count + tomorrow.count {
                     valueForCurrentTime = tomorrow[hour - today.count]
                 } else if hour < today.count + tomorrow.count + afterday.count {
                     valueForCurrentTime = afterday[hour - today.count - tomorrow.count]
                 }

                 // Пример отображения значения в UILabel
                 print("Значение в \(hour) часов: \(valueForCurrentTime)")

                 // Вывод значения в консоль
                 print("Значение в \(hour) часов: \(valueForCurrentTime)")

                 // Вызываем функцию стек констрейнт и выводим значения в интерфейс
                 setupStackConstraints(today: today, tomorrow: tomorrow, afterday: afterday, currentDate: currentDate, valueForCurrentTime: valueForCurrentTime)

             case .failure(let error):
                 print("Ошибка при загрузке данных: \(error)")
             }
         }
     }
 }

 // Функция для установки констрейнтов и отображения данных в интерфейсе
 func setupStackConstraints(today: [Double], tomorrow: [Double], afterday: [Double], currentDate: Date, valueForCurrentTime: Double) {
     // Здесь вы можете установить констрейнты и обновить интерфейс с текущим временем и соответствующим значением
 }

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
