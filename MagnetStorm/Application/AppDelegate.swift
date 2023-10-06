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
    // didFinishLaunchingWithOptions
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        return true
//    }
    // MARK: - UserNotificationCenter
    let notificationCenter = UNUserNotificationCenter.current()
    // didFinishLaunchingWithOptions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }

                // Разрешение на уведо  мления получено, теперь можно установить таймер
                self.setupNotificationTimer()
            }
        }
        notificationCenter.delegate = self
        return true
    }
    // Установка таймера на уведомление
    func setupNotificationTimer() {
        // Устанавливаем таймер на 3 часа
        let threeHours: TimeInterval = 3 * 3600 // 3 часа

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: threeHours, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "MagnetStorm"
        content.body = "notification_text".localized()
        // Добавляем стандартную вибрацию и звук
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: "UpdateData", content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Ошибка при установке таймера: \(error)")
            } else {
                print("Таймер на уведомление установлен успешно.")
            }
        }
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
