/*
 48,518923
 35,02471
 
 // MARK: - UserNotificationCenter
 let notificationCenter = UNUserNotificationCenter.current()
 // didFinishLaunchingWithOptions
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
         guard granted else { return }
         self.notificationCenter.getNotificationSettings { (settings) in
             guard settings.authorizationStatus == .authorized else { return }
             
             // Уведомление будет отправлено каждый день
             let content = UNMutableNotificationContent()
             content.title = "MagnetStorm"
             content.body = "\(NSLocalizedString("notification_text", comment: ""))"
             // Уведомление в 10:00
             var dateComponents10 = DateComponents()
             dateComponents10.hour = 10
             dateComponents10.minute = 0
             let trigger10 = UNCalendarNotificationTrigger(dateMatching: dateComponents10, repeats: true)
             let request10 = UNNotificationRequest(identifier: "dailyNotification10", content: content, trigger: trigger10)
             // Уведомление в 16:00
             var dateComponents16 = DateComponents()
             dateComponents16.hour = 16
             dateComponents16.minute = 0
             let trigger16 = UNCalendarNotificationTrigger(dateMatching: dateComponents16, repeats: true)
             let request16 = UNNotificationRequest(identifier: "dailyNotification16", content: content, trigger: trigger16)
             
             self.notificationCenter.add(request10) { (error) in
                 if let error = error {
                     print("Ошибка при добавлении уведомления (10:00): \(error.localizedDescription)")
                 } else {
                     print("Уведомление (10:00) успешно установлено")
                 }
             }
             
             self.notificationCenter.add(request16) { (error) in
                 if let error = error {
                     print("Ошибка при добавлении уведомления (16:00): \(error.localizedDescription)")
                 } else {
                     print("Уведомление (16:00) успешно установлено")
                 }
             }
         }
     }
     notificationCenter.delegate = self
     return true
 }
 
 
 Track magnetic storms, get forecasts with MagnetStorm. Be prepared for the appearance of the Northern Lights!
 Small improvements and add notifications.
 
 
 
 private let buyButton: UIButton = {
     let button = UIButton()
     button.setTitle("\(NSLocalizedString("support_text", comment: ""))", for: .normal)
     button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
     button.setTitleColor(.white, for: .normal)
     button.backgroundColor = .systemBlue
     button.layer.cornerRadius = 10
     return button
 }()
 private let letterButton: UIButton = {
     let button = UIButton()
     button.setTitle("\(NSLocalizedString("letter_text", comment: ""))", for: .normal)
     button.titleLabel?.font = UIFont.SFUITextMedium(ofSize: 16)
     button.setTitleColor(.white, for: .normal)
     button.backgroundColor = .systemBlue
     button.layer.cornerRadius = 10
     return button
 }()
 @objc private func buyButtonTapped() {
     if let url = URL(string: "https://www.buymeacoffee.com/shininswift") {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
     }
 }
 private func addTarget() {
 buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
 letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
 }
 
 @objc private func letterButtonTapped() {
     let recipient = "shininswift@gmail.com"
     let subject = "NemaOkupantiv🇺🇦Співпраця/побажання."

     let urlString = "mailto:\(recipient)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

     if let url = URL(string: urlString ?? "") {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
     }
 }
 
 contentView.addSubview(buyButton)
 buyButton.snp.makeConstraints { make in
     make.top.equalTo(rateButton.snp.bottom).offset(10)
     make.leading.trailing.equalToSuperview().inset(15)
     make.height.equalTo(40)
 }
 contentView.addSubview(letterButton)
 letterButton.snp.makeConstraints { make in
     make.top.equalTo(buyButton.snp.bottom).offset(10)
     make.leading.trailing.equalToSuperview().inset(15)
     make.height.equalTo(40)
 }
 
 
 private let sourceButton: UIButton = {
     let button = UIButton()
     button.setTitle("NOAA Space Weather Prediction Center", for: .normal)
     button.setTitleColor(.systemBlue, for: .normal)
     button.titleLabel?.font = UIFont.SFUITextRegular(ofSize: 14)
     button.titleLabel?.numberOfLines = 0
     return button
 }()    
 // source button
 @objc private func openNOAALink() {
     if let url = URL(string: "https://www.swpc.noaa.gov/products/3-day-forecast") {
         let safariViewController = SFSafariViewController(url: url)
         present(safariViewController, animated: true, completion: nil)
     }
 }
 
 
 // source button
 @objc private func openNOAALink() {
     if let url = URL(string: "https://www.swpc.noaa.gov/products/planetary-k-index") {
         let safariViewController = SFSafariViewController(url: url)
         present(safariViewController, animated: true, completion: nil)
     }
 }
 
 @objc private func rateButtonTapped() {
     if let url = URL(string: "https://apps.apple.com/us/app/magnetstorm/id6468251721") {
         let safariViewController = SFSafariViewController(url: url)
         present(safariViewController, animated: true, completion: nil)
     }
 }
 
 if let url = URL(string: "https://www.swpc.noaa.gov/products/aurora-30-minute-forecast") {

 @objc private func openNOAALink() {
     if let url = URL(string: "https://www.swpc.noaa.gov/communities/aurora-dashboard-experimental") {
         let safariViewController = SFSafariViewController(url: url)
         present(safariViewController, animated: true, completion: nil)
     }
 }
 
 @objc private func rateButtonTapped() {
     if let url = URL(string: "https://apps.apple.com/us/app/magnetstorm/id6468251721") {
         let safariViewController = SFSafariViewController(url: url)
         present(safariViewController, animated: true, completion: nil)
     }
 }
 */
