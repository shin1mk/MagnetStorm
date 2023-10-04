//
//  ForecastView.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 04.10.2023.
//

import SnapKit
import UIKit

final class ForecastView: UIView {
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    private func setupConstraints() {
        labelsStackView.addArrangedSubview(todayLabel)
        labelsStackView.addArrangedSubview(tomorrowLabel)
        labelsStackView.addArrangedSubview(dayAfterLabel)
        
        addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview() //.
            make.leading.equalToSuperview().offset(1)
            make.trailing.equalToSuperview().offset(1)
            make.bottom.equalToSuperview() //
        }
    }
    
//    public func fetchStormForecastUI() {
//        fetchStormForecast { result in
//            DispatchQueue.main.async { // Обновление интерфейса должно выполняться в основной очереди
//                switch result {
//                case .success(let parsedData):
//                    // Создаем массивы для значений today, tomorrow и afterday
//                    var today: [Double] = []
//                    var tomorrow: [Double] = []
//                    var afterday: [Double] = []
//                    // Определяем сегодняшнюю дату
//                    let currentDate = Date()
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "E, MMM d" // Формат дня недели и даты
//                    print("Сегодняшняя дата: \(dateFormatter.string(from: currentDate))")
//                    // Вычисляем даты для завтрашнего дня и послезавтрашнего дня
//                    if let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate),
//                       let afterTomorrowDate = Calendar.current.date(byAdding: .day, value: 2, to: currentDate) {
//                        print("Дата завтрашнего дня: \(dateFormatter.string(from: tomorrowDate))")
//                        print("Дата послезавтрашнего дня: \(dateFormatter.string(from: afterTomorrowDate))")
//                        // Распределяем значения по массивам
//                        for dataEntry in parsedData {
//                            today.append(dataEntry.values.indices.contains(0) ? dataEntry.values[0] : 0)
//                            tomorrow.append(dataEntry.values.indices.contains(1) ? dataEntry.values[1] : 0)
//                            afterday.append(dataEntry.values.indices.contains(2) ? dataEntry.values[2] : 0)
//                        }
//                        print("Значения для today: \(today)")
//                        print("Значения для tomorrow: \(tomorrow)")
//                        print("Значения для afterday: \(afterday)")
//                        // Функция для форматирования значений и обновления меток
//                        func updateLabel(label: UILabel, date: Date, values: [Double]) {
//                            let numberFormatter = NumberFormatter()
//                            numberFormatter.maximumFractionDigits = 0
//
//                            if let minValue = values.min(),
//                               let maxValue = values.max() {
//                                let minStringValue = "G" + numberFormatter.string(from: NSNumber(value: minValue))!
//                                let maxStringValue = "G" + numberFormatter.string(from: NSNumber(value: maxValue))!
//                                label.text = "\(dateFormatter.string(from: date)): ↓\(minStringValue) ↑\(maxStringValue)"
//                            } else {
//                                label.text = "\(dateFormatter.string(from: date)): -"
//                            }
//                        }
//                        // Обновляем метки на интерфейсе
//                        updateLabel(label: self.todayLabel, date: currentDate, values: today)
//                        updateLabel(label: self.tomorrowLabel, date: tomorrowDate, values: tomorrow)
//                        updateLabel(label: self.dayAfterLabel, date: afterTomorrowDate, values: afterday)
//                    }
//                case .failure(let error):
//                    print("Ошибка при загрузке данных: \(error)")
//                }
//            }
//        }
//    }
    public func fetchStormForecastUI() {
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
                    dateFormatter.dateFormat = "EEEE, d MMM" // Формат дня недели и даты
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

                        // Создаем стековые представления для каждого дня
                                        let stackViewToday = self.createStackView(withDate: currentDate, values: today)
                                        let stackViewTomorrow = self.createStackView(withDate: tomorrowDate, values: tomorrow)
                                        let stackViewAfterday = self.createStackView(withDate: afterTomorrowDate, values: afterday)
                                        
                                        // Добавляем стековые представления на экран
                                        self.addSubview(stackViewToday)
                                        self.addSubview(stackViewTomorrow)
                                        self.addSubview(stackViewAfterday)
                                        
                                        // Устанавливаем ограничения для вертикального расположения стековых представлений
                                        stackViewToday.snp.makeConstraints { make in
                                            make.top.equalToSuperview().offset(10)
                                            make.leading.equalToSuperview().offset(0)
                                            make.trailing.equalToSuperview().offset(0)
                                        }
                                        
                                        stackViewTomorrow.snp.makeConstraints { make in
                                            make.top.equalTo(stackViewToday.snp.bottom).offset(10)
                                            make.leading.equalToSuperview().offset(0)
                                            make.trailing.equalToSuperview().offset(0)
                                        }
                                        
                                        stackViewAfterday.snp.makeConstraints { make in
                                            make.top.equalTo(stackViewTomorrow.snp.bottom).offset(10)
                                            make.leading.equalToSuperview().offset(0)
                                            make.trailing.equalToSuperview().offset(0)
                                        }
                    }
                case .failure(let error):
                    print("Ошибка при загрузке данных: \(error)")
                }
            }
        }
    }
    
    
    private func createStackView(withDate date: Date, values: [Double]) -> UIStackView {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMM"
        
        var datePart = ""
        var valuesPart = ""
        
        if let minValue = values.min(), let maxValue = values.max() {
            datePart = dateFormatter.string(from: date)
            valuesPart = "↓G\(numberFormatter.string(from: NSNumber(value: minValue))!) ↑G\(numberFormatter.string(from: NSNumber(value: maxValue))!)"
        } else {
            datePart = dateFormatter.string(from: date)
            valuesPart = "-"
        }
        
        let dateLabel = UILabel()
        dateLabel.text = datePart
        dateLabel.font = UIFont.SFUITextRegular(ofSize: 20)
        dateLabel.textColor = .white
        
        let valuesLabel = UILabel()
        valuesLabel.text = valuesPart
        valuesLabel.font = UIFont.SFUITextRegular(ofSize: 20)
        valuesLabel.textColor = .white
        valuesLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, valuesLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }

} // end
