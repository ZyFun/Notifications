//
//  Notifications.swift
//  Notifications
//
//  Created by Дмитрий Данилин on 23.12.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    // Создаём экземпляр класса, для управлением уведомлениями. current возвращет обект для центра уведомлений
    let notificationCenter = UNUserNotificationCenter.current()
    
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
        // Идентификатор дял создания категории действия
        let userAction = "User Action"
        
        // Задаём параметры контента в уведомлении
        content.title = notificationType
        content.body = "Экземпляр создан " + notificationType
        content.sound = UNNotificationSound.default
        // Цифра, которая отображается на иконке приложения
        content.badge = 1
        // Включаем категорию в контент уведомления, для того чтобы пользовательские действия стали доступны
        content.categoryIdentifier = userAction
        
        // Проверяем, есть ли изображение в проекте
        guard let path = Bundle.main.path(forResource: "favicon", ofType: "png") else { return }
        // Создаём экземпляр класса с картинкой
        let url = URL(fileURLWithPath: path)
        
        // Проверяем на возможность создать связь
        do {
            let attachment =  try UNNotificationAttachment(identifier: "favicon", url: url, options: nil)
            // Добавляем привязку к контенту
            content.attachments = [attachment]
        } catch {
            print("Привязка не удалась")
        }
        
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
        
        // Идентификатор действия, позволяет пользователю отложить уведомление на некоторое время
        let snozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        // Идентификатор действия, позволяет пользователю удалить уведомление
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        // Создаём категорию для действий
        let category = UNNotificationCategory(identifier: userAction, actions: [snozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        // Регестрируем категорию в цетре уведомлений
        notificationCenter.setNotificationCategories([category])
    }
    
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
        
        // Выбираем действия выполняемые приложением, в зависимости от того, что выбрал пользователь
        // Таких действий можно добавлять до 4, не считая действий по умолчанию
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Свойство, которое явно отклоняет уведомление, например из центра уведомлений.
            print("Действие отклонено")
        case UNNotificationDefaultActionIdentifier: // Свойство, которое выполняет действие при тапе прямо на уведомление, открыв тем самым приложение
            print("По умолчанию")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notificationType: "Reminder") // Вызываем повторное появление уведомления
        case "Delete":
            print("Удалено")
        default:
            print("Что то пошло не так")
        }
        // Зачем то что то вызываем, он не объяснил зачем. Надо разобраться
        completionHandler()
    }

}
