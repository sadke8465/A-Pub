import Foundation
import os

/// Global logging facade backed by `os.Logger`.
///
/// All app code routes through `Log` instead of `print`. The subsystem is
/// derived from `Bundle.main.bundleIdentifier`; the `category` is provided
/// per call site (defaults to the source file ID) so log output is grouped
/// meaningfully in Console.app and Instruments.
public final class Log: @unchecked Sendable {

    public static let shared = Log()

    private let subsystem: String
    private let lock = OSAllocatedUnfairLock<[String: os.Logger]>(initialState: [:])

    private init() {
        guard let subsystem = Bundle.main.bundleIdentifier else {
            preconditionFailure("Could not determine bundle identifier for logger subsystem.")
        }
        self.subsystem = subsystem
    }

    private func logger(for category: String) -> os.Logger {
        lock.withLock { cache in
            if let existing = cache[category] {
                return existing
            }

            let created = os.Logger(subsystem: subsystem, category: category)
            cache[category] = created
            return created
        }
    }

    public func debug(
        _ message: @autoclosure () -> String,
        category: String = #fileID
    ) {
        logger(for: category).debug("\(message())")
    }

    public func info(
        _ message: @autoclosure () -> String,
        category: String = #fileID
    ) {
        logger(for: category).info("\(message())")
    }

    public func error(
        _ message: @autoclosure () -> String,
        category: String = #fileID
    ) {
        logger(for: category).error("\(message())")
    }
}
