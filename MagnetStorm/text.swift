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
 */
