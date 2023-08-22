//
//  Store+Notifications.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 18/08/2023.
//

import Foundation

#if canImport(Combine)
import Combine
#endif

public struct NotificationRegistrationToken {
    weak public var observer: NSObjectProtocol?
    public var token: NSObjectProtocol
    public var object: Any?
}

extension Store.Key {
    public var notificationName: Notification.Name {
        return Notification.Name(self.rawValue + "DidChangeNotification")
    }
}

extension NotificationCenter {

    open func addObserver(_ observer: Any, selector aSelector: Selector, key aKey: Store.Key, object anObject: Any? = nil) {
        addObserver(observer, selector: aSelector, name: aKey.notificationName, object: anObject)
    }

    open func addObserver(forKey key: Store.Key, object obj: Any? = nil, queue: OperationQueue? = OperationQueue.main, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return addObserver(forName: key.notificationName, object: obj, queue: queue, using: block)
    }

    open func removeObserver(_ observer: Any, key aKey: Store.Key, object anObject: Any? = nil) {
        removeObserver(observer, name: aKey.notificationName, object: anObject)
    }
}

extension Store {

    func postNotification(for key: Key) {
        let center = NotificationCenter.default

        var userInfo: [AnyHashable: Any]?

        queue.sync {
            if let value = cache[key], let nonEmptyValue = value {
                userInfo = [key: nonEmptyValue]
            } else {
                userInfo = nil
            }
        }

        center.post(name: key.notificationName, object: nil, userInfo: userInfo)
    }

    public func addObserver(forKey key: Key, observer: NSObjectProtocol?, object: Any?, queue: OperationQueue?, using: @escaping (Notification) -> Void) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        let name = key.notificationName
        var token: NSObjectProtocol?
        // Add the observer
        token = NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: { [weak self] notification in
            guard let `self` = self else {
                return
            }
            if let registrationToken = self.observers[name]?.first(where: { $0.token === token }), registrationToken.observer != nil {
                using(notification)
            } else {
                // Auto cleaning
                if let token = token {
                    self.removeObserver(name: name, token: token)
                }
            }
        })
        if observers[name] == nil {
            observers[name] = []
        }

        observers[name]?.append(NotificationRegistrationToken(observer: observer, token: token!, object: object))
    }

    private func removeObserver(name: Notification.Name, token: NSObjectProtocol) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        var newList: [NotificationRegistrationToken] = []
        observers[name]?.forEach { registrationToken in
            if registrationToken.token === token {
                NotificationCenter.default.removeObserver(registrationToken.token, name: name, object: registrationToken.object)
            } else {
                newList.append(registrationToken)
            }
        }

        observers[name]? = newList
    }

    public func removeObserver(forKey key: Key, observer: NSObjectProtocol?) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        let name = key.notificationName
        observers[name] = observers[name]?.filter { registrationToken -> Bool in
            if registrationToken.observer == nil || registrationToken.observer === observer {
                self.removeObserver(name: name, token: registrationToken.token)
                return false
            }
            return true
        }
    }

    private func removeObservers(name: Notification.Name) {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        observers[name]?.forEach { registrationToken in
            NotificationCenter.default.removeObserver(registrationToken.token, name: name, object: registrationToken.object)
        }
    }

    public func removeAllObservers() {
        defer {
            objc_sync_exit(self)
        }
        objc_sync_enter(self)
        for key in observers.keys {
            removeObservers(name: key)
        }
    }
}
