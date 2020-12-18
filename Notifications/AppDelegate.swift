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
    // Создаём экземпляр класса, для управлением уведомлениями. current возвращет обект для центра уведомлений
    let notificationCenter = UNUserNotificationCenter.current()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Вызываем метод для запроса уведомлений
        requestAutorisation()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    

    // Метод для запроса у пользователя разрешения на отправку уведомлений
    func requestAutorisation() {
        // Метод запроса авторизации. options это те уведомления которые мы хотим отправлять. Булево значение обозночает, прошла авторизация или нет
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Разрешение получено: \(granted)")
            
            // Если авторизация проходит успешно, мы получаем перечень доступных уведомлений
            guard granted else { return }
            self.getNotificationsSetting()
        }
    }
    
    // Метод для отслеживания настроек (включены или отключены уведомления)
    func getNotificationsSetting() {
        // Проверяем состояние авторизаций или параметров уведомлений
        notificationCenter.getNotificationSettings { (settings) in
            print("Настройки уведомлений: \(settings)")
        }
    }

}

