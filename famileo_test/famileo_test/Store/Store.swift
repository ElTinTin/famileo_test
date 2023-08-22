//
//  Store.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 18/08/2023.
//

import Foundation

public class Store {

    internal var cache: [Key: Codable?] = [:]
    internal var observers: [Notification.Name: [NotificationRegistrationToken]] = [:]
    internal let queue = DispatchQueue(label: "famileo-test.Store.queue", attributes: .concurrent)
    internal let notificationsQueue = DispatchQueue(label: "famileo-test.Store.notifications.queue")

    public init() {
    }

    func store(key: Key, value: Codable) {
        self[key] = value
    }

}

