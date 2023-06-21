import Foundation

public class ContainerError: Error, CustomDebugStringConvertible, CustomStringConvertible {
    public let type: Message
    private let filename: String
    private let method: String
    private let line: Int

    public init(_ type: Message, path: String = #file, function: String = #function, line: Int = #line) {
        if let file = path.split(separator: "/").last {
            filename = String(file)
        } else {
            filename = path
        }
        method = function
        self.line = line
        self.type = type
    }

    open var debugDescription: String { "ContainerError \(filename):\(line) - \(method) => \(type.message)" }
    open var description: String { "ContainerError \(filename):\(line) - \(method) => \(type.message)" }

    public enum Message {
        case notFound(file: String, line: Int)

        var message: String {
            switch self {
            case let .notFound(file, line):
                return "No dependency registered for please use register to specify what you want to inject. accessed \(file):\(line)"
            }
        }
    }
}
