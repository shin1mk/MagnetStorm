//
//  text.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 03.09.2023.
//

/*
 //MARK: Video
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
 //MARK: Gradient
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

//MARK: - TEXT
/*
 info.plist
 
 Требуется доступ к вашей геопозиции для предоставления актуальных данных о магнитных бурях и их воздействии.
 Access to your location is required to provide up-to-date information on magnetic storms and their effects.
 Потрібен доступ до вашого місцезнаходження для надання актуальної інформації про магнітні бурі та їх вплив.
 */
//MARK: - Description text
/*
 ru
 // 0
 "Отсутствие бури",
 "Влияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь.",
 // 1
 "Слабая буря",
 "Влияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство.",
 // 2
 "Умеренная буря",
 "Влияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне.",
 // 3
 "Сильная буря",
 "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения.",
 // 4
 "Очень сильная буря",
 "Буря может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения.",
 // 5
 "Сильнейшая буря",
 "Влияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей.",
 // 6
 "Буря выдающегося масштаба",
 "На этом уровне симптомы могут стать более выраженными и распространенными. Могут возникать более серьезные головные боли, бессонница и изменения настроения.",
 // 7
 "Буря исключительного масштаба",
 "Буря может вызвать значительное ухудшение физического и эмоционального состояния. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени.",
 // 8
 "Сверхбуря",
 "На этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, бессонницы и серьезное изменение эмоционального состояния.",
 // 9
 "Супербуря",
 "Самый высший уровень активности магнитных бурь, с катастрофическими последствиями для всего организма и технического оборудования в мире."
 
 
 eng
 // 0
 "Absence of a storm",
 "The impact on the human body is practically absent. People do not feel any physical or emotional changes due to the absence of magnetic storms.",
 // 1
 "Weak storm",
 "The impact on a person is very insignificant. Some people with increased sensitivity to magnetic fields may experience slight anxiety.",
 // 2
 "Moderate storm",
 "The impact on the human body remains small. Some people may experience headaches or changes in sleep.",
 // 3
 "Strong storm",
 "The storm can increase the likelihood of physical and emotional symptoms in most people. Headaches, insomnia, and mood swings are possible.",
 // 4
 "Very strong storm",
 "The storm can increase the likelihood of physical and emotional symptoms in most people. Headaches, insomnia, and mood swings are possible.",
 // 5
 "Severe storm",
 "The impact on a person at this level may become more noticeable. Symptoms such as insomnia, headaches, and nervousness may intensify in some people.",
 // 6
 "Exceptional-scale storm",
 "At this level, symptoms may become more pronounced and widespread. More severe headaches, insomnia, and mood swings may occur.",
 // 7
 "Extraordinary-scale storm",
 "The storm can cause significant deterioration in physical and emotional condition. Headaches, insomnia, nervousness, and mood swings may be observed to a significant extent.",
 // 8
 "Superstorm",
 "At this level, the most serious and unpredictable effects on a person are possible. Severe headaches, insomnia, and significant changes in emotional state may occur.",
 // 9
 "Superstorm",
 "The highest level of magnetic storm activity, with catastrophic consequences for the entire human body and technical equipment in the world."
 
 ua
 // 0
 "Відсутність бурі",
 "Вплив на організм людини практично відсутній. Люди не відчувають жодних фізичних чи емоційних змін через відсутність магнітних бурь.",
 // 1
 "Слабка буря",
 "Вплив на людину дуже незначний. Деякі люди з підвищеною чутливістю до магнітних полів можуть відчувати легку тривожність.",
 // 2
 "Середня буря",
 "Вплив на організм людини залишається невеликим. Деякі люди можуть відчувати головні болі або зміни в сні.",
 // 3
 "Сильна буря",
 "Буря може збільшити ймовірність виникнення фізичних та емоційних симптомів у більшості людей. Можливі головні болі, безсоння та зміни настрою.",
 // 4
 "Дуже сильна буря",
 "Буря може збільшити ймовірність виникнення фізичних та емоційних симптомів у більшості людей. Можливі головні болі, безсоння та зміни настрою.",
 // 5
 "Сильнейша буря",
 "Вплив на людину на цьому рівні може стати помітнішим. Симптоми, такі як безсоння, головні болі та нервозність, можуть підсилитися у деяких людей.",
 // 6
 "Буря видатного масштабу",
 "На цьому рівні симптоми можуть стати більш виразними та поширеними. Можуть виникати більш сильні головні болі, безсоння та зміни настрою.",
 // 7
 "Буря виключного масштабу",
 "Буря може викликати значне погіршення фізичного та емоційного стану. Головні болі, безсоння, нервозність та зміни настрою можуть спостерігатися в значній мірі.",
 // 8
 "Супербуря",
 "На цьому рівні можливі найсерйозніші та непередбачувані впливи на людину. Можливі сильні головні болі, безсоння та значні зміни в емоційному стані.",
 // 9
 "Супербуря",
 "Найвищий рівень активності магнітних бурь, з катастрофічними наслідками для всього організму та технічного обладнання в світі."
 
 */
