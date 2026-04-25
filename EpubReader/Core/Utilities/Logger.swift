import Foundation
import os

public final class AppLogger {
    public static let shared = AppLogger(category: "App")

    private let logger: Logger

    public init(category: String) {
        let subsystem = Bundle.main.bundleIdentifier ?? "com.yourname.epubreader"
        logger = Logger(subsystem: subsystem, category: category)
    }

    public func debug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }

    public func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    public func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
}
