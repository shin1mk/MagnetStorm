//
//  ForecastViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 08.10.2023.
//

import UIKit
import SnapKit
import Charts
import SafariServices

final class ForecastViewController: UIViewController {
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let forecastView = ForecastView()
    private let timeLabels = ["00:00", "03:00", "06:00", "09:00", "12:00", "15:00", "18:00", "21:00"]
    private var today: [Double] = []
    private var tomorrow: [Double] = []
    private var afterday: [Double] = []
    private let lineChartView = LineChartView()

    private let forecastLabel: UILabel = {
        let forecastLabel = UILabel()
        forecastLabel.text = "forecast3days_text".localized()
        forecastLabel.font = UIFont.SFUITextMedium(ofSize: 25)
        forecastLabel.textColor = .white
        return forecastLabel
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.black
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "ForecastTableViewCell")
        return tableView
    }()
    private let subtractImageView = UIImageView(image: UIImage(named: "subtract"))
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7)
        return view
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        fetchStormDetailForecastUI()
    }
    //MARK: Methods
    private func setupConstraints() {
        view.backgroundColor = .black
        // gray background
        view.addSubview(backgroundView)
        backgroundView.layer.zPosition = 100
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(50)
        }
        // substract
        backgroundView.addSubview(subtractImageView)
        subtractImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundView)
            make.top.equalTo(backgroundView.snp.top).offset(-24)
        }
        // title label
        view.addSubview(forecastLabel)
        forecastLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
        }
        // таблица
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(forecastLabel.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-300)
        }
        // график
        view.addSubview(lineChartView)
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20) // Расположите график ниже tableView
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    //MARK: forecast detail
    private func fetchStormDetailForecastUI() {
        fetchStormForecast { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let parsedData):
                    // Очистить существующие данные
                    today.removeAll()
                    tomorrow.removeAll()
                    afterday.removeAll()

                    // Определяем сегодняшнюю дату
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE, d MMM" // Формат дня недели и даты
                    print("Сегодняшняя дата: \(dateFormatter.string(from: currentDate))")

                    // Вычисляем даты для завтрашнего дня и послезавтрашнего дня
                    if let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) {
                        print("Дата завтрашнего дня: \(dateFormatter.string(from: tomorrowDate))")
                 
                        // Распределяем значения по массивам
                        for dataEntry in parsedData {
                            today.append(dataEntry.values.indices.contains(0) ? dataEntry.values[0] : 0)
                            tomorrow.append(dataEntry.values.indices.contains(1) ? dataEntry.values[1] : 0)
                            afterday.append(dataEntry.values.indices.contains(2) ? dataEntry.values[2] : 0)
                        }
                        // Проверка и обрезка массивов до 8 элементов
                        if today.count > 8 {
                            today = Array(today.prefix(8))
                        }
                        if tomorrow.count > 8 {
                            tomorrow = Array(tomorrow.prefix(8))
                        }
                        if afterday.count > 8 {
                            afterday = Array(afterday.prefix(8))
                        }
                        print("detail for today: \(today)")
                        print("detail for tomorrow: \(tomorrow)")
                        print("detail for afterday: \(afterday)")
                        tableView.reloadData()
                        setupLineChart()
                    }
                case .failure(let error):
                    print("Ошибка при загрузке данных: \(error)")
                }
            }
        }
    }
    //MARK: Chart
    private func setupLineChart() {
        // Настройка свойств графика
        configureChartProperties()
        // Создание данных для "today", "tomorrow" и "afterday"
        let todayChartDataSet = createChartDataSet(data: today, label: "chartToday_text".localized(), color: .systemBlue)
        let tomorrowChartDataSet = createChartDataSet(data: tomorrow, label: "chartTomorrow_text".localized(), color: .systemRed)
        let afterdayChartDataSet = createChartDataSet(data: afterday, label: "chartAfterday_text".localized(), color: .systemGreen)
        // Создание набора данных, объединяя данные для "today", "tomorrow" и "afterday"
        let chartData = LineChartData(dataSets: [todayChartDataSet, tomorrowChartDataSet, afterdayChartDataSet])
        // Установка данных для графика без анимации
        self.lineChartView.data = chartData

        let xAxis = lineChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: timeLabels)
        xAxis.labelPosition = .top
        xAxis.labelCount = timeLabels.count
        xAxis.granularity = 1.0
    }
    // фон графика
    private func configureChartProperties() {
        lineChartView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        lineChartView.center = view.center
        lineChartView.backgroundColor = .black
    }
    // загружаем данные в график
    private func createChartDataSet(data: [Double], label: String, color: UIColor) -> LineChartDataSet {
        var dataEntries: [ChartDataEntry] = []
        for (index, value) in data.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index), y: value)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: label)
        chartDataSet.colors = [color]
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .cubicBezier

        return chartDataSet
    }
} // end
//MARK: Table view
extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    // number of row in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return today.count
    }
    // cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        let todayValue = today[indexPath.row]
        let tomorrowValue = tomorrow[indexPath.row]
        let afterdayValue = afterday[indexPath.row]

        let timeLabel = timeLabels[indexPath.row % timeLabels.count]

        cell.timeLabel.text = timeLabel
        cell.todayValueLabel.text = "\(todayValue)"
        cell.tomorrowValueLabel.text = "\(tomorrowValue)"
        cell.afterdayValueLabel.text = "\(afterdayValue)"
        cell.backgroundColor = .black

        return cell
    }
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // did select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // view for header in section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black
        
        let dataLabel = UILabel()
        dataLabel.textColor = .white // Цвет текста заголовка
        dataLabel.font = UIFont.SFUITextMedium(ofSize: 18) // Жирный шрифт
        dataLabel.textAlignment = .center // Выравнивание текста справа
        
        switch section {
        case 0:
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM" // Формат дня недели и даты
            let todayDate = dateFormatter.string(from: currentDate)
            
            let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            let afterTomorrowDate = Calendar.current.date(byAdding: .day, value: 2, to: currentDate)
            
            if let tomorrowDate = tomorrowDate, let afterTomorrowDate = afterTomorrowDate {
                let tomorrowString = dateFormatter.string(from: tomorrowDate)
                let afterTomorrowString = dateFormatter.string(from: afterTomorrowDate)
                dataLabel.text = "\(todayDate)   \(tomorrowString)   \(afterTomorrowString)"
            } else {
                dataLabel.text = todayDate
            }
        default:
            dataLabel.text = nil
        }
        
        headerView.addSubview(dataLabel)
        dataLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10) // Отступ справа
            make.centerY.equalToSuperview() // Выравнивание по вертикали
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
