//
//  ForecastView.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 04.10.2023.
//

import SnapKit
import UIKit

final class ForecastView: UIView {
    //MARK: Properties
    private var previousStackView: UIStackView?
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARK: update ui
    public func fetchStormForecastUI() {
        fetchStormForecast { result in
            DispatchQueue.main.async { [self] in // Обновление интерфейса должно выполняться в основной очереди
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
                        print("Значения для today: \(today)")
                        print("Значения для tomorrow: \(tomorrow)")
                        print("Значения для afterday: \(afterday)")
                        // вызываем функцию стек констрейнт и выводим в лейблы
                        setupStackConstraints(today: today, tomorrow: tomorrow, afterday: afterday, currentDate: currentDate, tomorrowDate: tomorrowDate, afterTomorrowDate: afterTomorrowDate)
                    }
                case .failure(let error):
                    print("Ошибка при загрузке данных: \(error)")
                }
            }
        }
    }
    //MARK: Costraints
    private func setupStackConstraints(today: [Double], tomorrow: [Double], afterday: [Double], currentDate: Date, tomorrowDate: Date, afterTomorrowDate: Date) {
        // Создаем стековые представления для каждого дня
        let stackViewToday = createStackView(withDate: currentDate, values: today)
        let stackViewTomorrow = createStackView(withDate: tomorrowDate, values: tomorrow)
        let stackViewAfterday = createStackView(withDate: afterTomorrowDate, values: afterday)
        // Устанавливаем ограничения для вертикального расположения стековых представлений
        addSubview(stackViewToday)
        stackViewToday.distribution = .fillEqually
        stackViewToday.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
        }
        addSubview(stackViewTomorrow)
        stackViewTomorrow.distribution = .fillEqually
        stackViewTomorrow.snp.makeConstraints { make in
            make.top.equalTo(stackViewToday.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
        }
        addSubview(stackViewAfterday)
        stackViewAfterday.distribution = .fillEqually
        stackViewAfterday.snp.makeConstraints { make in
            make.top.equalTo(stackViewTomorrow.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
        }
    }
    //MARK: Labels number/date formatter
    private func createStackView(withDate date: Date, values: [Double]) -> UIStackView {
        // Создаем NumberFormatter для форматирования числовых значений
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        // Создаем DateFormatter для форматирования даты
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, d MMMM" // Формат дня недели и даты
        
        var datePart = ""
        var valuesPart = ""
        // Проверяем, есть ли минимальное и максимальное значения в массиве values
        if let minValue = values.min(), let maxValue = values.max() {
            // Форматируем дату
            datePart = dateFormatter.string(from: date)
            // Форматируем минимальное и максимальное значения
            valuesPart = "↓G\(numberFormatter.string(from: NSNumber(value: minValue))!) ↑G\(numberFormatter.string(from: NSNumber(value: maxValue))!)"
        } else {
            // Если нет минимальных и максимальных значений, используем дату и знак "-"
            datePart = dateFormatter.string(from: date)
            valuesPart = "-"
        }
        // Создаем метку для отображения даты
        let dateLabel = UILabel()
        dateLabel.text = datePart
        dateLabel.font = UIFont.SFUITextRegular(ofSize: 19)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .left

        // Создаем метку для отображения значений
        let valuesLabel = UILabel()
        valuesLabel.text = valuesPart
        valuesLabel.font = UIFont.SFUITextRegular(ofSize: 19)
        valuesLabel.textColor = .white
        valuesLabel.textAlignment = .right
        // Создаем горизонтальный стековый контейнер и добавляем в него метки
        let stackView = UIStackView(arrangedSubviews: [dateLabel, valuesLabel])
        stackView.axis = .horizontal // Располагаем элементы горизонтально
        stackView.alignment = .fill // Выравниваем элементы по высоте
        stackView.distribution = .fill // Равномерно распределяем элементы
        stackView.spacing = 10 // Устанавливаем расстояние между элементами
        
        return stackView
    }
} // end
