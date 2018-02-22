//
//  Environment.swift
//  Pusher
//
//  Created by Jeff Kereakoglow on 2/21/18.
//  Copyright © 2018 Alexis Digital. All rights reserved.
//

import Foundation

final class Environment {
    private static let environmentVariables = ProcessInfo.processInfo.environment

    private init() {}

    static func variable(forKey key: EnvironmentVariableKey) -> String {
        return environmentVariables[key.rawValue]!
    }
}
