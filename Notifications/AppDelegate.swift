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
        requestAutorization()
        // Назначаем делегата, чтобы уведомление отображалось при активном приложении
        notificationCenter.delegate = self
        
        return true
    }

    // Метод отслеживающий возвращение в приложение (сообщает делегату, что приложение вновь активно)
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Вызываем метод, который обнудяет счетчик уведомлений на юейдже
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    

    // Метод для запроса у пользователя разрешения на отправку уведомлений
    func requestAutorization() {
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
    
    // Метод отвечает за расписание уведоплений
    func scheduleNotification(notificationType: String) {
        // Создаём экземпляр класса. Для настройки контента уведомлений
        let content = UNMutableNotificationContent()
        
        // Задаём параметры контента в уведомлении
        content.title = notificationType
        content.body = "Экземпляр создан " + notificationType
        content.sound = UNNotificationSound.default
        // Цифра, которая отображается на иконке приложения
        content.badge = 1
        
        // Создаём триггер вызывающий уведопление. Интервал указывается в секундах
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Создаём идентификатор для запроса уведомления
        let identifire = "Local Notification"
    
        // Создаём запрос уведомления
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        // Вызываем запрос уведомления через центр уведомлений и обрабатываем ошибку, если что то пойдет не так
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}

// Расширяем класс, для того, чтобы получить возможность получать уведомления, даже в том случае если приложение активно
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Метод для показа уведомлений во время активного приложения
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Отображаем уведомление со звуком
        completionHandler([.alert, .sound])
    }
    
    // Метод для того, чтобы по нажатию на уведомление, что то происходило
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Создаём действие которое происходит по нажатию на уведомление
        if response.notification.request.identifier == "Local Notification" {
            print("На уведомление нажали")
        }
        // Зачем то что то вызываем, он не объяснил зачем. Надо разобраться
        completionHandler()
    }
}
