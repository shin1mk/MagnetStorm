//
//  text.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 03.09.2023.
//

/*
 G0 (Отсутствие бури): Влияние на организм человека практически отсутствует. Люди не ощущают никаких физических или эмоциональных изменений из-за отсутствия магнитных бурь.
 G1 (Слабая буря): Влияние на человека очень незначительное. Некоторые люди с повышенной чувствительностью к магнитным полям могут замечать легкое беспокойство.
 G2 (Умеренная буря): Влияние на организм человека все равно остается небольшим. Некоторые люди могут испытывать головные боли или изменения в сне.
 G3 (Сильная буря): Этот уровень бури может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения у чувствительных людей.
 G4 (Очень сильная буря): Этот уровень бури может повысить вероятность появления физических и эмоциональных симптомов у большинства людей. Возможны головные боли, бессонница, ухудшение настроения особенно у чувствительных людей.
 G5 (Сильнейшая буря): Влияние на человека на этом уровне может стать более заметным. Могут усилиться симптомы, такие как бессонница, головные боли и нервозность у некоторых людей.
 G6 (Буря выдающегося масштаба): На этом уровне симптомы могут стать более выраженными и распространенными. У людей, более чувствительных к магнитным полям, могут возникать более серьезные головные боли, бессонница и изменения настроения.
 G7 (Буря исключительного масштаба): Этот уровень бури может вызвать значительное ухудшение физического и эмоционального состояния у большого числа людей. Головные боли, бессонница, нервозность и ухудшение настроения могут наблюдаться в значительной степени.
 G8 (Сверхбуря): На этом уровне возможны самые серьезные и неопределенные воздействия на человека. Могут возникать сильные головные боли, усиление бессонницы и серьезное изменение эмоционального состояния.
 
 
 укр
 G0 (Відсутність бурі): Вплив на організм людини практично відсутній. Люди не відчувають ніяких фізичних або емоційних змін через відсутність магнітних бурь.
 G1 (Слабка буря): Вплив на людину дуже незначний. Деякі люди з підвищеною чутливістю до магнітних полів можуть помічати легку тривожність.
 G2 (Помірна буря): Вплив на організм людини все ж залишається незначним. Деякі люди можуть відчувати головні болі або зміни у сні.
 G3 (Сильна буря): Цей рівень бурі може підвищити ймовірність фізичних і емоційних симптомів у більшості людей. Можливі головні болі, безсоння, погіршення настрою у чутливих людей.
 G4 (Дуже сильна буря): Цей рівень бурі також може підвищити ймовірність фізичних і емоційних симптомів у більшості людей. Можливі головні болі, безсоння та погіршення настрою, особливо у чутливих людей.
 G5 (Найсильніша буря): Вплив на людину на цьому рівні може стати помітнішим. Можуть підсилитися симптоми, такі як безсоння, головні болі та нервозність у деяких людей.
 G6 (Буря надзвичайного масштабу): На цьому рівні симптоми можуть стати більш виразними та поширеними. У людей, які більше чутливі до магнітних полів, можуть виникати серйозні головні болі, безсоння та зміни настрою.
 G7 (Буря виняткового масштабу): Цей рівень бурі може спричинити значне погіршення фізичного та емоційного стану багатьох людей. Головні болі, безсоння, нервозність та погіршення настрою можуть спостерігатися в значній мірі.
 G8 (Супербуря): На цьому рівні можливі найсерйозніші та непередбачувані впливи на людину. Можуть виникати сильні головні болі, загострення безсоння та серйозні зміни емоційного стану.
 
 
 eng
 G0 (No Storm): The impact on the human body is practically nonexistent. People do not experience any physical or emotional changes due to the absence of magnetic storms.
 G1 (Minor Storm): The influence on a person is very slight. Some individuals with heightened sensitivity to magnetic fields may notice mild discomfort.
 G2 (Moderate Storm): The impact on the human body remains small. Some people may experience headaches or changes in sleep patterns.
 G3 (Strong Storm): This level of storm can increase the likelihood of physical and emotional symptoms in most individuals. Headaches, insomnia, and worsened mood are possible, especially in sensitive individuals.
 G4 (Severe Storm): This level of storm can also increase the likelihood of physical and emotional symptoms in most individuals. Headaches, insomnia, and worsened mood are possible, particularly in sensitive individuals.
 G5 (Extreme Storm): The impact on a person can become more noticeable at this level. Symptoms such as insomnia, headaches, and nervousness may intensify in some individuals.
 G6 (Exceptional Storm): At this level, symptoms can become more pronounced and widespread. People who are more sensitive to magnetic fields may experience more severe headaches, insomnia, and mood swings.
 G7 (Exceptional Storm): This level of storm can cause significant deterioration in the physical and emotional state of a large number of people. Headaches, insomnia, nervousness, and worsened mood can be observed to a considerable extent.
 G8 (Superstorm): At this level, the most serious and unpredictable effects on a person are possible. Severe headaches, intensified insomnia, and significant changes in emotional state may occur.

 
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
 
 
 
 
 
 
 
 
 
 
*/
