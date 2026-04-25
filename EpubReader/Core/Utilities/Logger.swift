import Foundation
import os

/// Global logging facade backed by `os.Logger`.
///
/// All app code routes through `Log` instead of `print`. The subsystem is
/// derived from `Bundle.main.bundleIdentifier`; the `category` is provided
/// per call site (defaults to the source file ID) so log output is grouped
/// meaningfully in Console.app and Instruments.
public struct Log: Sendable {

    public static let shared = Log()

    private let subsystem: String

    private init() {
        self.subsystem = Bundle.main.bundleIdentifier ?? "com.yourname.epubreader"
    }

    private func logger(for category: String) -> os.Logger {
        os.Logger(subsystem: subsystem, category: category)
    }

    public func debug(
        _ message: @autoclosure () -> String,
        category: String = #fileID
    ) {
        logger(for: category).debug("\(message(), privacy: .public)")
    }

    public func info(
        _ message: @autoclosure () -> String,
        category: String = #fileID
    ) {
        logger(for: category).info("\(message(), privacy: .public)")
    }

    public func error(
        _ message: @autoclosure () -> String,
        category: String = #fileID
    ) {
        logger(for: category).error("\(message(), privacy: .public)")
    }
}
