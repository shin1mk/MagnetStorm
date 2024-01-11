//
//  AppDelegate.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 02.09.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    // didDiscardSceneSessions
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MagnetStorm")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
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
                content.body = "notification_text".localized()
                // Уведомление в 10:00
                var dateComponents12 = DateComponents()
                dateComponents12.hour = 10
                dateComponents12.minute = 0
                let trigger12 = UNCalendarNotificationTrigger(dateMatching: dateComponents12, repeats: true)
                let request12 = UNNotificationRequest(identifier: "dailyNotification12", content: content, trigger: trigger12)
                // Уведомление в 17:00
                var dateComponents18 = DateComponents()
                dateComponents18.hour = 17
                dateComponents18.minute = 00
                let trigger18 = UNCalendarNotificationTrigger(dateMatching: dateComponents18, repeats: true)
                let request18 = UNNotificationRequest(identifier: "dailyNotification18", content: content, trigger: trigger18)

                self.notificationCenter.add(request12) { (error) in
                    if let error = error {
                        print("Ошибка при добавлении уведомления (12:00): \(error.localizedDescription)")
                    }
                }

                self.notificationCenter.add(request18) { (error) in
                    if let error = error {
                        print("Ошибка при добавлении уведомления (18:00): \(error.localizedDescription)")
                    }
                }
            }
        }
        notificationCenter.delegate = self
        return true
    }
} // end
// MARK: - UserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    // didReceive
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }
}
