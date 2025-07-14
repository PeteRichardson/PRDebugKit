//
//  debugging.swift
//  debugging
//
//  Created by Peter Richardson on 7/13/25.
//

//  Works with both GUI (using OSLog) and CLI (using SwiftLog)

import Foundation

#if canImport(os)
import os
#endif

#if canImport(Logging)
internal import Logging
#endif

public enum LogLevel {
    case trace, debug, info, notice, warning, error, critical
}

// MARK: - Common Logging Protocol

public protocol SharedLogger {
    func debug(_ message: @autoclosure @escaping () -> String)
    func info(_ message: @autoclosure  @escaping () -> String)
    func error(_ message: @autoclosure @escaping () -> String)
}

// MARK: - OSLogger (for GUI apps)

#if canImport(os)
public struct OSLogger: SharedLogger {
    private let logger: os.Logger

    init(subsystem: String = defaultSubsystem,
         category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    public func debug(_ message: @autoclosure  @escaping () -> String) {
        logger.debug("\(message(), privacy: .public)")
    }

    public func info(_ message: @autoclosure  @escaping () -> String) {
        logger.info("\(message(), privacy: .public)")
    }
    
    public func error(_ message: @autoclosure  @escaping () -> String) {
        logger.error("\(message(), privacy: .public)")
    }
}
#endif

// MARK: - SwiftLogAdapter (for CLI apps)

#if canImport(Logging)

public func bootstrapLogging() {
    LoggingSystem.bootstrap(StreamLogHandler.standardError)
}

public struct SwiftLogAdapter: SharedLogger {
    private let logger: Logging.Logger

    public init(label: String, level: LogLevel = .info) {
        var logger = Logger(label: label)
        logger.logLevel = Self.translate(level)
        self.logger = logger
    }

    private static func translate(_ level: LogLevel) -> Logging.Logger.Level {
        switch level {
        case .trace: return .trace
        case .debug: return .debug
        case .info: return .info
        case .notice: return .notice
        case .warning: return .warning
        case .error: return .error
        case .critical: return .critical
        }
    }

    public func debug(_ message: @autoclosure () -> String) {
        logger.debug(.init(stringLiteral: message()))
    }

    public func info(_ message: @autoclosure () -> String) {
        logger.info(.init(stringLiteral: message()))
    }

    public func error(_ message: @autoclosure () -> String) {
        logger.error(.init(stringLiteral: message()))
    }
}
#endif
