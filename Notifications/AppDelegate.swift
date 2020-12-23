//
//  AppDelegate.swift
//  Notifications
//
//  Created by Alexey Efimov on 21.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
// Импортируем библиотеку уведомлений
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // Создаём экземпляр класса с уведомлениями
    let notifications = Notifications()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Вызываем метод для запроса уведомлений
        notifications.requestAutorization()
        // Назначаем делегата, чтобы уведомление отображалось при активном приложении
        notifications.notificationCenter.delegate = notifications
        
        return true
    }

    // Метод отслеживающий возвращение в приложение (сообщает делегату, что приложение вновь активно)
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Вызываем метод, который обнудяет счетчик уведомлений на юейдже
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
