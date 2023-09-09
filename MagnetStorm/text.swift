//
//  text.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 03.09.2023.
//

/*
 
 изменено
 var descriptionText: String {
     switch self {
     case .noStorm: // 0
         return "Отсутствие бури:\nВлияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь."
     case .minorStorm: // 1
         return "Слабая буря:\nВлияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство."
     case .weakStorm: // 2
         return "Умеренная буря:\nВлияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне."
     case .moderateStorm: // 3
         return "Сильная буря:\nБуря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения."
     case .strongStorm: // 4
         return "Очень сильная буря:\nБуря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения."
     case .severeStorm: // 5
         return "Сильнейшая буря:\nВлияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей."
     case .extremeStorm: // 6
         return "Буря выдающегося масштаба:\nНа этом уровне симптомы могут стать более выраженными и распространенными. Могут возникать более серьезные головные боли, бессонница и изменения настроения."
     case .outstandingStorm: // 7
         return "Буря исключительного масштаба:\nБуря может вызвать значительное ухудшение физического и эмоционального состояния. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени."
     case .exceptionalStorm: // 8
         return "Сверхбуря:\nНа этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, бессонницы и серьезное изменение эмоционального состояния."
     case .superstorm: // 9
         return "Супербуря:\nСамый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире."
     case .unknown:
         return "Неизвестно"
     }
 }
 //MARK: Video
 //    private func setupVideoBackground() {
 //        guard let videoURL = Bundle.main.url(forResource: "video_background", withExtension: "mp4") else {
 //            print("Failed to locate video file.")
 //            return
 //        }
 //
 //        let videoPlayer = AVPlayer(url: videoURL)
 //        let videoLayer = AVPlayerLayer(player: videoPlayer)
 //
 //        videoLayer.videoGravity = .resizeAspectFill
 //        videoLayer.frame = view.bounds
 //        // Добавляем видеослой как нижний слой
 //        view.layer.insertSublayer(videoLayer, at: 0)
 //
 //        videoPlayer.play()
 //    }
 // Теперь добавляем слой для видеофона прям в констрейнты вниз
 //        setupVideoBackground()
 //MARK: animation
 //анимация плавного появления
 // это во вью дид лоад
 //descriptionLabel.alpha = 0.0 // Начально скрываем label
 //
 //private func animateDescriptionLabelAppearance(withText text: String) {
 //    descriptionLabel.text = "" // Очищаем текст перед анимацией
 //    descriptionLabel.alpha = 0.0 // Начинаем с нулевой прозрачности
 //
 //    // Создаем анимацию появления текста по буквам
 //    UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveLinear], animations: { [weak self] in
 //        text.forEach { char in
 //            self?.descriptionLabel.text?.append(char)
 //            self?.descriptionLabel.alpha = 1.0
 //        }
 //    }, completion: nil)
 //}
 //self?.animateDescriptionLabelAppearance(withText: state.descriptionText)

 
 
 
 //MARK: Video Background
 //import AVKit

 //    private var videoPlayer: AVPlayer?

 @objc private func appDidEnterBackground() {
     // Приложение свернуто
      videoPlayer?.pause()
 }
 @objc private func appWillEnterForeground() {
     // Приложение будет восстановлено
      videoPlayer?.play()
 }
 
 private func setupVideoBackground() {
     guard let videoURL = Bundle.main.url(forResource: "video_background2", withExtension: "mp4") else {
         print("Failed to locate video file.")
         return
     }
     let videoPlayer = AVPlayer(url: videoURL)
     let videoLayer = AVPlayerLayer(player: videoPlayer)
     
     videoLayer.videoGravity = .resizeAspectFill
     videoLayer.frame = view.bounds
     // Добавляем видеослой как нижний слой
     view.layer.insertSublayer(videoLayer, at: 0)
     // Зацикливаем видео
     NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: nil) { _ in
         videoPlayer.seek(to: CMTime.zero)
         videoPlayer.play()
     }
     videoPlayer.play()
 }
 
 
 
 
 //MARK: GIF Background
 private func setupAnimatedGIFBackground() {
     // Создаем SDAnimatedImageView
     let gifImageView = SDAnimatedImageView(frame: view.bounds)
     if let gifURL = Bundle.main.url(forResource: "background_gif", withExtension: "gif") {
         gifImageView.sd_setImage(with: gifURL)
     }
     view.addSubview(gifImageView) // Добавляем imageView на ваш экран
     view.sendSubviewToBack(gifImageView) // Отправляем его на задний план
 }
 
 
 
 
 
 
 
 
 private func setupGradientStripe() {
     // Создаем градиентный слой
     let gradientLayer = CAGradientLayer()
     gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 5) // Высота и ширина полосы

     // Определяем цвета градиента
     gradientLayer.colors = [
         UIColor.green.cgColor,
         UIColor.yellow.cgColor,
         UIColor.orange.cgColor,
         UIColor.red.cgColor
     ]

     gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Начальная точка градиента
     gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5) // Конечная точка градиента
     gradientLayer.cornerRadius = 2.5 // Половина высоты (5 / 2)

     // Создаем контейнерное представление для полосы градиента
     let gradientContainerView = UIView()
     gradientContainerView.backgroundColor = .clear // Прозрачный фон
     gradientContainerView.layer.addSublayer(gradientLayer) // Добавляем градиентный слой в контейнер

     view.addSubview(gradientContainerView)

     // Устанавливаем ограничения для размещения контейнера под geomagneticActivityLabel
     gradientContainerView.snp.makeConstraints { make in
         make.top.equalTo(geomagneticActivityLabel.snp.bottom).offset(5) // Располагаем контейнер под меткой активности
         make.leading.equalToSuperview().offset(15) // Отступ слева
         make.trailing.equalToSuperview().offset(15) // Отступ справа (не больше, чем -15)
         make.centerX.equalToSuperview() // Центрируем контейнер горизонтально
         make.height.equalTo(5) // Высота контейнера (такая же, как у полосы)
     }


 }
 
*/
