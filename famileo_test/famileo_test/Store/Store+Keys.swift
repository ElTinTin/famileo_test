//
//  Store+Keys.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 18/08/2023.
//

import Foundation

extension Store {

    public enum Key: String, CaseIterable {
        case cocktails
    }

    public subscript(key: Key) -> Codable? {
        get {
            return queue.sync {
                return cache[key] as? Codable
            }
        }
        set {
            queue.sync(flags: .barrier) {
                cache[key] = newValue

                notificationsQueue.async {
                    self.postNotification(for: key)
                }
            }
        }
    }

}
