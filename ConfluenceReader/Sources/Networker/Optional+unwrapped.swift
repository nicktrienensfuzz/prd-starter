//
//  Optional+unwrapped.swift
//
//
//  Created by Nicholas Trienens on 8/11/21.
//

import Foundation

public extension Optional {
    func unwrapped(path: String = #file, function: String = #function, line: Int = #line) throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw UnwrappingError("Failed to unwrap value: `\(type(of: self))`", path: path, function: function, line: line)
        }
    }
}

public struct UnwrappingError: Error, CustomDebugStringConvertible, CustomStringConvertible, LocalizedError {
    public let message: String
    private let filename: String
    private let method: String
    private let line: Int

    public init(_ message: String, path: String = #file, function: String = #function, line: Int = #line) {
        filename = path.split(separator: "/").last?.asString ?? path
        method = function
        self.line = line
        self.message = message
    }

    public var debugDescription: String { "\(filename):\(line) - \(method) => \(message)" }
    public var description: String { "\(filename):\(line) - \(method) => \(message)" }
    public var errorDescription: String? { debugDescription }
}

// MARK: - Substring Extension
public extension Substring {
    var asString: String {
        String(self)
    }
}

public extension String {
    var asUrl: URL? {
        URL(string: self)
    }
}
