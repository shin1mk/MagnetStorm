//
//  ForecastViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 08.10.2023.
//

import UIKit
import SnapKit

final class ForecastViewController: UIViewController {
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    private let forecastView = ForecastView()
    private let timeLabels = ["00:00", "03:00", "06:00", "09:00", "12:00", "15:00", "18:00", "21:00"]
    private var today: [Double] = []
    private var tomorrow: [Double] = []
    private var afterday: [Double] = []
    
    private let forecastLabel: UILabel = {
        let forecastLabel = UILabel()
        forecastLabel.text = "Forecast for 3 days"
        forecastLabel.font = UIFont.SFUITextHeavy(ofSize: 24)
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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        fetchStormDetailForecastUI()
    }
    
    private func setupConstraints() {
        view.backgroundColor = .black
        // gray background
        view.addSubview(backgroundView)
        backgroundView.layer.zPosition = 100 // z-index
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
        view.addSubview(forecastLabel)
        forecastLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.black
        tableView.snp.makeConstraints { make in
            make.top.equalTo(forecastLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
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
                        print("detail for today: \(today)")
                        print("detail for tomorrow: \(tomorrow)")
                        print("detail for afterday: \(afterday)")
                        tableView.reloadData()
                    }
                case .failure(let error):
                    print("Ошибка при загрузке данных: \(error)")
                }
            }
        }
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
        cell.todayValueLabel.text = "G\(todayValue)"
        cell.tomorrowValueLabel.text = "G\(tomorrowValue)"
        cell.afterdayValueLabel.text = "G\(afterdayValue)"
        cell.backgroundColor = .black //

        return cell
    }
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedbackGenerator.selectionChanged() // Добавьте виброотклик
        
        let descriptionViewController = DescriptionViewController()
        descriptionViewController.modalPresentationStyle = .popover
        present(descriptionViewController, animated: true, completion: nil)
        
        // Опционально, вы можете снять выделение с ячейки после нажатия
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // view for header in section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.textColor = .white // Цвет текста заголовка
        label.font = UIFont.SFUITextBold(ofSize: 18) // Жирный шрифт
        label.textAlignment = .right // Выравнивание текста справа
        
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
                label.text = "\(todayDate)   \(tomorrowString)   \(afterTomorrowString)"
            } else {
                label.text = todayDate
            }
        default:
            label.text = nil
        }
        
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(0) // Отступ справа
            make.centerY.equalToSuperview() // Выравнивание по вертикали
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Возвращайте высоту ячейки, которая соответствует вашим потребностям.
        return 40.0 // Пример фиксированной высоты, замените ее на вашу логику
    }
}
