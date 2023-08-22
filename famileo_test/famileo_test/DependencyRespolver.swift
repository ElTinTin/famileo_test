//
//  DependencyRespolver.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 18/08/2023.
//

import Foundation

public extension Dependency.Name {
    static var store = Dependency.Name(rawValue: "store")
}

public struct Dependency {
    let value: AnyObject
}

extension Dependency {
     public struct Name: Hashable {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

public final class DependencyResolver {

    private static let shared = DependencyResolver()

    private var dependencies: [Dependency.Name: Dependency] = [:]
    private let dispatchQueue = DispatchQueue(label: "fr.famileo.test.dependencyResolver", qos: .userInitiated, attributes: .concurrent)

    @discardableResult
    static public func register<T>(name: Dependency.Name, dependency: T) -> T where T: AnyObject {
        shared.dispatchQueue.sync(flags: .barrier) {
            shared.dependencies[name] = Dependency(value: dependency)
            return dependency
        }
    }

    static public func resolve<T>(name: Dependency.Name, type: T.Type) -> T {
        shared.dispatchQueue.sync {
            guard let dependency = shared.dependencies[name]?.value as? T else {
                fatalError("dependency \(name.rawValue) not set.")
            }
            return dependency
        }
    }

    static public func resolveOptional<T>(name: Dependency.Name, type: T.Type) -> T? {
        shared.dispatchQueue.sync {
            return shared.dependencies[name]?.value as? T
        }
    }

    static public func unregister(name: Dependency.Name) {
        shared.dispatchQueue.sync(flags: .barrier) {
            shared.dependencies.removeValue(forKey: name)
        }
    }
}

@propertyWrapper
public struct Inject<Component> {
    let name: Dependency.Name
    var dependency: Component?

    public init(name: Dependency.Name) {
        self.name = name
    }

    public var wrappedValue: Component {
        get {
            return dependency ?? DependencyResolver.resolve(name: name, type: Component.self)
        }
        set {
            dependency = newValue
        }
    }
}
